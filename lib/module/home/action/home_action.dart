import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket_management/api/general_response.dart';
import 'package:supermarket_management/api/service/reporting_service.dart';
import 'package:supermarket_management/main.dart';
import 'package:supermarket_management/module/auth/ui/login_page.dart';

class HomeAction {
  late String token;
  BuildContext context;

  HomeAction.of(this.context) {
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

  Future fetchShift() async {
    return ReportingService.of(token).fetchToday().then((response) {
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

  Future fetchUnderStock() async {
    return ReportingService.of(token).fetchUnderStock().then((response) {
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

  Future fetchStockLocationSummary() async {
    return ReportingService.of(token).fetchStockLocationSummary().then((response) {
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

  Future fetchDeliveringOrders() async {
    return ReportingService.of(token).fetchDeliveringOrders().then((response) {
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