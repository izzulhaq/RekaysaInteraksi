import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthentifikasiController extends GetxController {
  // Instance Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Loading State
  var isLoading = false.obs;

  // Controllers Login
  final loginUserC = TextEditingController();
  final loginPassC = TextEditingController();
  var isPasswordHidden = true.obs;

  // Controllers Register
  final fullNameC = TextEditingController();
  final emailC = TextEditingController(); // Pastikan ini untuk register
  // Field lain seperti Class/RollNo butuh Firestore (Database), 
  // untuk Auth sementara kita pakai Email & Password saja.
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

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // --- FUNGSI REGISTER ---
  Future<void> registerUser() async {
    if (emailC.text.isEmpty || fullNameC.text.isEmpty) {
      Get.snackbar('Error', 'Email dan Nama harus diisi',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      // 1. Buat User di Firebase Auth
      // Catatan: Karena UI Register tidak ada input password, 
      // saya buat password default sementara atau Anda harus tambah input password di UI Register.
      // Sesuai gambar UI Anda hanya ada 'Add to contact', biasanya password digenerate atau input hidden.
      // DISINI SAYA ASUMSIKAN Password default "123456" atau ambil dari input jika ada.
      String defaultPassword = "password123"; 

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailC.text,
        password: defaultPassword, // Sebaiknya tambahkan field password di form register
      );

      // 2. Update Nama User (Opsional)
      await userCredential.user?.updateDisplayName(fullNameC.text);

      Get.snackbar('Berhasil', 'User berhasil dibuat',
          backgroundColor: Colors.green, colorText: Colors.white);
      
      // 3. Kembali ke Login atau Langsung Masuk
      Get.offAllNamed('/home');
      
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Terjadi kesalahan',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // --- FUNGSI LOGIN ---
  Future<void> loginUser() async {
    if (loginUserC.text.isEmpty || loginPassC.text.isEmpty) {
      Get.snackbar('Error', 'Email dan Password harus diisi',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: loginUserC.text, // Pastikan input ini berisi EMAIL, bukan sekedar username
        password: loginPassC.text,
      );

      Get.offAllNamed('/home');
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Error', 'Email tidak terdaftar', backgroundColor: Colors.red, colorText: Colors.white);
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Password salah', backgroundColor: Colors.red, colorText: Colors.white);
      } else {
        Get.snackbar('Error', e.message ?? 'Gagal login', backgroundColor: Colors.red, colorText: Colors.white);
      }
    } finally {
      isLoading.value = false;
    }
  }
}