import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/voting_food_controllers.dart';

// Import pecahan file components
import 'components/setup_view.dart';
import 'components/voting_list_view.dart';
import 'components/waiting_view.dart';
import 'components/result_view.dart';

class VotingFoodView extends GetView<VotingFoodController> {
  const VotingFoodView({Key? key}) : super(key: key);

  final Color primaryBlue = const Color(0xFF004AAD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        // Judul AppBar berubah dinamis sesuai step di controller
        title: Obx(() {
          switch (controller.currentStep.value) {
            case VotingStep.setup:
              return const Text("Voting Cepat", style: TextStyle(color: Colors.white));
            case VotingStep.voting:
              return const Text("Pilih Jagoanmu!", style: TextStyle(color: Colors.white));
            case VotingStep.waiting:
              return const Text("Menunggu...", style: TextStyle(color: Colors.white));
            case VotingStep.result:
              return const Text("Hasil Voting", style: TextStyle(color: Colors.white));
          }
        }),
      ),
      // Body berubah dinamis memanggil widget dari file terpisah
      body: Obx(() {
        switch (controller.currentStep.value) {
          case VotingStep.setup:
            return const SetupView();
          case VotingStep.voting:
            return const VotingListView();
          case VotingStep.waiting:
            return const WaitingView();
          case VotingStep.result:
            return const ResultView();
        }
      }),
    );
  }
}