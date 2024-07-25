import 'package:dio/dio.dart';
import 'package:MarketEase/api/general_response.dart';
import 'package:MarketEase/api/master_service.dart';

class ScheduleService {
  late Dio dio;

  ScheduleService.of(String token):
        dio = MasterService.init(token: token);

  Future<GeneralResponse> fetchToday() async {
    return await dio.get('/schedule/entries')
        .then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> create({type}) async {
    return await dio.post('/schedule/entry', data: {'type': type})
        .then((response) => GeneralResponse(response));
  }
}