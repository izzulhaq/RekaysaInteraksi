import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Lunchify",
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      
      // Konfigurasi Routing GetX
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      
      // Tema Aplikasi (Opsional)
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins', // Pastikan font sudah didaftarkan di pubspec.yaml jika pakai custom font
      ),
    ),
  );
}