import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/voting_controller.dart';
import '../routes/app_routes.dart';

class VotingChoiceScreen extends StatelessWidget {
  VotingChoiceScreen({super.key});

  final VotingController c = Get.find<VotingController>();
  final String currentUserId = 'user_me'; // contoh id user sekarang

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Jagoanmu!"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFD9E8FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text("Pilihannya Rahasia! Vote sesuai kata hati."),
            ),
            const SizedBox(height: 20),
            // list options
            Obx(() {
              return Column(
                children: c.options.map((food) {
                  return Column(
                    children: [
                      _foodOptionCard(
                        foodId: food.id,
                        title: food.name,
                        rating: food.rating.toString(),
                        distance: "${food.distanceMinutes} min jalan",
                        price: "Rp ${food.price}",
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                }).toList(),
              );
            }),
            const Spacer(),
            TextButton(
              onPressed: () {
                // cancel and go back
                Get.back();
              },
              child: const Text("Batalkan Vote"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _foodOptionCard({
    required String foodId,
    required String title,
    required String rating,
    required String distance,
    required String price,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title ⭐ $rating | $distance | $price"),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // send vote and navigate to loading
                c.vote(userId: currentUserId, foodId: foodId);
                // optionally simulate others to see progress
                c.simulateOthers();
                Get.toNamed(AppRoutes.votingLoading);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE0E0E0),
                foregroundColor: Colors.black,
              ),
              child: const Text("Pilih Ini"),
            ),
          ),
        ],
      ),
    );
  }
}
