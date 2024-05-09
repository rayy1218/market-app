import 'package:dio/dio.dart';
import 'package:supermarket_management/api/general_response.dart';
import 'package:supermarket_management/api/master_service.dart';
import 'package:supermarket_management/model/entity/access_right.dart';

class AuthenticationService {
  late Dio dio;

  AuthenticationService():
        dio = MasterService.init();

  AuthenticationService.of(String? token):
        dio = MasterService.init(token: token);

  Future<GeneralResponse> login({email, password}) async {
    return await dio.post('/auth/login',
      data: {
        'email': email,
        'password': password
      },
    ).then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> register({email, password, username, lastName, firstName, companyName}) async {
    return await dio.post('/auth/register',
      data: {
        'email': email,
        'password': password,
        'username': username,
        'last_name': lastName,
        'first_name': firstName,
        'company_name': companyName,
      },
    ).then((response) => GeneralResponse(response));
  }

  Future<List<AccessRight>> getAccessRight() async {
    return await dio.get('/auth/get-access-right')
        .then((response) => GeneralResponse(response))
        .then((response) {
          if (response.status != ResponseStatus.success) {
            return [];
          }
          else {
            return (response.data['data'] as List).map((item) => AccessRight.fromMap(item)).toList();
          }
        });
  }
}