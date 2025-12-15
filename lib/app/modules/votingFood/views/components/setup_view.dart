import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/voting_food_controllers.dart';

class SetupView extends GetView<VotingFoodController> {
  const SetupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Atur filter untuk grupmu. Waktu vote 5 Menit", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          
          const Text("Lokasi", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(color: const Color(0xFF5C6AFF), borderRadius: BorderRadius.circular(5)),
                child: const Text("Jalan Kaki", style: TextStyle(color: Colors.white)),
              ),
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent), borderRadius: const BorderRadius.horizontal(right: Radius.circular(5))),
                ),
              )
            ],
          ),

          const SizedBox(height: 20),
          const Text("Budget Maksimal", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              hintText: "Rp 50.000",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            ),
          ),

          const SizedBox(height: 20),
          const Text("Veto (ngga mau ini)", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              hintText: "Contoh: sate, seafood",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            ),
          ),

          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: controller.startVotingSession,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF004AAD), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text("Undang Tim & Mulai vote", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}