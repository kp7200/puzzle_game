import 'package:get/get.dart';

abstract class BaseController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  void showLoader() => isLoading.value = true;
  
  void hideLoader() => isLoading.value = false;

  void showError(String message) {
    errorMessage.value = message;
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error.withValues(alpha: 0.8),
      colorText: Get.theme.colorScheme.onError,
    );
  }

  void clearError() => errorMessage.value = '';

  Future<void> handleRequest(Future<void> Function() request) async {
    try {
      showLoader();
      clearError();
      await request();
    } catch (e) {
      showError(e.toString());
    } finally {
      hideLoader();
    }
  }
}
