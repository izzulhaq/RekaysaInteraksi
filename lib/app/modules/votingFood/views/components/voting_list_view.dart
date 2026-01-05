import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/voting_food_controllers.dart';

class VotingListView extends GetView<VotingFoodController> {
  const VotingListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- HEADER KODE ROOM ---
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          color: Colors.orange.withOpacity(0.1),
          child: Column(
            children: [
              const Text("Bagikan Kode ini ke teman:", style: TextStyle(fontSize: 12)),
              const SizedBox(height: 5),
              Obx(() => Text(
                controller.roomId.value, 
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 5, color: Colors.orange)
              )),
            ],
          ),
        ),

        Expanded(
          child: Obx(() => ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: controller.candidates.length,
            itemBuilder: (context, index) {
              // Ambil data dari Map
              final food = controller.candidates[index];
              
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        food['name'], // Akses Map
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          Text(" ${food['rating']} | "),
                          Text("~Rp ${food['price'] ~/ 1000}rb"),
                        ],
                      ),
                      const SizedBox(height: 15),
                      
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                          ),
                          onPressed: () => controller.submitVote(food['id']),
                          child: const Text("Pilih Ini", style: TextStyle(color: Colors.black87)),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          )),
        ),
      ],
    );
  }
}