import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Jangan lupa import ini

class AuthentifikasiController extends GetxController {
  // Instance Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Loading State
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  // --- CONTROLLER REGISTER (4 Input) ---
  final fullNameC = TextEditingController();
  final registerEmailC = TextEditingController();
  final registerPassC = TextEditingController();
  final confirmPassC = TextEditingController(); // Input Re-Password

  // --- CONTROLLER LOGIN ---
  final loginEmailC = TextEditingController();
  final loginPassC = TextEditingController();

  @override
  void onClose() {
    // Bersihkan memori
    fullNameC.dispose();
    registerEmailC.dispose();
    registerPassC.dispose();
    confirmPassC.dispose();
    loginEmailC.dispose();
    loginPassC.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // --- FUNGSI REGISTER ---
  Future<void> registerUser() async {
    // 1. Validasi: Pastikan tidak ada yang kosong
    if (fullNameC.text.isEmpty || 
        registerEmailC.text.isEmpty || 
        registerPassC.text.isEmpty || 
        confirmPassC.text.isEmpty) {
      Get.snackbar('Error', 'Semua kolom wajib diisi',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // 2. Validasi: Cek apakah Password dan Re-Password SAMA
    if (registerPassC.text != confirmPassC.text) {
      Get.snackbar('Error', 'Password dan Re-Password tidak sama!',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // 3. Validasi: Panjang Password (Firebase minimal 6 karakter)
    if (registerPassC.text.length < 6) {
      Get.snackbar('Error', 'Password minimal 6 karakter',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      
      // A. Buat User di Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: registerEmailC.text.trim(),
        password: registerPassC.text,
      );

      // B. Simpan Data Dasar ke Firestore (Database)
      // Meskipun input sedikit, tetap simpan di DB agar punya record user yang rapi.
      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;

        await _firestore.collection('users').doc(uid).set({
          'uid': uid,
          'fullName': fullNameC.text,
          'email': registerEmailC.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          // Default preferences (bisa disiapkan untuk fitur rekomendasi nanti)
          'preferences': {
             'budget': 'standar', 
             'isSpicyLover': false
          }
        });
        
        // Update Nama di Auth (Display Name)
        await userCredential.user?.updateDisplayName(fullNameC.text);
      }

      Get.snackbar('Berhasil', 'Registrasi Sukses!');
      Get.offAllNamed('/home'); // Atau ke '/login'
      
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'Password terlalu lemah.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email sudah terdaftar.';
      } else if (e.code == 'invalid-email') {
        message = 'Format email salah.';
      } else {
        message = e.message ?? 'Gagal registrasi.';
      }
      Get.snackbar('Error', message, backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan sistem.', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // --- FUNGSI LOGIN ---
  Future<void> loginUser() async {
    if (loginEmailC.text.isEmpty || loginPassC.text.isEmpty) {
      Get.snackbar('Error', 'Email dan Password harus diisi',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: loginEmailC.text.trim(),
        password: loginPassC.text,
      );

      Get.offAllNamed('/home');
      
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'Email tidak ditemukan.';
      } else if (e.code == 'wrong-password') {
        message = 'Password salah.'; // Catatan: Demi keamanan, Firebase kadang menyamarkan error ini
      } else {
        message = 'Email atau Password salah.';
      }
      Get.snackbar('Error', message, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
  // --- TAMBAHKAN INI DI DALAM AuthentifikasiController ---
  
  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      Get.snackbar("Error", "Masukkan email anda terlebih dahulu", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      await _auth.sendPasswordResetEmail(email: email);
      
      Get.back(); // Tutup Modal/Dialog
      Get.snackbar(
        "Email Terkirim", 
        "Cek inbox/spam email anda untuk mereset password", 
        backgroundColor: Colors.green, 
        colorText: Colors.white,
        duration: const Duration(seconds: 4)
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Gagal", e.message ?? "Terjadi kesalahan", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
  // Fungsi Logout (Tambahan)
  void logout() async {
    await _auth.signOut();
    Get.offAllNamed('/login');
  }
}