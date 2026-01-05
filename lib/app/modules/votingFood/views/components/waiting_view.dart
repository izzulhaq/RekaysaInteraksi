import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/voting_food_controllers.dart';

class WaitingView extends GetView<VotingFoodController> {
  const WaitingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            const Text("Suara Masuk!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text("Menunggu teman lain...", style: TextStyle(color: Colors.grey)),
            
            const SizedBox(height: 40),

            // INFO PROGRESS
            Obx(() => Column(
              children: [
                Text(
                  "${controller.currentVoteCount.value} dari ${controller.totalVoters.value} orang",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text("Sudah Memilih", style: TextStyle(fontSize: 12)),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  // Hitung persentase progress
                  value: controller.totalVoters.value == 0 
                      ? 0 
                      : controller.currentVoteCount.value / controller.totalVoters.value,
                  backgroundColor: Colors.grey[200],
                  color: const Color(0xFF004AAD),
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(5),
                ),
              ],
            )),

            const SizedBox(height: 60),

            // TOMBOL KHUSUS HOST
            Obx(() {
              if (controller.isHost.value) {
                return Column(
                  children: [
                    const Text("Kamu adalah Host", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => controller.finishVoting(),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text("AKHIRI VOTING SEKARANG", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text("*Klik ini jika semua teman sudah vote", style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                );
              } else {
                return const Text("Tunggu Host mengakhiri voting ya...", style: TextStyle(fontStyle: FontStyle.italic));
              }
            })
          ],
        ),
      ),
    );
  }
}