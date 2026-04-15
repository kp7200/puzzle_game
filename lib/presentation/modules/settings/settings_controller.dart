import 'package:get/get.dart';
import '../../../../domain/usecases/get_username_usecase.dart';
import '../../../../domain/usecases/save_username_usecase.dart';

class SettingsController extends GetxController {
  final GetUsernameUseCase _getUsername = Get.find();
  final SaveUsernameUseCase _saveUsername = Get.find();

  final RxString username = ''.obs;
  final RxString usernameInputError = ''.obs;
  final RxBool isSaving = false.obs;
  final RxBool saveSuccess = false.obs;

  // Theme toggle — placeholder only, always dark for now
  final RxBool isDarkMode = true.obs;

  @override
  void onInit() {
    super.onInit();
    username.value = _getUsername.execute() ?? '';
  }

  Future<void> saveUsername(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      usernameInputError.value = 'Name cannot be empty.';
      return;
    }
    if (trimmed == username.value) {
      // No change — dismiss silently
      Get.back();
      return;
    }

    isSaving.value = true;
    usernameInputError.value = '';
    await _saveUsername.execute(trimmed);
    username.value = trimmed;
    isSaving.value = false;
    saveSuccess.value = true;

    // Brief success flash then navigate back
    await Future.delayed(const Duration(milliseconds: 800));
    Get.back();
  }
}
