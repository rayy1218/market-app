import 'package:dio/dio.dart';
import 'package:supermarket_management/api/general_response.dart';
import 'package:supermarket_management/api/master_service.dart';

class ReportingService {
  late Dio dio;

  ReportingService.of(String token):
        dio = MasterService.init(token: token);

  Future<GeneralResponse> fetchToday() async {
    return await dio.post('/report/shift-today')
        .then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> fetchUnderStock() async {
    return await dio.post('/report/under-stock')
        .then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> fetchOrderSummary() async {
    return await dio.post('/report/order-summary')
        .then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> fetchStockFlowSummary() async {
    return await dio.post('/report/inventory-stock-flow-summary')
        .then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> fetchStockFlowLog() async {
    return await dio.post('/report/stock-flow-log')
        .then((response) => GeneralResponse(response));
  }
}