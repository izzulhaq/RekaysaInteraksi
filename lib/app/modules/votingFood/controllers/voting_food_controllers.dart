import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/food_option.dart';

enum VotingStep { setup, voting, waiting, result }

class VotingFoodController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- STATE MANAGEMENT ---
  var currentStep = VotingStep.setup.obs;
  var isLoading = false.obs;

  // --- FORM INPUT ---
  final addressC = TextEditingController(); // Input Lokasi Manual
  final budgetC = TextEditingController();
  final vetoC = TextEditingController();

  // --- DATA ---
  final options = <FoodOption>[].obs; // Data Mentah dari Google
  var displayedOptions = <FoodOption>[].obs; // Data setelah difilter Veto

  // Variabel Voting Realtime
  var voteCounts = <String, int>{}.obs;
  var totalVoters = 6; // Target user (bisa diubah dinamis nanti)
  var currentVoteCount = 0.obs;
  var myChoiceId = "".obs;

  @override
  void onInit() {
    super.onInit();
    _listenToVotes(); // Mulai dengarkan data dari Firebase
  }

  @override
  void onClose() {
    addressC.dispose();
    budgetC.dispose();
    vetoC.dispose();
    super.onClose();
  }

  // --- FUNGSI 1: AMBIL DATA DARI GOOGLE PLACES API (LIVE) ---
  Future<void> fetchFromGoogle(String queryLokasi) async {
    // ⚠️ TEMPEL API KEY ANDA DI SINI (Ganti teks di bawah)
    String apiKey = "AIzaSyDE0dwP4QKBE7pRUuj9LVV33ha902p8_3Y"; 

    // Validasi sederhana agar tidak lupa
    if (apiKey == "AIzaSyDE0dwP4QKBE7pRUuj9LVV33ha902p8_3Y" || apiKey.isEmpty) {
       Get.snackbar("Error Config", "Masukkan API Key Google di Controller dulu!");
       return;
    }

    String url = "https://places.googleapis.com/v1/places:searchText";

    try {
      isLoading.value = true;
      options.clear(); // Bersihkan data lama

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': apiKey,
          // FieldMask: Hanya ambil data yg dibutuhkan (Nama, Rating, Harga, ID, Alamat)
          'X-Goog-FieldMask': 'places.displayName,places.rating,places.priceLevel,places.id,places.formattedAddress' 
        },
        body: jsonEncode({
          "textQuery": "Restoran di $queryLokasi", 
          "minRating": 4.0, // Filter minimal bintang 4 dari Google
          "maxResultCount": 10, // Ambil 10 restoran saja agar tidak bingung
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List places = data['places'] ?? [];

        if (places.isEmpty) {
          Get.snackbar("Info", "Tidak ditemukan restoran di lokasi '$queryLokasi'.");
          return;
        }

        // Konversi Data Google ke Model FoodOption kita
        var googleResults = places.map((place) {
          // Konversi Level Harga Google (PRICE_LEVEL_MODERATE, dll) ke Rupiah kasar
          double estimatedPrice = 25000; 
          String pl = place['priceLevel'] ?? "";
          if (pl == "PRICE_LEVEL_MODERATE") estimatedPrice = 50000;
          if (pl == "PRICE_LEVEL_EXPENSIVE") estimatedPrice = 100000;
          if (pl == "PRICE_LEVEL_VERY_EXPENSIVE") estimatedPrice = 200000;

          return FoodOption(
            id: place['name'].toString().split('/').last, // ID Unik Google Places
            name: place['displayName']['text'],
            rating: (place['rating'] ?? 0.0).toDouble(),
            distanceMinutes: 10, // Jarak default (Google Matrix API butuh biaya tambahan)
            price: estimatedPrice,
          );
        }).toList();

        options.assignAll(googleResults);
        
      } else {
        print("Google Error Body: ${response.body}");
        Get.snackbar("Gagal", "Error Google API: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
      Get.snackbar("Error", "Gagal koneksi internet atau API bermasalah.");
    } finally {
      isLoading.value = false;
    }
  }

  // --- FUNGSI 2: MULAI SESI & FILTER VETO ---
  void startVotingSession() async {
    // 1. Validasi Input Lokasi
    if (addressC.text.isEmpty) {
      Get.snackbar("Error", "Harap isi lokasi area makan terlebih dahulu");
      return;
    }

    // 2. Panggil API Google (Tunggu sampai selesai)
    await fetchFromGoogle(addressC.text);

    // Jika gagal ambil data atau kosong, berhenti di sini
    if (options.isEmpty) return;

    // 3. Terapkan Filter Veto
    String vetoInput = vetoC.text.toLowerCase();
    
    if (vetoInput.isNotEmpty) {
      List<String> vetoKeywords = vetoInput.split(',').map((e) => e.trim()).toList();
      
      var finalOptions = options.where((food) {
        bool isVetoed = false;
        for (var keyword in vetoKeywords) {
          // Jika nama restoran mengandung kata terlarang (misal: "sate")
          if (keyword.isNotEmpty && food.name.toLowerCase().contains(keyword)) {
            isVetoed = true;
            break;
          }
        }
        return !isVetoed; // Lolos filter jika TIDAK diveto
      }).toList();
      
      if (finalOptions.isEmpty) {
         Get.snackbar("Waduh", "Semua restoran kena Veto! Kurangi kata kunci veto.");
         return;
      }
      displayedOptions.assignAll(finalOptions);
    } else {
      // Tidak ada veto, tampilkan semua hasil Google
      displayedOptions.assignAll(options);
    }

    // 4. Pindah ke Halaman List Voting
    currentStep.value = VotingStep.voting;
  }

  // --- FUNGSI 3: FIREBASE & VOTING LOGIC ---
  void _listenToVotes() {
     _firestore.collection('votes').snapshots().listen((snapshot) {
      var tempCounts = <String, int>{};
      int total = 0;
      String myUid = _auth.currentUser?.uid ?? "";
      String? myVote;

      for (var doc in snapshot.docs) {
        String foodId = doc.get('foodId');
        tempCounts[foodId] = (tempCounts[foodId] ?? 0) + 1;
        total++;
        if (doc.id == myUid) {
          myVote = foodId;
        }
      }
      voteCounts.value = tempCounts;
      currentVoteCount.value = total;
      
      // Auto-move logic: Jika saya sudah vote, pindah ke waiting screen
      if (myVote != null) {
        myChoiceId.value = myVote;
        if (currentStep.value != VotingStep.result) {
          currentStep.value = VotingStep.waiting;
        }
      }
    });
  }

  void submitVote(String foodId) async {
    String? uid = _auth.currentUser?.uid;
    if (uid == null) return;
    isLoading.value = true;
    await _firestore.collection('votes').doc(uid).set({
      'foodId': foodId,
      'timestamp': FieldValue.serverTimestamp(),
    });
    isLoading.value = false;
  }

  void cancelVote() async {
    String? uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _firestore.collection('votes').doc(uid).delete();
      myChoiceId.value = "";
      currentStep.value = VotingStep.voting;
    }
  }

  void showResult() {
    currentStep.value = VotingStep.result;
  }

  // Logika menentukan pemenang
  FoodOption? get winner {
    if (voteCounts.isEmpty) return null;
    var sortedEntries = voteCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // Urutkan suara terbanyak
    
    try {
       // Cari detail restoran dari list options berdasarkan ID pemenang
       // Menggunakan try-catch jaga-jaga jika ID tidak ditemukan di list (kasus jarang)
       return options.firstWhere((o) => o.id == sortedEntries.first.key);
    } catch (e) {
      return null;
    }
  }

  // Reset semua data (Hati-hati: Menghapus data di database)
  void resetDemo() async {
    var snap = await _firestore.collection('votes').get();
    for (var doc in snap.docs) {
      await doc.reference.delete();
    }
    currentStep.value = VotingStep.setup;
    myChoiceId.value = "";
    addressC.clear();
    budgetC.clear();
    vetoC.clear();
    options.clear();
    displayedOptions.clear();
  }
}