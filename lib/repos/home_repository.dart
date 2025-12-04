import '../data/network/base_api_services.dart';
import '../data/network/network_api_services.dart';
import '../model/movies_model.dart';
import '../resources/app_urls.dart';

class HomeRepository {
  final BaseApiServices  _apiService = NetworkApiServices();

  Future<MoviesModel> getMoviesList()async{
    try{
      var response = await _apiService.getApiResponse(AppUrls.moviesListEndPoint);
      return response = MoviesModel.fromJson(response);
    }
    catch(e){
      rethrow;
    }
  }
}