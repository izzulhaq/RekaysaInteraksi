import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class VotingFilterScreen extends StatelessWidget {
  VotingFilterScreen({super.key});

  final locationC = TextEditingController();
  final budgetC = TextEditingController();
  final vetoC = TextEditingController();

  // Definisi gaya teks hitam
  final TextStyle blackTextStyle = const TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Latar belakang yang lebih terang
      backgroundColor: const Color.fromARGB(255, 228, 227, 227),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A73FF),
        // --- KOREKSI 1: Menetapkan warna hitam untuk ikon dan judul AppBar ---
        foregroundColor:
            Colors.black, // Menggunakan Colors.black atau Color(0xFF000000)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Voting Cepat",
          style: TextStyle(
            color: Colors.black,
          ), // Pastikan judul berwarna hitam
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- KOREKSI 2: Menambahkan style untuk semua teks di body ---
            Text(
              "Atur filter untuk grupmu. Waktu vote 5 Menit",
              style: blackTextStyle,
            ),
            const SizedBox(height: 16),
            Text("Lokasi", style: blackTextStyle),
            const SizedBox(height: 8),
            TextField(
              controller: locationC,
              decoration: const InputDecoration(
                hintText: "Jalan Kaki",
                border: OutlineInputBorder(),
              ),
              style: blackTextStyle, // Teks yang diketik juga harus hitam
            ),
            const SizedBox(height: 16),
            Text("Budget Maksimal", style: blackTextStyle),
            const SizedBox(height: 8),
            TextField(
              controller: budgetC,
              decoration: const InputDecoration(
                hintText: "Rp 50.000",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              style: blackTextStyle, // Teks yang diketik juga harus hitam
            ),
            const SizedBox(height: 16),
            Text("Veto (nega mau ini)", style: blackTextStyle),
            const SizedBox(height: 8),
            TextField(
              controller: vetoC,
              decoration: const InputDecoration(
                hintText: "Contoh: sate, seafood",
                border: OutlineInputBorder(),
              ),
              style: blackTextStyle, // Teks yang diketik juga harus hitam
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.snackbar('Fitur', 'Simulasi memulai vote...');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A73FF),
                  foregroundColor:
                      Colors.white, // Teks di tombol tetap putih agar kontras
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text("Undang Tim & Mulai vote"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
