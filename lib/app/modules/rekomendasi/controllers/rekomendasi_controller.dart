import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RekomendasiController extends GetxController {
  // Controller untuk input text
  final locationC = TextEditingController();
  final budgetC = TextEditingController();

  @override
  void onClose() {
    // Membersihkan controller saat halaman ditutup untuk mencegah memory leak
    locationC.dispose();
    budgetC.dispose();
    super.onClose();
  }

  void cariRekomendasi() {
    print("Mencari di: ${locationC.text} dengan budget: ${budgetC.text}");
  }
}