import 'package:get/get.dart';
import '../controllers/voting_food_controllers.dart';

class VotingFoodBinding extends Bindings {
  @override
  void dependencies() {
    // Inject Controller ke memori saat halaman dibuka
    Get.lazyPut<VotingFoodController>(
      () => VotingFoodController(),
    );
  }
}