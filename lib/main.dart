import 'package:flutter/material.dart';
import 'package:get/get.dart';

// --- TAMBAHAN 1: Import Firebase ---
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 

import 'app/routes/app_pages.dart';

// --- TAMBAHAN 2: Ubah main menjadi async ---
void main() async {
  // --- TAMBAHAN 3: Pastikan binding flutter siap ---
  WidgetsFlutterBinding.ensureInitialized();

  // --- TAMBAHAN 4: Inisialisasi Firebase ---
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    GetMaterialApp(
      title: "Lunchify",
      debugShowCheckedModeBanner: false, 
      
      // Konfigurasi Routing GetX
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      
      // Tema Aplikasi
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins', 
      ),
    ),
  );
}