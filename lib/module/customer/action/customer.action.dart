import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MarketEase/api/error_response.dart';
import 'package:MarketEase/api/general_response.dart';
import 'package:MarketEase/api/service/customer_service.dart';
import 'package:MarketEase/main.dart';
import 'package:MarketEase/module/auth/ui/login_page.dart';

class CustomerAction {
  late String token;
  BuildContext context;

  CustomerAction.of(this.context) {
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

  Future fetchCustomer({id}) async {
    return CustomerService.of(token).fetchCustomer(id: id).then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return ErrorResponse(message: response.data['message']);

        case ResponseStatus.error:
          return ErrorResponse(message: 'FAILED_SERVER');
      }
    });
  }

  Future fetchCustomers() async {
    return CustomerService.of(token).fetchCustomers().then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return ErrorResponse(message: response.data['message']);

        case ResponseStatus.error:
          return ErrorResponse(message: 'FAILED_SERVER');
      }
    });
  }

  Future createCustomer({name, phone, email}) async {
    return CustomerService.of(token).createCustomer(name: name, phone: phone, email: email).then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return ErrorResponse(message: response.data['message']);

        case ResponseStatus.error:
          return ErrorResponse(message: 'FAILED_SERVER');
      }
    });
  }

  Future updateCustomer({id, name, phone, email}) async {
    return CustomerService.of(token).updateCustomer(
        id: id, name: name, phone: phone, email: email
    ).then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return ErrorResponse(message: response.data['message']);

        case ResponseStatus.error:
          return ErrorResponse(message: 'FAILED_SERVER');
      }
    });
  }

  Future deleteCustomer({id}) async {
    return CustomerService.of(token).deleteCustomer(id: id).then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return ErrorResponse(message: response.data['message']);

        case ResponseStatus.error:
          return ErrorResponse(message: 'FAILED_SERVER');
      }
    });
  }
}