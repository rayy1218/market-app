import 'package:dio/dio.dart';
import 'package:MarketEase/api/general_response.dart';
import 'package:MarketEase/api/master_service.dart';

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

  Future<GeneralResponse> fetchStockLocationSummary() async {
    return await dio.post('/report/stock-location-summary')
        .then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> fetchDeliveringOrders() async {
    return await dio.post('/report/delivering-orders')
        .then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> fetchFinanceReport() async {
    return await dio.post('/report/inventory-finance-summary')
        .then((response) => GeneralResponse(response));
  }
}