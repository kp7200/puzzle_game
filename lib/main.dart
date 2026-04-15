import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'data/local/local_storage_service.dart';
import 'presentation/bindings/initial_binding.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize and register LocalStorageService before runApp so
  // InitialBinding can Get.find<LocalStorageService>() synchronously.
  final storage = LocalStorageService();
  await storage.init();
  Get.put<LocalStorageService>(storage, permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Think.sys',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: Routes.splash,
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),
    );
  }
}
