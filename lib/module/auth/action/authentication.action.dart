import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket_management/api/service/authentication_service.dart';
import 'package:supermarket_management/api/general_response.dart';

import '../../../main.dart';

class AuthenticationAction {
  static Future login(context, email, password) async {
    final bloc = BlocProvider.of<AuthenticationBloc>(context);

    return AuthenticationService().login(email: email, password: password).then((response) {
      switch (response.status) {
        case ResponseStatus.success:


          bloc.add(LogInEvent(
              token: response.data['token']
          ));
          return null;

        case ResponseStatus.rejected:
          return response.data['message'];

        case ResponseStatus.error:
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Server Error'),
          ));

          return 'FAILED_SERVER';
      }
    });
  }

  static Future register(context, email, password, username, lastName, firstName, companyName) async {
    return AuthenticationService().register(
        email: email,
        password: password,
        username: username,
        lastName: lastName,
        firstName: firstName,
        companyName: companyName,
    ).then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          final bloc = BlocProvider.of<AuthenticationBloc>(context);

          bloc.add(LogInEvent(
              token: response.data['token']
          ));
          return null;

        case ResponseStatus.rejected:
          return response.data['message'];

        case ResponseStatus.error:
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Server Error'),
          ));

          return 'FAILED_SERVER';
      }
    });
  }
}

