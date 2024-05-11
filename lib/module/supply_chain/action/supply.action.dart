import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket_management/api/error_response.dart';
import 'package:supermarket_management/api/general_response.dart';
import 'package:supermarket_management/api/service/supply_service.dart';
import 'package:supermarket_management/main.dart';
import 'package:supermarket_management/module/auth/ui/login_page.dart';

class SupplyAction {
  late String token;
  BuildContext context;

  SupplyAction.of(this.context) {
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

  Future createSupplier({
    name, phone, email, line1, line2, city, state, zipcode, country
  }) async {
    return SupplyService.of(token).createSupplier(
        name: name, phone: phone, email: email, line1: line1, line2: line2,
        city: city, state: state, zipcode: zipcode, country: country,
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

  Future updateSupplier({
    id, name, phone, email, line1, line2, city, state, zipcode, country
  }) async {
    return SupplyService.of(token).updateSupplier(
      id: id, name: name, phone: phone, email: email, line1: line1,
      line2: line2, city: city, state: state, zipcode: zipcode,
      country: country,
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

  Future fetchSuppliers() async {
    return SupplyService.of(token).fetchSuppliers().then((response) {
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

  Future fetchSupplier({id}) async {
    return SupplyService.of(token).fetchSupplier(id: id).then((response) {
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

  Future createItemSource({itemMeta, supplier, unitPrice, minOrderQuantity, estimatedLeadTime}) async {
    return SupplyService.of(token).createItemSource(
        itemMeta: itemMeta, supplier: supplier, unitPrice: unitPrice,
        minOrderQuantity: minOrderQuantity, estimatedLeadTime: estimatedLeadTime
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

  Future updateItemSource({id, unitPrice, minOrderQuantity, estimatedLeadTime}) async {
    return SupplyService.of(token).updateItemSource(
        id: id, unitPrice: unitPrice, minOrderQuantity: minOrderQuantity,
        estimatedLeadTime: estimatedLeadTime
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

  Future createOrder({supplier, remark, sendMail, orderItems}) async {
    return SupplyService.of(token).createOrder(
        supplier: supplier, remark: remark, sendMail: sendMail,
        orderItems: orderItems
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

  Future fetchOrders() async {
    return SupplyService.of(token).fetchOrders().then((response) {
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

  Future fetchOrder({id}) async {
    return SupplyService.of(token).fetchOrder(id: id).then((response) {
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

  Future setOrderStatus({id, status}) async {
    return SupplyService.of(token).setOrderStatus(id: id, status: status).then((response) {
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