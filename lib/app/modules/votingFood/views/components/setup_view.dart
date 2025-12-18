import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/voting_food_controllers.dart';

class SetupView extends GetView<VotingFoodController> {
  const SetupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Atur filter untuk grupmu. Waktu vote 5 Menit", 
              style: TextStyle(color: Colors.grey)
            ),
            const SizedBox(height: 30),
            
            // --- BAGIAN LOKASI (MANUAL INPUT) ---
            const Text("Lokasi Area Makan", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            
            TextField(
              controller: controller.addressC, // Menggunakan controller text
              decoration: InputDecoration(
                hintText: "Masukkan area (cth: Sekitar Kampus)",
                prefixIcon: const Icon(Icons.location_on, color: Color(0xFF004AAD)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
            ),

            const SizedBox(height: 25),

            // --- BAGIAN BUDGET ---
            const Text("Budget Maksimal", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: controller.budgetC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Rp 50.000",
                prefixIcon: const Icon(Icons.attach_money, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
            ),

            const SizedBox(height: 25),

            // --- BAGIAN VETO ---
            const Text("Filter Makanan yg dihindari", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: controller.vetoC,
              decoration: InputDecoration(
                hintText: "Contoh: sate, seafood (alergi)",
                prefixIcon: const Icon(Icons.block, color: Colors.redAccent),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
            ),

            const SizedBox(height: 50),
            
            // TOMBOL MULAI
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: controller.startVotingSession,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004AAD), 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 3,
                ),
                icon: const Icon(Icons.group_add, color: Colors.white),
                label: const Text(
                  "Mulai Vote", 
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}