import 'package:get/get.dart';
import '../data/model/base_model/api_response.dart';
import '../data/repository/profile_repo.dart';

class ProfileController extends GetxController {
  final ProfileRepo profileRepo;

  ProfileController({required this.profileRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  bool _isLoadingCancel = false;
  bool get isLoadingCancel => _isLoadingCancel;

  dynamic profileData;
  dynamic subscriptionCancelData;

  Future<dynamic> getProfileData() async {
    _isLoading = true;
    update();
    ApiResponse apiResponse = await profileRepo.getProfileData();

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      update();
      if (apiResponse.response!.data != null) {
        profileData = apiResponse.response!.data;
      }
    } else {
      _isLoading = false;
      update();
    }
  }

  cancelSubscriptionData() async {
    _isLoadingCancel = true;
    update();
    ApiResponse apiResponse = await profileRepo.cancelSubscription();

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoadingCancel = false;
      update();
      if (apiResponse.response!.data != null) {
        subscriptionCancelData = apiResponse.response!.data;
      }
    } else {
      _isLoadingCancel = false;
      update();
    }
  }


}