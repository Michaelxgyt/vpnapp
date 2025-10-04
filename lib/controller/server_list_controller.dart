import 'package:get/get.dart';
import '../data/model/base_model/api_response.dart';
import '../data/repository/server_list_repo.dart';

class ServerListController extends GetxController {
  final ServerListRepo serverListRepo;

  ServerListController({required this.serverListRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  dynamic freeServerData;

  Future<dynamic> getServerList({dynamic page}) async {
    _isLoading = true;
    update();
    ApiResponse apiResponse = await serverListRepo.getServerList(page);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      update();
      if (apiResponse.response!.data != null) {
        freeServerData = apiResponse.response!.data["data"];
      }
    } else {
      _isLoading = false;
      update();
    }
  }


}