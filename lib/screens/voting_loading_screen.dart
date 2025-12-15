import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/voting_controller.dart';
import '../routes/app_routes.dart';

class VotingLoadingScreen extends StatelessWidget {
  VotingLoadingScreen({super.key});
  final VotingController c = Get.find<VotingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Sip, Suaramu Sudah Masuk!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Tinggal tunggu yang lain...",
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 30),
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(
                  "${c.votedCount} dari ${c.totalMembers.value} sudah vote",
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 30),

                // bubbles
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(c.totalMembers.value, (i) {
                    // if user voted (i < votedCount) -> colored, else grey
                    final filled = i < c.votedCount;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: filled
                            ? Colors.primaries[i % Colors.primaries.length]
                            : Colors.grey.shade300,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 180,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.votingResult);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("Lihat Hasil (DEBUG)"),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // Cancel my vote (for demo)
                    c.cancelVote('user_me');
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade300,
                  ),
                  child: const Text("Batalkan Suara Saya"),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
