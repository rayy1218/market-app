import 'package:dio/dio.dart';

class GeneralResponse {
  late ResponseStatus status;
  late Map<String, dynamic> data;

  GeneralResponse(Response response) {
    switch (response.data['status']) {
      case 0:
        status = ResponseStatus.success;
        break;

      case 1:
        status = ResponseStatus.rejected;
        break;

      case 2:
        status = ResponseStatus.error;
        break;

      default:
        status = ResponseStatus.error;
    }

    data = response.data;
  }
}

enum ResponseStatus {
  success, rejected, error
}