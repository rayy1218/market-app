import 'package:dio/dio.dart';
import 'package:MarketEase/api/general_response.dart';
import 'package:MarketEase/api/master_service.dart';

class CheckoutService {
  late Dio dio;

  CheckoutService.of(String token):
        dio = MasterService.init(token: token);

  Future<GeneralResponse> checkout({customer, items}) async {
    return await dio.post('/checkout/create',
        data: {
          'customer': customer,
          'items': items,
        }
    ).then((response) => GeneralResponse(response));
  }
}