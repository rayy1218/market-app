import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket_management/api/service/employee_service.dart';
import 'package:supermarket_management/api/general_response.dart';
import 'package:supermarket_management/main.dart';
import 'package:supermarket_management/module/auth/ui/login_page.dart';

class EmployeeAction {
  late String token;
  BuildContext context;

  EmployeeAction.of(this.context) {
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

  Future fetchByPage({context, page}) async {
    return EmployeeService.of(token).fetchPage(page: page).then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response;

        case ResponseStatus.rejected:
          return response.data['message'];

        case ResponseStatus.error:
          return 'FAILED_SERVER';
      }
    });
  }

  Future fetchOne({id}) async {
    return EmployeeService.of(token).fetchOne(id: id).then((response) {
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

  Future create({email, username, group}) async {
    return EmployeeService.of(token).create(
        email: email,
        username: username,
        group: group
    ).then((response) {
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

  Future fetchGroupDropdown() async {
    return EmployeeService.of(token).fetchGroupDropdown().then((response) {
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

  Future delete({id}) async {
    return EmployeeService.of(token).delete(id: id).then((response) {
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
}