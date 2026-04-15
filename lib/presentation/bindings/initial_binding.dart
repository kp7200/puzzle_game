import 'package:get/get.dart';
import '../../core/services/audio_service.dart';
import '../../data/local/local_storage_service.dart';
import '../../data/repositories/game_repository.dart';
import '../../data/repositories/game_repository_impl.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/hive_user_repository.dart';
import '../../domain/usecases/get_current_level_usecase.dart';
import '../../domain/usecases/set_current_level_usecase.dart';
import '../../domain/usecases/reset_progress_usecase.dart';
import '../../domain/usecases/get_username_usecase.dart';
import '../../domain/usecases/save_username_usecase.dart';
import '../../domain/usecases/is_first_time_user_usecase.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // LocalStorageService is already initialized in main.dart before runApp.
    // We register the already-initialized instance so all repositories can access it.
    final storage = Get.find<LocalStorageService>();

    // ── Repositories (registered as abstract interface types) ─────────────
    // To migrate to Firebase: swap HiveGameRepository → FirebaseGameRepository
    // and HiveUserRepository → FirebaseUserRepository. Nothing else changes.
    final gameRepo = HiveGameRepository(storage);
    Get.put<GameRepository>(gameRepo, permanent: true);

    final userRepo = HiveUserRepository(storage);
    Get.put<UserRepository>(userRepo, permanent: true);

    // ── Game use cases ─────────────────────────────────────────────────────
    Get.put<GetCurrentLevelUseCase>(
      GetCurrentLevelUseCase(gameRepo),
      permanent: true,
    );

    Get.put<SetCurrentLevelUseCase>(
      SetCurrentLevelUseCase(gameRepo),
      permanent: true,
    );

    Get.put<ResetProgressUseCase>(
      ResetProgressUseCase(gameRepo),
      permanent: true,
    );

    // ── User use cases ─────────────────────────────────────────────────────
    Get.put<GetUsernameUseCase>(
      GetUsernameUseCase(userRepo),
      permanent: true,
    );

    Get.put<SaveUsernameUseCase>(
      SaveUsernameUseCase(userRepo),
      permanent: true,
    );

    Get.put<IsFirstTimeUserUseCase>(
      IsFirstTimeUserUseCase(userRepo),
      permanent: true,
    );

    // ── Audio service — permanent singleton, initialised asynchronously ────
    Get.putAsync<AudioService>(() => AudioService().init(), permanent: true);
  }
}

