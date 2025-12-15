import 'package:flutter/material.dart';
import 'package:get/get.dart';
<<<<<<< HEAD

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
=======
import 'routes/app_routes.dart';
import 'controllers/voting_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Init controller (singleton)
  Get.put(VotingController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final light = ThemeData(
    primaryColor: const Color(0xFF0A73FF),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.blue,
    ).copyWith(secondary: Colors.blueAccent),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0A73FF),
      foregroundColor: Colors.white,
    ),
  );

  final dark = ThemeData.dark().copyWith(
    primaryColor: const Color(0xFF1E88E5),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E88E5),
      foregroundColor: Colors.white,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Voting App',
      debugShowCheckedModeBanner: false,
      theme: light,
      darkTheme: dark,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.votingFilter,
      getPages: AppRoutes.pages,
    );
  }
}
>>>>>>> 47f295d0c36afbd07332575b8efa84a73b524d73
