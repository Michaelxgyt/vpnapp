import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/datasource/remote/dio/dio_client.dart';
import '../data/model/base_model/api_response.dart';
import '../data/repository/auth_repo.dart';
import '../screen/authentication/login_screen.dart';
import '../screen/authentication/reset_password_screen.dart';
import '../screen/profile/profile_screen.dart';

class AuthController extends GetxController{
  DioClient dioClient;
  final AuthRepo authRepo;
  AuthController({required this.authRepo,required this.dioClient});


  bool isLoadingLogin = false;
  bool isLoadingRegister = false;
  bool isLoadingForget = false;
  bool isLoadingReset = false;

  var rememberMe = false.obs;


  register({dynamic email, dynamic name, dynamic password}) async {
    isLoadingRegister = true;
    update();

    try {
      ApiResponse apiResponse = await authRepo.register(name: name, email: email, password: password);

      if (apiResponse.response != null && apiResponse.response!.statusCode == 201) {
        isLoadingRegister = false;
        Map map = apiResponse.response!.data;

        dynamic token;
        dynamic msg;

        try {
          token = map["token"];
          msg = map["massage"];

          update();
          if (kDebugMode) {
            print("Token: $token");
          }

          if (msg == "User Signed Up") {
            Get.snackbar(
              'Registration',
              msg,
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 1),
              backgroundColor: Colors.green,
              colorText: Colors.white,
              isDismissible: true,
              snackStyle: SnackStyle.FLOATING,
            );
          } else {
            Get.snackbar(
              'Registration',
              "Something went wrong! Or Invalid user data",
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 1),
              backgroundColor: Colors.red,
              colorText: Colors.white,
              isDismissible: true,
              snackStyle: SnackStyle.FLOATING,
            );
          }

          if (token.isNotEmpty) {
            Get.offAll(() =>  const LoginScreen(), transition: Transition.leftToRight);
            authRepo.saveUserToken(token);
          }

        } catch (e) {
          if (kDebugMode) {
            print("Error parsing the response: $e");
          }
          Get.snackbar(
            'Registration',
            "Something went wrong! Or Invalid user data",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.red,
            colorText: Colors.white,
            isDismissible: true,
            snackStyle: SnackStyle.FLOATING,
          );
        }

      } else {
        isLoadingRegister = false;
        update();

        if (apiResponse.response != null) {
          // If the status code is not 201 (successful registration)
          Get.snackbar(
            'Registration',
            "Something went wrong! Or Invalid user data",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.red,
            colorText: Colors.white,
            isDismissible: true,
            snackStyle: SnackStyle.FLOATING,
          );
        } else {
          // If there's no response or network error
          Get.snackbar(
            'Registration',
            "Something went wrong! Or Invalid user data",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.red,
            colorText: Colors.white,
            isDismissible: true,
            snackStyle: SnackStyle.FLOATING,
          );
        }
      }

    } catch (e) {
      // General catch block for any unexpected errors
      isLoadingRegister = false;
      update();
      if (kDebugMode) {
        print("Unexpected error: $e");
      }
      Get.snackbar(
        'Registration',
        "Something went wrong! Or Invalid user data",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        isDismissible: true,
        snackStyle: SnackStyle.FLOATING,
      );
    }

    update();
  }


  login({dynamic email, dynamic password, dynamic deviceId}) async {
    isLoadingLogin = true;
    update();

    try {
      ApiResponse apiResponse = await authRepo.login(email: email, password: password, deviceId:  deviceId);

      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        isLoadingLogin = false;
        Map map = apiResponse.response!.data;

        dynamic token;
        dynamic msg;

        try {
          token = map["token"];
          msg = map["message"];

          update();
          if (kDebugMode) {
            print(token);
          }

          if (msg == "Login successful") {
            Get.snackbar(
              'Login',
              msg,
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 1),
              backgroundColor: Colors.green,
              colorText: Colors.white,
              isDismissible: true,
              snackStyle: SnackStyle.FLOATING,
            );
            Get.offAll(() =>  const ProfileScreen(isLogin: true), transition: Transition.leftToRight);
          } else {
            Get.snackbar(
              'Login',
              "Something went wrong! Or Invalid user data",
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 1),
              backgroundColor: Colors.red,
              colorText: Colors.white,
              isDismissible: true,
              snackStyle: SnackStyle.FLOATING,
            );
          }

          if (token.isNotEmpty) {
            authRepo.saveUserToken(token);
          }

        } catch (e) {
          if (kDebugMode) {
            print("Error parsing the response: $e");
          }
          Get.snackbar(
            'Login',
            "Something went wrong! Or Invalid user data",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.red,
            colorText: Colors.white,
            isDismissible: true,
            snackStyle: SnackStyle.FLOATING,
          );
        }

      } else {
        isLoadingLogin = false;
        update();
        if (apiResponse.response != null) {
          // If the status code is not 200, show an error
          Get.snackbar(
            'Login',
            "Something went wrong! Or Invalid user data",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.red,
            colorText: Colors.white,
            isDismissible: true,
            snackStyle: SnackStyle.FLOATING,
          );
        } else {
          // If there's no response or network error
          Get.snackbar(
            'Login',
            "Something went wrong! Or Invalid user data",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.red,
            colorText: Colors.white,
            isDismissible: true,
            snackStyle: SnackStyle.FLOATING,
          );
        }
      }

    } catch (e) {
      // General catch block for any unexpected errors
      isLoadingLogin = false;
      update();
      if (kDebugMode) {
        print("Unexpected error: $e");
      }
      Get.snackbar(
        'Login',
        "Something went wrong! Or Invalid user data",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        isDismissible: true,
        snackStyle: SnackStyle.FLOATING,
      );
    }

    update();
  }

  forgetPassword({dynamic email}) async {
    isLoadingForget = true;
    update();

    try {
      ApiResponse apiResponse = await authRepo.forgetPassword(email: email);

      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        isLoadingForget = false;

        Get.snackbar(
          'Reset password',
          "Please check your email Inbox",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.green,
          colorText: Colors.white,
          isDismissible: true,
          snackStyle: SnackStyle.FLOATING,
        );

        Get.to(()=> const ResetPasswordScreen(),transition: Transition.leftToRight);

      } else {
        isLoadingForget = false;
        update();
        if (apiResponse.response != null) {
          // If the status code is not 200, show an error
          Get.snackbar(
            'Reset password',
            "Something went wrong! Or Invalid user data",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.red,
            colorText: Colors.white,
            isDismissible: true,
            snackStyle: SnackStyle.FLOATING,
          );
        } else {
          isLoadingForget = false;
          // If there's no response or network error
          Get.snackbar(
            'Reset password',
            "Something went wrong! Or Invalid user data",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.red,
            colorText: Colors.white,
            isDismissible: true,
            snackStyle: SnackStyle.FLOATING,
          );
        }
      }

    } catch (e) {
      // General catch block for any unexpected errors
      isLoadingForget = false;
      update();
      if (kDebugMode) {
        print("Unexpected error: $e");
      }
      Get.snackbar(
        'Reset password',
        "Something went wrong! Or Invalid user data",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        isDismissible: true,
        snackStyle: SnackStyle.FLOATING,
      );
    }

    update();
  }

  resetPassword({dynamic email,dynamic token, dynamic password, dynamic confirmPassword}) async {
    isLoadingReset = true;
    update();

    try {
      ApiResponse apiResponse = await authRepo.resetPassword(email: email,token: token,password: password,confirmPassword: confirmPassword);

      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        isLoadingReset = false;
        Get.snackbar(
          'Reset password',
          "Password reset successful",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.green,
          colorText: Colors.white,
          isDismissible: true,
          snackStyle: SnackStyle.FLOATING,
        );

        Get.to(()=> const LoginScreen(),transition: Transition.leftToRight);

      } else {
        isLoadingReset = false;
        update();
        if (apiResponse.response != null) {
          // If the status code is not 200, show an error
          Get.snackbar(
            'Reset password',
            "Something went wrong! Or Invalid user data",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.red,
            colorText: Colors.white,
            isDismissible: true,
            snackStyle: SnackStyle.FLOATING,
          );
        } else {
          isLoadingReset = false;
          // If there's no response or network error
          Get.snackbar(
            'Reset password',
            "Something went wrong! Or Invalid user data",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.red,
            colorText: Colors.white,
            isDismissible: true,
            snackStyle: SnackStyle.FLOATING,
          );
        }
      }

    } catch (e) {
      // General catch block for any unexpected errors
      isLoadingReset = false;
      update();
      if (kDebugMode) {
        print("Unexpected error: $e");
      }
      Get.snackbar(
        'Reset password',
        "Something went wrong! Or Invalid user data",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        isDismissible: true,
        snackStyle: SnackStyle.FLOATING,
      );
    }

    update();
  }

  // for user Section
  dynamic getUserToken(){
    update();
    log(authRepo.getUserToken());
    return authRepo.getUserToken();
  }

  // remove user Section
  void removeUserToken(){
    update();
    log("remove");
    log(authRepo.removeUserToken());
    authRepo.removeUserToken();
  }

  //get auth token
  getAuthToken() {
    //update();
    dioClient.updateHeader(authRepo.getAuthToken(), '');
    return authRepo.getAuthToken();
  }

}