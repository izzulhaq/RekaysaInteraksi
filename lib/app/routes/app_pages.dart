import 'package:get/get.dart';
import 'package:lunchify/app/modules/authentifikasi/bindings/authentifikasi_bindings.dart';
import 'package:lunchify/app/modules/authentifikasi/views/authentifikasi_view.dart';
import 'package:lunchify/app/modules/rekomendasi/bindings/rekomendasi_binding.dart';
import 'package:lunchify/app/modules/rekomendasi/views/rekomendasi_view.dart';
import 'package:lunchify/app/modules/votingFood/bindings/voting_food_binfing.dart';
import 'package:lunchify/app/modules/votingFood/views/voting_food_view.dart';

// Import Home Module
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

// Import Routes
import 'app_routes.dart';

class AppPages {
  AppPages._();

  // Route awal saat aplikasi dibuka
  static const INITIAL = Routes.AUTHENTIFIKASI;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    
    // -- Modul lain (Aktifkan/Uncomment jika file view & binding sudah dibuat) --
    
    GetPage(
      name: Routes.AUTHENTIFIKASI,
      page: () => const AuthentifikasiView(),
      binding: AuthentifikasiBinding(),
    ),
    GetPage(
      name: Routes.VOTING_FOOD,
      page: () => const VotingFoodView(),
      binding: VotingFoodBinding(),
    ), 
    // GetPage(
    //   name: _Paths.CEK_KERAMAIAN,
    //   page: () => const CekKeramaianView(),
    //   binding: CekKeramaianBinding(),
    // ),

    GetPage(
      name: Routes.REKOMENDASI,
      page: () => const RekomendasiView(),
      binding: RekomendasiBinding(),
    ),
  ];
}