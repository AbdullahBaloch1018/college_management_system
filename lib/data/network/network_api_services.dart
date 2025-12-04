import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../app_exception.dart';
import 'base_api_services.dart';

class NetworkApiServices extends BaseApiServices {

  @override
  Future getApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(url)).timeout(
          Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on Socket {
      throw FetchDataException();
    }
    return responseJson;
  }

  @override
  Future postApiResponse(String url, data) async {
    dynamic responseJson;
    try {
      final response = await http.post(
          Uri.parse(url),
          body: data
      ).timeout(Duration(seconds: 8));
      responseJson = returnResponse(response);
    } on Socket {
      throw FetchDataException();
    }
    return responseJson;
  }


  //   Creating A return response method to check the response
  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 404:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException(
            "Error occured while communicating with server with status code ${response
                .statusCode}");
    }
  }
}