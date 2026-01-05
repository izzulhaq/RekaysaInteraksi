import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/explore_controller.dart';

class ExploreView extends StatelessWidget {
  ExploreView({Key? key}) : super(key: key);

  final controller = Get.put(ExploreController());
  
  final Color primaryColor = const Color(0xFF1A237E);
  final Color backgroundColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER & SEARCH BAR ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5)
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Explore Food",
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold, 
                      color: primaryColor
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  // SEARCH INPUT
                  TextField(
                    controller: controller.searchC,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) => controller.searchFood(value), // Enter -> Cari
                    decoration: InputDecoration(
                      hintText: "Mau makan apa hari ini?",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.search, color: primaryColor),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: () => controller.searchFood(controller.searchC.text),
                      ),
                      filled: true,
                      fillColor: backgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // KATEGORI CHIPS (Horizontal Scroll)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: controller.categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ActionChip(
                            label: Text(category),
                            backgroundColor: backgroundColor,
                            labelStyle: TextStyle(color: primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide.none
                            ),
                            onPressed: () {
                              controller.searchC.text = category; // Set text
                              controller.searchFood(category);    // Langsung cari
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),

            // --- HASIL PENCARIAN ---
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator(color: primaryColor));
                }

                if (controller.searchResults.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 10),
                        Text(
                          "Belum ada hasil pencarian", 
                          style: TextStyle(color: Colors.grey[400])
                        ),
                      ],
                    ),
                  );
                }

                // LIST HASIL
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: controller.searchResults.length,
                  itemBuilder: (context, index) {
                    var item = controller.searchResults[index];
                    return _buildFoodCard(item);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET KARTU MAKANAN
  Widget _buildFoodCard(Map item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5)
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Placeholder (Karena Google Place Photo berbayar/rumit)
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.restaurant, color: Colors.orange, size: 30),
          ),
          const SizedBox(width: 15),
          
          // Detail Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  item['address'],
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      "${item['rating']} (${item['count']})",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text("OPEN", style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}