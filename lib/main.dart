import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
