import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MarketEase/api/general_response.dart';
import 'package:MarketEase/api/service/reporting_service.dart';
import 'package:MarketEase/main.dart';
import 'package:MarketEase/module/auth/ui/login_page.dart';

class ReportAction {
  late String token;
  BuildContext context;

  ReportAction.of(this.context) {
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

  Future fetchOrderSummary() async {
    return ReportingService.of(token).fetchOrderSummary().then((response) {
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

  Future fetchStockFlowSummary() async {
    return ReportingService.of(token).fetchStockFlowSummary().then((response) {
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

  Future fetchStockFlowLog() async {
    return ReportingService.of(token).fetchStockFlowLog().then((response) {
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

  Future fetchFinanceReport() async {
    return ReportingService.of(token).fetchFinanceReport().then((response) {
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