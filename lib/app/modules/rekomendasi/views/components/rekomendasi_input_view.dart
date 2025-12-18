import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/rekomendasi_controller.dart';

class RekomendasiInputView extends GetView<RekomendasiController> {
  const RekomendasiInputView({Key? key}) : super(key: key);

  final Color primaryBlue = const Color(0xFF004AAD);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Lagi pengen apa hari ini?", 
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 5),
          const Text("Pilih mood makanmu, biarkan kami yang memilihkan.", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),

          // --- GRID MOOD ---
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.moodOptions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, 
              mainAxisSpacing: 15, 
              crossAxisSpacing: 15,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final item = controller.moodOptions[index];
              return Obx(() {
                bool isSelected = controller.selectedMoodIndex.value == index;
                return GestureDetector(
                  onTap: () => controller.selectedMoodIndex.value = index,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryBlue : Colors.grey[50],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isSelected ? primaryBlue : Colors.grey.shade300, 
                      ),
                      boxShadow: isSelected ? [BoxShadow(color: primaryBlue.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item['icon'].toString(), style: const TextStyle(fontSize: 32)),
                        const SizedBox(height: 8),
                        Text(
                          item['label'].toString(), 
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                          )
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),

          const SizedBox(height: 30),

          // --- PILIH LOKASI ---
          const Text("Posisi kamu?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Row(
            children: [
              Obx(() => ChoiceChip(
                label: const Text("Sekitar Saya"),
                selected: controller.isAroundMe.value,
                onSelected: (val) => controller.isAroundMe.value = true,
                selectedColor: primaryBlue,
                labelStyle: TextStyle(color: controller.isAroundMe.value ? Colors.white : Colors.black),
              )),
              const SizedBox(width: 10),
              Obx(() => ChoiceChip(
                label: const Text("Manual"),
                selected: !controller.isAroundMe.value,
                onSelected: (val) => controller.isAroundMe.value = false,
                selectedColor: primaryBlue,
                labelStyle: TextStyle(color: !controller.isAroundMe.value ? Colors.white : Colors.black),
              )),
            ],
          ),
          
          // Input Manual (Hanya muncul jika manual dipilih)
          Obx(() => controller.isAroundMe.value 
              ? const SizedBox() 
              : Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: TextField(
                    controller: controller.locationC,
                    decoration: InputDecoration(
                      hintText: "Contoh: Suhat, Kayutangan...",
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ),
                )
          ),

          const SizedBox(height: 25),

          // --- PILIH BUDGET ---
          const Text("Kondisi Dompet?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(controller.priceOptions.length, (index) {
                 return Padding(
                   padding: const EdgeInsets.only(right: 8.0),
                   child: Obx(() => ChoiceChip(
                     label: Text(controller.priceOptions[index]),
                     selected: controller.selectedPriceIndex.value == index,
                     onSelected: (val) => controller.selectedPriceIndex.value = index,
                     selectedColor: primaryBlue,
                     labelStyle: TextStyle(color: controller.selectedPriceIndex.value == index ? Colors.white : Colors.black),
                   )),
                 );
              }),
            ),
          ),

          const SizedBox(height: 40),

          // --- TOMBOL ACTION ---
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: controller.cariRekomendasi,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 5,
              ),
              child: const Text("Carikan Dong! 🎲", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}