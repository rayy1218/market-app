import 'package:dio/dio.dart';
import 'package:supermarket_management/api/general_response.dart';
import 'package:supermarket_management/api/master_service.dart';

class SupplyService {
  late Dio dio;

  SupplyService.of(String token):
        dio = MasterService.init(token: token);

  Future<GeneralResponse> createSupplier({
    name, phone, email, line1, line2, city, state, zipcode, country
  }) async {
    return await dio.post('/supply/supplier',
        data: {
          'name': name,
          'phone_number': phone,
          'email': email,
          'line1': line1,
          'line2': line2,
          'city': city,
          'state': state,
          'zipcode': zipcode,
          'country': country
        }
    ).then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> updateSupplier({
    id, name, phone, email, line1, line2, city, state, zipcode, country
  }) async {
    return await dio.put('/supply/supplier/$id',
        data: {
          'name': name,
          'phone_number': phone,
          'email': email,
          'line1': line1,
          'line2': line2,
          'city': city,
          'state': state,
          'zipcode': zipcode,
          'country': country
        }
    ).then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> fetchSuppliers() async {
    return await dio.get('/supply/suppliers')
        .then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> fetchSupplier({id}) async {
    return await dio.get('/supply/supplier/$id')
        .then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> createItemSource({
    itemMeta, supplier, unitPrice, minOrderQuantity, estimatedLeadTime
  }) async {
    return await dio.post('/supply/source',
      data: {
        'item_meta': itemMeta,
        'supplier': supplier,
        'unit_price': unitPrice,
        'min_order_quantity': minOrderQuantity,
        'estimated_lead_time': estimatedLeadTime
      }
    ).then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> updateItemSource({
    id, unitPrice, minOrderQuantity, estimatedLeadTime
  }) async {
    return await dio.put('/supply/source/$id',
        data: {
          'unit_price': unitPrice,
          'min_order_quantity': minOrderQuantity,
          'estimated_lead_time': estimatedLeadTime
        }
    ).then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> createOrder({
    supplier, remark, sendMail, orderItems
  }) async {
    return await dio.post('/supply/order',
        data: {
          'supplier': supplier,
          'remark': remark,
          'send_mail': sendMail,
          'order_items': orderItems,
        }
    ).then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> fetchOrders() async {
    return await dio.get('/supply/orders')
        .then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> fetchOrder({id}) async {
    return await dio.get('/supply/order/$id')
        .then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> setOrderStatus({id, status}) async {
    return await dio.put('/supply/order/$id',
      data: {
        'status': status
      }
    ).then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> setSupply({
    id, sourceId, onLowStockAction, defaultRestockQuantity, restockPoint
  }) async {
    return await dio.post('/supply/item/$id',
      data: {
        'item_source_id': sourceId,
        'on_low_stock_action': onLowStockAction,
        'default_restock_quantity': defaultRestockQuantity,
        'restock_point': restockPoint,
      }
    ).then((response) => GeneralResponse(response));
  }
}