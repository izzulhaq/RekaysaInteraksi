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
            const Center(
              child: Icon(Icons.groups_rounded, size: 80, color: Color(0xFF004AAD)),
            ),
            const SizedBox(height: 20),
            
            // --- BAGIAN 1: HOST (BUAT ROOM) ---
            const Text("BUAT ROOM BARU", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF004AAD))),
            const SizedBox(height: 10),
            
            // Input Lokasi
            TextField(
              controller: controller.addressC,
              decoration: InputDecoration(
                hintText: "Lokasi (cth: Malang)",
                prefixIcon: const Icon(Icons.location_on, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
            const SizedBox(height: 10),
            
            // Input Veto
            TextField(
              controller: controller.vetoC,
              decoration: InputDecoration(
                hintText: "Hindari makanan (cth: pedas, sate)",
                prefixIcon: const Icon(Icons.block, color: Colors.redAccent),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
            const SizedBox(height: 15),
            
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () => controller.createRoom(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004AAD),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Obx(() => controller.isLoading.value 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text("Buat & Mulai Vote", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                ),
              ),
            ),

            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),

            // --- BAGIAN 2: GUEST (JOIN ROOM) ---
            const Text("GABUNG TEMAN", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 10),

            TextField(
              controller: controller.joinCodeC,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Masukkan Kode Room",
                prefixIcon: const Icon(Icons.vpn_key, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: OutlinedButton(
                onPressed: () => controller.joinRoom(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF004AAD)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Gabung Room", style: TextStyle(color: Color(0xFF004AAD), fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}