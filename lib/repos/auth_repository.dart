import '../data/network/base_api_services.dart';
import '../data/network/network_api_services.dart';
import '../resources/app_urls.dart';

class AuthRepository {
  final BaseApiServices _apiService = NetworkApiServices();

  Future<dynamic> loginApi(dynamic data) async {
    try {
      dynamic response = await _apiService.postApiResponse(
        AppUrls.loginEndPoint,
        data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> registerApi(dynamic data) async {
    try {
      dynamic response = await _apiService.postApiResponse(
        AppUrls.registerEndPoint,
        data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
