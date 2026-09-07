import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../app_excaptions.dart';
import 'base_api_services.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw RequestTimeOutException('Request timed out, please try again');
    }

    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse(url),
            body: data,
          )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw RequestTimeOutException('Request timed out, please try again');
    }

    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map && decoded.containsKey('error')) {
            throw BadRequestException(decoded['error'].toString());
          }
        } catch (e) {
          if (e is AppException) rethrow;
        }
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
      case 404:
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map && decoded.containsKey('error')) {
            throw UnauthorisedException(decoded['error'].toString());
          }
        } catch (e) {
          if (e is AppException) rethrow;
        }
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while communicating with server with status code: ${response.statusCode}');
    }
  }
}
