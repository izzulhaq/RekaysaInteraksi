import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  // Variable untuk menghandle tab index pada BottomNavigationBar
  var tabIndex = 0.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
    // Tambahkan logika navigasi halaman lain di sini jika diperlukan
  }

  // Fungsi navigasi dummy (bisa Anda hubungkan dengan routes nanti)
  void goToVotingFood() {
    print("Navigasi ke Voting Food");
    // Get.toNamed(Routes.VOTING_FOOD);
  }

  void goToCekKeramaian() {
    print("Navigasi ke Cek Keramaian");
    // Get.toNamed(Routes.CEK_KERAMAIAN);
  }

  void goToRekomendasi() {
    Get.toNamed(Routes.REKOMENDASI);
    // Get.toNamed(Routes.REKOMENDASI);
  }
}