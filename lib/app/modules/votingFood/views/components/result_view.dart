import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/voting_food_controllers.dart';

class ResultView extends GetView<VotingFoodController> {
  const ResultView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ambil pemenang dari Map
    final winner = controller.winner;

    if (winner == null) return const Center(child: Text("Hasil seri atau tidak ada suara!"));

    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text("Waktunya Makan!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text("Pilihan terbanyak adalah...", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFD6E4FF),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFF004AAD), width: 2),
            ),
            child: Column(
              children: [
                const Icon(Icons.emoji_events, size: 60, color: Colors.orange),
                const SizedBox(height: 10),
                Text(winner['name'], textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF004AAD))),
                const SizedBox(height: 10),
                Text("⭐ ${winner['rating']}  |  ${winner['voteCount']} Suara"),
                const SizedBox(height: 20),
                
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.launchWinnerMap, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004AAD), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                    ), 
                    child: const Text("GAS KE LOKASI!", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          TextButton(
            onPressed: controller.resetVoting,
            child: const Text("Main Lagi (Menu Utama)", style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }
}