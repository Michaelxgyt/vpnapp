import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gamers_shield_vpn/utils/app_strings.dart';
import 'controller/auth_controller.dart';
import 'controller/local_controller.dart';
import 'controller/premium_list_controller.dart';
import 'controller/profile_controller.dart';
import 'controller/server_list_controller.dart';
import 'controller/subscription_controller.dart';
import 'controller/vpn_controller.dart';
import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';
import 'data/repository/auth_repo.dart';
import 'data/repository/premium_list_repo.dart';
import 'data/repository/profile_repo.dart';
import 'data/repository/server_list_repo.dart';
import 'data/repository/subscription_repo.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// Core
  sl.registerLazySingleton(() => DioClient(AppStrings.baseUrl, sl(), loggingInterceptor: sl(), sharedPreferences: sl()));

  ///Repository
  sl.registerLazySingleton(() => ServerListRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => PremiumListRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ProfileRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => SubscriptionRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => AuthRepo(dioClient: sl(), sharedPreferences: sl()));


  /// Controller
  Get.lazyPut(() => ServerListController(serverListRepo: sl()), fenix: true);
  Get.lazyPut(() => PremiumListController(premiumListRepo: sl()), fenix: true);
  Get.lazyPut(() => ProfileController(profileRepo: sl()), fenix: true);
  Get.lazyPut(() => SubscriptionController(subscriptionRepo: sl()), fenix: true);
  Get.lazyPut(() => AuthController(authRepo: sl(), dioClient: sl()), fenix: true);
  Get.lazyPut(() => LocaleController(), fenix: true);
  Get.lazyPut(() => VpnController(), fenix: true);


  /// External pocket lock
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}