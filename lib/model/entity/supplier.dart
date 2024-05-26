import 'package:supermarket_management/model/entity/address.dart';
import 'package:supermarket_management/model/entity/item_source.dart';
import 'package:supermarket_management/model/entity/order.dart';
import 'package:supermarket_management/model/model.dart';

class Supplier extends Model {
  Address? address;
  String name;
  String phone;
  String email;
  List<ItemSource>? sources;
  List<Order>? orders;
  int? orderNumber;
  double? orderCapital;

  Supplier({
    required this.address, required this.name, required this.phone,
    required this.email
  });

  Supplier.fromMap(Map<String, dynamic> data):
      address = data['address'] == null ? null : Address.fromMap(data['address']),
      name = data['name'],
      phone = data['phone_number'],
      email = data['email'],
      orders = data['orders'] == null ? null : (data['orders'] as List).map((e) => Order.fromMap(e)).toList(),
      sources = data['sources'] == null ? null : (data['sources'] as List).map((e) => ItemSource.fromMap(e)).toList(),
      orderCapital = (data['capital'] as int).toDouble(),
      orderNumber = data['number'],
      super(id: data['id']);
}