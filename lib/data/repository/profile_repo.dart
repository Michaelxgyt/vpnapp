import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_strings.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base_model/api_response.dart';

class ProfileRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  ProfileRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getProfileData() async {
    try {
      Response response = await dioClient.get(
        AppStrings.profileUrl,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization":
          "Bearer ${ sharedPreferences.getString(AppStrings.token)}",
        }),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  cancelSubscription() async {
    try {
      Response response = await dioClient.post(
        AppStrings.subscriptionCancelUrl,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization":
          "Bearer ${ sharedPreferences.getString(AppStrings.token)}",
        }),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}