import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // GetStorage storage = GetStorage();
    // await Future.delayed(const Duration(seconds: 1));

    // final List<dynamic> currentBookings =
    //     storage.read<List<dynamic>>(StorageKeys.bookingsKey) ?? [];

    // log('User bookings: $currentBookings');

    // if (currentBookings.isNotEmpty) {
    //   Get.offAllNamed(AppRoutes.HOME);
    // } else {
    //   Get.offAllNamed(AppRoutes.LOGIN);
    // }
  }
}
