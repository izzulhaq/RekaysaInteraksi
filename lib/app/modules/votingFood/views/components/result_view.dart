import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/voting_food_controllers.dart';

class ResultView extends GetView<VotingFoodController> {
  const ResultView({Key? key}) : super(key: key);

  final Color primaryBlue = const Color(0xFF004AAD);

  @override
  Widget build(BuildContext context) {
    final winner = controller.winner;
    
    if (winner == null) return const Center(child: Text("Belum ada suara masuk!"));

    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text("Waktunya Makan!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text("Pemenangnya adalah...", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFD6E4FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: primaryBlue, width: 2),
            ),
            child: Column(
              children: [
                Container(height: 60, color: Colors.blue[100]), // Placeholder Image
                const SizedBox(height: 10),
                const Icon(Icons.emoji_events, size: 40, color: Colors.orange),
                Text(winner.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryBlue)),
                Text("⭐ ${winner.rating} | ${winner.distanceMinutes} min jalan"),
                const SizedBox(height: 20),
                const Text("Total suara di rahasiakan untuk kedamaian\ntim", textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                const SizedBox(height: 20),
                
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.launchWinnerMap, 
                    
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue, 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                    ), 
                    child: const Text("Cek Lokasi!", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          const Text("Selesai", style: TextStyle(fontSize: 16)),
          const Spacer(),
          TextButton(
            onPressed: controller.resetDemo,
            child: const Text("Vote ulang", style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }
}