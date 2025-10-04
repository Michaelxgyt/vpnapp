import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_strings.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base_model/api_response.dart';

class SubscriptionRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  SubscriptionRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> purchaseSubscription({
 dynamic packageName,
 dynamic validity,
 dynamic price,
}) async {
    try {
      Response response = await dioClient.post(
        AppStrings.subscriptionUrl,
        queryParameters: {
          "pakage_name" : packageName,
          "validity" : validity,
          "price" : price
        },
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