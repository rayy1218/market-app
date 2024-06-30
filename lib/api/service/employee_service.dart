import 'package:dio/dio.dart';
import 'package:MarketEase/api/master_service.dart';
import 'package:MarketEase/api/general_response.dart';

class EmployeeService {
  late Dio dio;

  EmployeeService.of(String token):
        dio = MasterService.init(token: token);

  Future<GeneralResponse> fetchPage({page}) async {
    return await dio.get('/managerial/employees',
      queryParameters: {
        'page': page,
      },
    ).then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> fetchOne({id}) async {
    return await dio.get('/managerial/employee/$id',
    ).then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> create({username, group, email}) async {
    return await dio.post('/managerial/employee',
      data: {
        'username': username,
        'group': group,
        'email': email,
      },
    ).then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> fetchGroupDropdown() async {
    return await dio.get('/managerial/group-dropdown',
    ).then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> delete({id}) async {
    return await dio.delete('/managerial/employee/$id',
    ).then((response) => GeneralResponse(response));
  }
}