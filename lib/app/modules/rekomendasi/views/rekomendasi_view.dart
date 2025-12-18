import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/rekomendasi_controller.dart';
// Import komponen yang akan kita buat di bawah
import 'components/rekomendasi_input_view.dart';
import 'components/rekomendasi_result_view.dart';

class RekomendasiView extends GetView<RekomendasiController> {
  const RekomendasiView({Key? key}) : super(key: key);

  final Color primaryBlue = const Color(0xFF004AAD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text("Rekomendasi Instan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        // 1. Loading State
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: primaryBlue),
                const SizedBox(height: 15),
                const Text("Sedang bertanya pada Warlok...")
              ],
            ),
          );
        }

        // 2. Logic Pindah Screen
        // Jika sudah ada hasil -> Tampilkan Layar Hasil
        if (controller.hasResult.value) {
          return const RekomendasiResultView();
        }

        // Jika belum -> Tampilkan Layar Input
        return const RekomendasiInputView();
      }),
    );
  }
}