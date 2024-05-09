import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket_management/api/general_response.dart';
import 'package:supermarket_management/api/service/group_service.dart';
import 'package:supermarket_management/main.dart';
import 'package:supermarket_management/module/auth/ui/login_page.dart';

class GroupAction {
  late String token;
  BuildContext context;

  GroupAction.of(this.context) {
    final bloc = BlocProvider.of<AuthenticationBloc>(context);
    if (bloc is LogoutState) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const LoginPage())
      );
    }
    else {
      token = (bloc.state as LogonState).token;
    }
  }

  Future fetchAll() async {
    return GroupService.of(token).fetchGroupDropdown().then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return response.data['message'];

        case ResponseStatus.error:
          return 'FAILED_SERVER';
      }
    });
  }

  Future fetchByPage() async {
    return GroupService.of(token).fetchList().then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return response.data['message'];

        case ResponseStatus.error:
          return 'FAILED_SERVER';
      }
    });
  }

  Future fetchOne({id}) async {
    return GroupService.of(token).fetchOne(id: id).then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return response.data['message'];

        case ResponseStatus.error:
          return 'FAILED_SERVER';
      }
    });
  }

  Future create({name, accessRight}) async {
    return GroupService.of(token).createGroup(name: name, accessRight: accessRight).then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return response.data['message'];

        case ResponseStatus.error:
          return 'FAILED_SERVER';
      }
    });
  }

  Future fetchAccessRightDropdown() async {
    return GroupService.of(token).fetchAccessRightDropdown().then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return response.data['message'];

        case ResponseStatus.error:
          return 'FAILED_SERVER';
      }
    });
  }

  Future updateGroupName({id, name}) async {
    return GroupService.of(token).updateGroupName(id: id, name: name).then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return null;

        case ResponseStatus.rejected:
          return response.data['message'];

        case ResponseStatus.error:
          return 'FAILED_SERVER';
      }
    });
  }

  Future updateAccessRight({id, accessRight}) async {
    return GroupService.of(token).updateGroupAccessRight(id: id, accessRight: accessRight).then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return null;

        case ResponseStatus.rejected:
          return response.data['message'];

        case ResponseStatus.error:
          return 'FAILED_SERVER';
      }
    });
  }

  Future updateMember({id, newMember}) async {
    return GroupService.of(token).updateGroupMember(id: id, newMember: newMember).then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return null;

        case ResponseStatus.rejected:
          return response.data['message'];

        case ResponseStatus.error:
          return 'FAILED_SERVER';
      }
    });
  }

  Future getMemberList({id}) async {
    return GroupService.of(token).getMemberList(id: id).then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return response.data['message'];

        case ResponseStatus.error:
          return 'FAILED_SERVER';
      }
    });
  }
}