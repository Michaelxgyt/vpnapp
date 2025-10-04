import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_strings.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base_model/api_response.dart';

class ServerListRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  ServerListRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getServerList(
      dynamic page,
      ) async {
    try {
      Response response = await dioClient.get(
        "${AppStrings.freeServerListUrl}page=$page",
        options: Options(headers: {
          "Content-Type": "application/json",
        }),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}