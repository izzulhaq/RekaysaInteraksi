import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/food_option.dart'; // Pastikan path model ini benar

enum VotingStep { setup, voting, waiting, result }

class VotingFoodController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- STATE MANAGEMENT ---
  var currentStep = VotingStep.setup.obs;
  var isLoading = false.obs;

  // Data Room
  var roomId = "".obs;          // Kode Room Unik
  var isHost = false.obs;       // Apakah user ini pembuat room?
  var roomStatus = "setup".obs; // setup, voting, completed

  // --- FORM INPUT ---
  final addressC = TextEditingController(); // Input Lokasi
  final budgetC = TextEditingController();  // (Opsional, belum dipakai di filter API)
  final vetoC = TextEditingController();    // Filter Veto
  final joinCodeC = TextEditingController(); // Input Kode Join Teman

  // --- DATA ---
  // Kita simpan data makanan sebagai Map agar mudah disimpan ke Firestore
  var candidates = <Map<String, dynamic>>[].obs; 
  
  // Variabel Voting Realtime
  var totalVoters = 0.obs;      // Jumlah orang di dalam room
  var currentVoteCount = 0.obs; // Jumlah orang yang sudah vote
  var hasVoted = false.obs;     // Apakah saya sudah vote?

  // API Key Google (Ganti dengan milik Anda)
  final String apiKey = "AIzaSyDE0dwP4QKBE7pRUuj9LVV33ha902p8_3Y"; 

  @override
  void onClose() {
    addressC.dispose();
    budgetC.dispose();
    vetoC.dispose();
    joinCodeC.dispose();
    super.onClose();
  }

  // --- BAGIAN 1: SETUP ROOM (HOST) ---
  
  // Langkah 1.1: Ambil Data dari Google & Filter Veto
  // Update fungsi ini di dalam VotingFoodController
  Future<List<Map<String, dynamic>>> _fetchAndFilterCandidates() async {
    if (addressC.text.isEmpty) {
      Get.snackbar("Error", "Isi lokasi dulu ya (misal: Malang)");
      return [];
    }

    String url = "https://places.googleapis.com/v1/places:searchText";
    List<Map<String, dynamic>> results = [];

    try {
      print("Mencari di Google: Restoran di ${addressC.text}..."); // DEBUG 1

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': apiKey, // Pastikan apiKey ini benar
          'X-Goog-FieldMask': 'places.displayName,places.rating,places.priceLevel,places.id,places.formattedAddress'
        },
        body: jsonEncode({
          "textQuery": "Restoran di ${addressC.text}",
          "minRating": 4.0,
          "maxResultCount": 10,
        }),
      );

      print("Status Code: ${response.statusCode}"); // DEBUG 2
      print("Response Body: ${response.body}");     // DEBUG 3 (PENTING!)

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List places = data['places'] ?? [];

        if (places.isEmpty) {
          print("Google mengembalikan list kosong []");
        }

        // Filter Veto
        String vetoInput = vetoC.text.toLowerCase();
        List<String> vetoKeywords = vetoInput.split(',').map((e) => e.trim()).toList();

        for (var place in places) {
          String name = place['displayName']['text'];
          bool isVetoed = false;

          if (vetoInput.isNotEmpty) {
            for (var keyword in vetoKeywords) {
              if (keyword.isNotEmpty && name.toLowerCase().contains(keyword)) {
                isVetoed = true;
                break;
              }
            }
          }

          if (!isVetoed) {
            double price = 25000;
            String pl = place['priceLevel'] ?? "";
            if (pl == "PRICE_LEVEL_MODERATE") price = 50000;
            if (pl == "PRICE_LEVEL_EXPENSIVE") price = 100000;

            results.add({
              'id': place['name'].toString().split('/').last,
              'name': name,
              'rating': (place['rating'] ?? 0.0).toDouble(),
              'address': place['formattedAddress'],
              'price': price,
              'voteCount': 0,
            });
          }
        }
      } else {
        Get.snackbar("Error API", "Google Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error System: $e");
      Get.snackbar("Error", "Gagal koneksi: $e");
    }
    return results;
  }

  // Langkah 1.2: Buat Room di Firestore
  void createRoom() async {
    isLoading.value = true;
    
    // 1. Ambil Data Makanan
    var initialCandidates = await _fetchAndFilterCandidates();
    
    if (initialCandidates.isEmpty) {
      Get.snackbar("Zonk", "Tidak ada restoran ditemukan. Coba ganti lokasi.");
      isLoading.value = false;
      return;
    }

    try {
      // 2. Generate Kode Room (5 Digit Angka)
      String newRoomId = (10000 + Random().nextInt(90000)).toString();
      String uid = _auth.currentUser?.uid ?? "anon";

      // 3. Simpan ke Firestore
      await _firestore.collection('voting_rooms').doc(newRoomId).set({
        'roomId': newRoomId,
        'hostId': uid,
        'status': 'voting', // Langsung mulai
        'createdAt': FieldValue.serverTimestamp(),
        'candidates': initialCandidates, // List makanan disimpan disini
        'voters': [uid], // Host otomatis jadi peserta pertama
        'votes': {} // Map untuk menyimpan siapa pilih apa {uid: foodId}
      });

      // 4. Set State Lokal
      roomId.value = newRoomId;
      isHost.value = true;
      hasVoted.value = false;
      
      // 5. Mulai Dengarkan Perubahan
      _listenToRoom(newRoomId);

    } catch (e) {
      Get.snackbar("Error", "Gagal membuat room: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // --- BAGIAN 2: JOIN ROOM (GUEST) ---
  void joinRoom() async {
    String code = joinCodeC.text.trim();
    if (code.isEmpty) {
      Get.snackbar("Error", "Masukkan kode room dulu");
      return;
    }

    isLoading.value = true;

    try {
      DocumentReference roomRef = _firestore.collection('voting_rooms').doc(code);
      var doc = await roomRef.get();

      if (!doc.exists) {
        Get.snackbar("Error", "Room tidak ditemukan!");
        return;
      }

      // Masukkan user ke daftar voters di database
      String uid = _auth.currentUser?.uid ?? "anon";
      await roomRef.update({
        'voters': FieldValue.arrayUnion([uid])
      });

      roomId.value = code;
      isHost.value = false;
      
      _listenToRoom(code);

    } catch (e) {
      Get.snackbar("Error", "Gagal join: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // --- BAGIAN 3: STREAM LISTENER (REAL-TIME SYNC) ---
  void _listenToRoom(String id) {
    _firestore.collection('voting_rooms').doc(id).snapshots().listen((snapshot) {
      if (!snapshot.exists) return;

      var data = snapshot.data() as Map<String, dynamic>;
      String uid = _auth.currentUser?.uid ?? "anon";

      // 1. Update List Makanan & Suara
      List<dynamic> rawCandidates = data['candidates'] ?? [];
      candidates.value = rawCandidates.map((e) => e as Map<String, dynamic>).toList();

      // 2. Update Info Voter
      List voters = data['voters'] ?? [];
      Map<String, dynamic> votesMap = data['votes'] ?? {};
      
      totalVoters.value = voters.length;
      currentVoteCount.value = votesMap.length;

      // 3. Cek Status Saya
      if (votesMap.containsKey(uid)) {
        hasVoted.value = true;
      } else {
        hasVoted.value = false;
      }

      // 4. Navigasi Halaman Otomatis
      String status = data['status'];
      roomStatus.value = status;

      if (status == 'voting') {
        if (hasVoted.value) {
          currentStep.value = VotingStep.waiting;
        } else {
          currentStep.value = VotingStep.voting;
        }
      } else if (status == 'completed') {
        currentStep.value = VotingStep.result;
      }
    });
  }

  // --- BAGIAN 4: ACTIONS (VOTE, CANCEL, FINISH) ---
  
  void submitVote(String foodId) async {
    String uid = _auth.currentUser?.uid ?? "anon";
    DocumentReference roomRef = _firestore.collection('voting_rooms').doc(roomId.value);

    // Gunakan Transaction agar hitungan suara akurat
    _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(roomRef);
      if (!snapshot.exists) return;

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<dynamic> currentCandidates = data['candidates'];
      Map<String, dynamic> currentVotes = data['votes'] ?? {};

      // 1. Cek jika user sudah vote sebelumnya (untuk mencegah double vote)
      if (currentVotes.containsKey(uid)) return;

      // 2. Tambah suara ke kandidat yang dipilih
      for (var i = 0; i < currentCandidates.length; i++) {
        if (currentCandidates[i]['id'] == foodId) {
          currentCandidates[i]['voteCount'] = (currentCandidates[i]['voteCount'] ?? 0) + 1;
          break;
        }
      }

      // 3. Catat user ini memilih apa
      currentVotes[uid] = foodId;

      // 4. Update Database
      transaction.update(roomRef, {
        'candidates': currentCandidates,
        'votes': currentVotes
      });
    });
  }

  void finishVoting() async {
    // Hanya Host yang bisa menutup voting
    if (!isHost.value) return; 

    await _firestore.collection('voting_rooms').doc(roomId.value).update({
      'status': 'completed'
    });
  }

  void resetVoting() {
    // Kembali ke menu awal (lokal saja)
    currentStep.value = VotingStep.setup;
    roomId.value = "";
    addressC.clear();
    candidates.clear();
  }

  // --- BAGIAN 5: RESULT & MAPS ---
  
  Map<String, dynamic>? get winner {
    if (candidates.isEmpty) return null;
    
    // Urutkan berdasarkan voteCount terbanyak
    var sorted = List<Map<String, dynamic>>.from(candidates);
    sorted.sort((a, b) => (b['voteCount'] ?? 0).compareTo(a['voteCount'] ?? 0));
    
    // Jika tidak ada suara sama sekali
    if (sorted.first['voteCount'] == 0) return null;

    return sorted.first;
  }

  void launchWinnerMap() async {
    final win = winner;
    if (win == null) return;

    final Uri url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(win['name'])}"
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
       Get.snackbar("Error", "Tidak bisa membuka aplikasi Maps");
    }
  }
}