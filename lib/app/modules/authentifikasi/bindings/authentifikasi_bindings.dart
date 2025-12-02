import 'package:get/get.dart';
import '../controllers/authentifikasi_controller.dart';

class AuthentifikasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthentifikasiController>(
      () => AuthentifikasiController(),
    );
  }
}