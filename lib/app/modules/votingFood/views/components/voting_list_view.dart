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
          color: const Color(0xFFD6E4FF), // Biru muda sesuai tema
          child: const Text(
            "Pilihanmu Rahasia! Vote sesuai kata hati.", 
            textAlign: TextAlign.center, 
            style: TextStyle(color: Colors.black87)
          ),
        ),
        Expanded(
          // Gunakan Obx agar list update real-time jika filter berubah (opsional)
          child: Obx(() => ListView.builder(
            padding: const EdgeInsets.all(20),
            // UBAH DISINI: Gunakan displayedOptions (hasil filter)
            itemCount: controller.displayedOptions.length,
            itemBuilder: (context, index) {
              // UBAH DISINI: Ambil data dari displayedOptions
              final food = controller.displayedOptions[index];
              
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[50], // Warna card lebih terang
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        food.name, 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                      ),
                      const SizedBox(height: 8),
                      // Info detail makanan
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          Text(" ${food.rating} | "),
                          Text("${food.distanceMinutes} min jalan | "),
                          Text("~Rp ${food.price ~/ 1000}rb"),
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                            )
                          ),
                          onPressed: () => controller.submitVote(food.id),
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