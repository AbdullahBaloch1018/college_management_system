

import 'package:rise_college/data/response/status.dart';

class ApiResponse<T> {
  String? message;
  T? data;
  Status? status;

  ApiResponse({this.message, this.data, this.status});

  ApiResponse.loading(): status =Status.loading;

  ApiResponse.error(): status =Status.error;

  ApiResponse.completed(): status =Status.complete;


  @override
  String toString() {
    return "Status: $status, \n Data: $data, \n Message: $message";
  }
}