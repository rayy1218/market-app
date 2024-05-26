import 'package:dio/dio.dart';
import 'package:supermarket_management/api/general_response.dart';
import 'package:supermarket_management/api/master_service.dart';

class CustomerService {
  late Dio dio;

  CustomerService.of(String token):
        dio = MasterService.init(token: token);

  Future<GeneralResponse> fetchCustomers() async {
    return await dio.get('/customer/entries')
        .then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> fetchCustomer({id}) async {
    return await dio.get('/customer/entry/$id')
        .then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> updateCustomer({id, name, phone, email}) async {
    return await dio.put('/customer/entry/$id',
        data: {
          'name': name,
          'phone': phone,
          'email': email,
        }
    ).then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> createCustomer({name, phone, email}) async {
    return await dio.post('/customer/entry',
      data: {
        'name': name,
        'phone': phone,
        'email': email,
      }
    ).then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> deleteCustomer({id}) async {
    return await dio.delete('/customer/entry/$id')
        .then((response) => GeneralResponse(response));
  }
}