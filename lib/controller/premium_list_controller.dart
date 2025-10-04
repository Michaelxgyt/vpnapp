import 'package:get/get.dart';
import '../data/model/base_model/api_response.dart';
import '../data/repository/premium_list_repo.dart';

class PremiumListController extends GetxController {
  final PremiumListRepo premiumListRepo;

  PremiumListController({required this.premiumListRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  dynamic premiumServerData;

  Future<dynamic> getServerList({dynamic page}) async {
    _isLoading = true;
    update();
    ApiResponse apiResponse = await premiumListRepo.getServerList(page);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      update();
      if (apiResponse.response!.data != null) {
        premiumServerData = apiResponse.response!.data["data"];
      }
    } else {
      _isLoading = false;
      update();
    }
  }

}
