import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/rekomendasi_controller.dart';

class RekomendasiResultView extends GetView<RekomendasiController> {
  const RekomendasiResultView({Key? key}) : super(key: key);

  final Color primaryBlue = const Color(0xFF004AAD);

  @override
  Widget build(BuildContext context) {
    // --- PERBAIKAN: Bungkus seluruh isi dengan Obx ---
    return Obx(() {
      final food = controller.recommendedFood.value;
      
      // Jika null (belum ada hasil), tampilkan kosong
      if (food == null) return const SizedBox();

      return Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "🎉 Pilihan Warlok Jatuh Kepada:", 
              style: TextStyle(color: Colors.grey, fontSize: 16)
            ),
            const SizedBox(height: 20),
            
            // --- KARTU HASIL ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withOpacity(0.15), 
                    blurRadius: 20, 
                    spreadRadius: 5, 
                    offset: const Offset(0, 10)
                  )
                ],
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.restaurant_menu_rounded, size: 50, color: primaryBlue),
                  ),
                  const SizedBox(height: 20),
                  
                  // NAMA MAKANAN (Akan berubah otomatis sekarang)
                  Text(
                    food.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                      Text(" ${food.rating} ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Container(height: 15, width: 1, color: Colors.grey),
                      Text("  ${food.price < 20000 ? 'Hemat' : 'Standar'}  ", style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      "\"Cocok banget buat ngisi perut sekarang!\"",
                      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
            
            const Spacer(),
            
            // --- TOMBOL GAS (MAPS) ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: controller.openMap,
                icon: const Icon(Icons.map, color: Colors.white),
                label: const Text("Gas Kesana 📍", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                ),
              ),
            ),
            
            const SizedBox(height: 15),
            
            // --- TOMBOL REROLL (ACAK LAGI) ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton.icon(
                onPressed: controller.rollAgain,
                icon: Icon(Icons.refresh_rounded, color: primaryBlue),
                label: Text("Kurang sreg... Acak Lagi 🎲", style: TextStyle(color: primaryBlue, fontSize: 16, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryBlue, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                ),
              ),
            ),

            const SizedBox(height: 20),
            TextButton(
              onPressed: controller.reset,
              child: const Text("Ganti Mood / Lokasi", style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      );
    });
  }
}