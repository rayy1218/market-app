import 'package:dio/dio.dart';
import 'package:supermarket_management/api/general_response.dart';
import 'package:supermarket_management/api/master_service.dart';

class GroupService {
  late Dio dio;

  GroupService.of(String token):
        dio = MasterService.init(token: token);

  Future<GeneralResponse> fetchGroupDropdown() async {
    return await dio.get('/managerial/groups/all')
        .then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> fetchList() async {
    return await dio.get('/managerial/groups')
        .then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> createGroup({name, accessRight}) async {
    return await dio.post('/managerial/group',
      data: {
        'name': name,
        'access_right': accessRight,
      }
    ).then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> fetchAccessRightDropdown() async {
    return await dio.get('/managerial/access-rights-dropdown')
        .then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> fetchOne({id}) async {
    return await dio.get('/managerial/group/$id')
        .then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> updateGroupAccessRight({id, accessRight}) async {
    return await dio.put('/managerial/group/$id',
      data: {
        'access_right': accessRight,
      },
    ).then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> updateGroupName({id, name}) async {
    return await dio.put('/managerial/group/$id',
        data: {
          'name': name,
        }
    ).then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> getMemberList({id}) async {
    return await dio.get('/managerial/member-list',
      data: {
        'id': id,
      }
    ).then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> updateGroupMember({id, newMember}) async {
    return await dio.put('/managerial/group/$id',
      data: {
        'member': newMember,
      }
    ).then((response) => GeneralResponse(response));
  }
}