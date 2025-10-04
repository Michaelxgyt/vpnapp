import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_strings.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base_model/api_response.dart';

class AuthRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.dioClient, required this.sharedPreferences});


  Future<ApiResponse> register(
      {dynamic name, dynamic email, dynamic password}) async {
    try {
      Response response = await dioClient.post(
        "${AppStrings.registerUrl}?name=$name&email=$email&password=$password",
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          }
        )
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> login({dynamic email, dynamic password, dynamic deviceId}) async {
    try {
      Response response = await dioClient.post(
        AppStrings.loginUrl,
        queryParameters: {
          "email" : email,
          "password" : password,
          "device_id" : deviceId,
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> forgetPassword({dynamic email}) async {
    try {
      Response response = await dioClient.post(
        AppStrings.forgetPasswordUrl,
        queryParameters: {
          "email" : email,
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> resetPassword({dynamic email,dynamic token, dynamic password, dynamic confirmPassword}) async
  {
    try {
      Response response = await dioClient.post(
        AppStrings.resetPasswordUrl,
        queryParameters: {
          "token" : token,
          "email" : email,
          "password" : password,
          "password_confirmation" : confirmPassword,
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  // for  user token
  Future<void> saveUserToken(String token) async {

    dioClient.updateHeader(token, "");

    try {
      await sharedPreferences.setString(AppStrings.token, token);
      print("========>Token Stored<=======");
      print(await sharedPreferences.getString(AppStrings.token));
    } catch (e) {
      throw e;
    }
  }

  //save user token in local storage
  getUserToken() {
    SharedPreferences.getInstance();
    return sharedPreferences.getString(AppStrings.token) ?? "";
  }

  // remove user token from local storage
  removeUserToken() async{
    await SharedPreferences.getInstance();
    return sharedPreferences.remove(AppStrings.token);

  }

  //auth token
  // for  user token
  Future<void> saveAuthToken(String token) async {
    dioClient.token = token;
    dioClient.dio!.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      await sharedPreferences.setString(AppStrings.token, token);
    } catch (e) {
      throw e;
    }
  }

  String getAuthToken() {
    return sharedPreferences.getString(AppStrings.token) ?? "";
  }


}
