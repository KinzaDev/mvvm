import 'package:mvvm/data/networks/base_api_services.dart';
import 'package:mvvm/data/networks/network_api_services.dart';
import 'package:mvvm/model/movies_model.dart';
import 'package:mvvm/res/app_url.dart';

class HomeRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<MovieListModel> fetchMoviesList() async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.moviesListEndPoint);
      return response = MovieListModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
