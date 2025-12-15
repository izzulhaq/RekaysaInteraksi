import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/food_option.dart';

// Enum untuk menandakan tahapan layar
enum VotingStep { setup, voting, waiting, result }

class VotingFoodController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- STATE MANAGEMENT ---
  var currentStep = VotingStep.setup.obs; // Mulai dari setup
  var isLoading = false.obs;

  // --- DATA ---
  // Kita hardcode opsi makanan sesuai screenshot Anda
  final options = <FoodOption>[
    FoodOption(id: 'soto', name: 'Soto Miring', rating: 4.8, distanceMinutes: 5, price: 35000),
    FoodOption(id: 'mie', name: 'Mie Ayam Bangka', rating: 4.7, distanceMinutes: 7, price: 28000),
    FoodOption(id: 'nasgor', name: 'Nasi Goreng Gila', rating: 4.5, distanceMinutes: 10, price: 25000),
  ];

  // Data Voting Realtime
  var voteCounts = <String, int>{}.obs; 
  var totalVoters = 6; // Hardcode sesuai screenshot "4 dari 6"
  var currentVoteCount = 0.obs;
  var myChoiceId = "".obs;

  @override
  void onInit() {
    super.onInit();
    // Dengarkan perubahan data voting dari Firebase
    _listenToVotes();
  }

  void _listenToVotes() {
    _firestore.collection('votes').snapshots().listen((snapshot) {
      var tempCounts = <String, int>{};
      int total = 0;
      String myUid = _auth.currentUser?.uid ?? "";
      String? myVote;

      for (var doc in snapshot.docs) {
        String foodId = doc.get('foodId');
        
        // Hitung total per makanan
        tempCounts[foodId] = (tempCounts[foodId] ?? 0) + 1;
        
        // Hitung total suara masuk
        total++;

        // Cek suara saya
        if (doc.id == myUid) {
          myVote = foodId;
        }
      }

      voteCounts.value = tempCounts;
      currentVoteCount.value = total;
      
      // Update Step Logika Otomatis
      if (myVote != null) {
        myChoiceId.value = myVote;
        // Jika sudah vote, pindah ke waiting (kecuali sedang liat result)
        if (currentStep.value != VotingStep.result) {
          currentStep.value = VotingStep.waiting;
        }
      }

      // Jika semua sudah vote, bisa otomatis ke result (opsional)
      // if (total >= totalVoters) showResult();
    });
  }

  // --- ACTIONS ---

  // 1. Dari Setup -> Mulai Vote
  void startVotingSession() {
    // Di sini bisa tambah logika simpan filter ke firebase jika perlu
    currentStep.value = VotingStep.voting;
  }

  // 2. Melakukan Vote
  void submitVote(String foodId) async {
    String? uid = _auth.currentUser?.uid;
    if (uid == null) return;

    isLoading.value = true;
    // Simpan ke Firebase
    await _firestore.collection('votes').doc(uid).set({
      'foodId': foodId,
      'timestamp': FieldValue.serverTimestamp(),
    });
    
    // UI akan update otomatis via listener di atas
    isLoading.value = false;
  }

  // 3. Batalkan Vote
  void cancelVote() async {
    String? uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _firestore.collection('votes').doc(uid).delete();
      myChoiceId.value = "";
      currentStep.value = VotingStep.voting; // Kembali ke list
    }
  }

  // 4. Lihat Hasil (DEBUG Button di screenshot)
  void showResult() {
    currentStep.value = VotingStep.result;
  }

  // Logic cari pemenang
  FoodOption? get winner {
    if (voteCounts.isEmpty) return null;
    var sortedEntries = voteCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // Urutkan terbesar
    String winnerId = sortedEntries.first.key;
    return options.firstWhereOrNull((o) => o.id == winnerId);
  }

  // Reset (Untuk demo ulang)
  void resetDemo() async {
    // Hapus semua dokumen di collection votes (Hati-hati, ini menghapus data!)
    var snap = await _firestore.collection('votes').get();
    for (var doc in snap.docs) {
      await doc.reference.delete();
    }
    currentStep.value = VotingStep.setup;
    myChoiceId.value = "";
  }
}