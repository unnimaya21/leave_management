import 'package:get/get.dart';
import 'package:leave_management/presentation/pages/splash/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
  }
}
