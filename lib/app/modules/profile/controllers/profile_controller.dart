import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../authentifikasi/views/authentifikasi_view.dart';
import '../../authentifikasi/controllers/authentifikasi_controller.dart';
// Note: Saya hapus import authentifikasi_controller.dart karena tidak aman dipakai disini

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- OBSERVABLE DATA ---
  var isLoading = true.obs;
  var fullName = ''.obs;
  var email = ''.obs;
  var photoUrl = ''.obs;

  // --- CONTROLLERS: EDIT PROFILE ---
  final editNameC = TextEditingController();
  final editEmailC = TextEditingController(); 

  // --- CONTROLLERS: CHANGE PASSWORD ---
  final currentPassC = TextEditingController();
  final newPassC = TextEditingController();
  final confirmNewPassC = TextEditingController();
  var isObscure = true.obs; 

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  // --- 1. FETCH DATA USER ---
  void fetchUserProfile() async {
    try {
      isLoading.value = true;
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        email.value = currentUser.email ?? '';
        photoUrl.value = currentUser.photoURL ?? ''; 
        
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();

        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          fullName.value = data['fullName'] ?? 'User Lunchify';
          
          if (data['photoUrl'] != null && data['photoUrl'] != '') {
             photoUrl.value = data['photoUrl'];
          }
        } else {
          fullName.value = currentUser.displayName ?? 'User Lunchify';
        }
      }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // --- 2. UPDATE PROFILE (NAMA) ---
  Future<void> updateProfile() async {
    if (editNameC.text.isEmpty) {
      Get.snackbar("Error", "Nama tidak boleh kosong", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      String uid = _auth.currentUser!.uid;

      // Update Firestore
      await _firestore.collection('users').doc(uid).update({
        'fullName': editNameC.text,
      });

      // Update Auth Display Name
      await _auth.currentUser?.updateDisplayName(editNameC.text);

      // Update Tampilan Lokal
      fullName.value = editNameC.text;

      Get.back(); // Tutup halaman
      Get.snackbar("Sukses", "Profil berhasil diperbarui!", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Gagal update profil: $e", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // --- 3. CHANGE PASSWORD ---
  Future<void> changePassword() async {
    if (currentPassC.text.isEmpty || newPassC.text.isEmpty || confirmNewPassC.text.isEmpty) {
      Get.snackbar("Error", "Semua kolom wajib diisi", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (newPassC.text != confirmNewPassC.text) {
      Get.snackbar("Error", "Password baru tidak cocok", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      User? user = _auth.currentUser;
      String email = user?.email ?? "";

      // Re-Authenticate (Login ulang di balik layar)
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: currentPassC.text);
      await user?.reauthenticateWithCredential(credential);

      // Update Password
      await user?.updatePassword(newPassC.text);

      currentPassC.clear();
      newPassC.clear();
      confirmNewPassC.clear();

      Get.back();
      Get.snackbar("Sukses", "Password berhasil diganti!", backgroundColor: Colors.green, colorText: Colors.white);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Gagal ganti password", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
  
  void toggleObscure() => isObscure.value = !isObscure.value;

  // --- LOGOUT (FIXED NAVIGASI) ---
  void logout() {
    Get.defaultDialog(
      title: "Logout",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText: "Apakah anda yakin ingin keluar?",
      textCancel: "Batal",
      textConfirm: "Ya, Keluar",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        try {
          await _auth.signOut();
          
          // 2. NAVIGASI DENGAN BINDING
          Get.offAll(
            () => const AuthentifikasiView(),
            
            // INI KUNCI PERBAIKANNYA:
            // Kita pasang Controller-nya tepat sebelum halaman Login muncul
            binding: BindingsBuilder(() {
              Get.put(AuthentifikasiController());
            }),
          );
          
        } catch (e) {
          Get.snackbar("Error", "Gagal logout: $e");
        }
      },
    );
  }
}