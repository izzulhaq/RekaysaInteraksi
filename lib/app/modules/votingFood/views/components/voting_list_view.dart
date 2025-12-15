import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/voting_food_controllers.dart';

class VotingListView extends GetView<VotingFoodController> {
  const VotingListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          color: Colors.blue[100],
          child: const Text("Pilihanmu Rahasia! Vote sesuai kata hati.", textAlign: TextAlign.center, style: TextStyle(color: Colors.black87)),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: controller.options.length,
            itemBuilder: (context, index) {
              final food = controller.options[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(food.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 5),
                      Text("⭐ ${food.rating} | ${food.distanceMinutes} min jalan | ~Rp ${food.price ~/ 1000}rb"),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            elevation: 0,
                          ),
                          onPressed: () => controller.submitVote(food.id),
                          child: const Text("Pilih Ini", style: TextStyle(color: Colors.black)),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}