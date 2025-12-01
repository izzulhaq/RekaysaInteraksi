import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'di/injection_container.dart' as di; // Import injeksi
import 'presentation/auth/bloc/auth_bloc.dart';
import 'presentation/auth/screens/login_screen.dart'; // Import Login Screen
import 'presentation/voting/voting_notifier.dart'; // Import Notifier Voting

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // Inisialisasi Dependency Injection
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 1. Provider untuk Autentikasi (menggunakan Bloc)
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        // 2. Provider untuk Fitur Voting (menggunakan ChangeNotifier)
        ChangeNotifierProvider(create: (_) => VotingNotifier()),
      ],
      child: MaterialApp(
        title: 'App Pelacak Tempat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1976D2), // Warna biru konsisten
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        // Set home screen ke Login Screen Anda
        home: LoginScreen(),
      ),
    );
  }
}
