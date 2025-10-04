import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gamers_shield_vpn/screen/splash/splash_screen.dart';
import 'di_container.dart' as di;
import 'localization/app_translation.dart';
import 'localization/storage_service.dart';

dynamic storage;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  //initialize
  await initialConfig();
  storage = Get.find<StorageService>();
  runApp(const MyApp());
}

initialConfig() async {
  await Get.putAsync(() => StorageService().init());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        translations: AppTranslations(),
        locale: storage.languageCode != null
            ? Locale(storage.languageCode!, storage.countryCode)
            : const Locale("en", "US"),
        fallbackLocale: const Locale('en', 'US'),
        title: 'Gamers Shield Vpn',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen()
    );
  }
}

