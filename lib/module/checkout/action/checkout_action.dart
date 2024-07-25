import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MarketEase/api/error_response.dart';
import 'package:MarketEase/api/general_response.dart';
import 'package:MarketEase/api/service/checkout_service.dart';
import 'package:MarketEase/main.dart';
import 'package:MarketEase/module/auth/ui/login_page.dart';

class CheckoutAction {
  late String token;
  BuildContext context;

  CheckoutAction.of(this.context) {
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

  Future create({customer, items}) async {
    return CheckoutService.of(token).checkout(customer: customer, items: items).then((response) {
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