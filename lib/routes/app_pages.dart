import 'package:get/get.dart';
import '../presentation/modules/home/home_screen.dart';
import '../presentation/modules/puzzle/puzzle_screen.dart';
import '../presentation/modules/result/result_screen.dart';
import '../presentation/modules/splash/splash_screen.dart';
import '../presentation/modules/settings/settings_screen.dart';

class AppPages {
  AppPages._();

  static const initial = '/splash';

  static final routes = [
    GetPage(
      name: '/splash',
      page: () => const SplashScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: '/home',
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 1200),
    ),
    GetPage(
      name: '/puzzle',
      page: () => const PuzzleScreen(),
    ),
    GetPage(
      name: '/result',
      page: () => const ResultScreen(),
    ),
    GetPage(
      name: '/settings',
      page: () => const SettingsScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
  ];
}

