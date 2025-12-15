import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/voting_food_controllers.dart';

class WaitingView extends GetView<VotingFoodController> {
  const WaitingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Sip, Suaramu Sudah Masuk!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text("Tinggal tunggu yang lain.....", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 50),
          
          // Loading Spinner
          const SizedBox(
            width: 80, height: 80,
            child: CircularProgressIndicator(strokeWidth: 6, color: Colors.grey),
          ),
          const SizedBox(height: 40),

          // Status Text
          Obx(() => Text("${controller.currentVoteCount.value} dari ${controller.totalVoters} sudah vote", style: const TextStyle(fontSize: 16))),
          
          const SizedBox(height: 20),
          
          // Dots Indicator
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(controller.totalVoters, (index) {
              bool isFilled = index < controller.currentVoteCount.value;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: 20, height: 20,
                decoration: BoxDecoration(
                  color: isFilled ? Colors.primaries[index % Colors.primaries.length] : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              );
            }),
          )),
          
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: controller.showResult,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
            child: const Text("Lihat Hasil (DEBUG)", style: TextStyle(color: Colors.black)),
          ),
          TextButton(
             onPressed: controller.cancelVote, 
             child: const Text("Batalkan Vote", style: TextStyle(color: Colors.red))
          )
        ],
      ),
    );
  }
}