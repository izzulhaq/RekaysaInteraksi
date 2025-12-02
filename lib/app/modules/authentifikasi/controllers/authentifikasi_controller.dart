import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthentifikasiController extends GetxController {
  // Variable untuk Login
  final loginUserC = TextEditingController();
  final loginPassC = TextEditingController();
  var isPasswordHidden = true.obs; // Untuk toggle icon mata

  // Variable untuk Register / Add Contact
  final fullNameC = TextEditingController();
  final emailC = TextEditingController();
  final classC = TextEditingController();
  final sectionC = TextEditingController();
  final rollNoC = TextEditingController();

  @override
  void onClose() {
    loginUserC.dispose();
    loginPassC.dispose();
    fullNameC.dispose();
    emailC.dispose();
    classC.dispose();
    sectionC.dispose();
    rollNoC.dispose();
    super.onClose();
  }

  // Fungsi Toggle Password
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
}