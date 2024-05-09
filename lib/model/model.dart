import 'package:faker/faker.dart' as faker;
import 'package:supermarket_management/model/entity/access_right.dart';
import 'package:supermarket_management/model/model_or_id.dart';

import 'entity/address.dart';
import 'entity/company.dart';
import 'entity/group.dart';
import 'entity/item_meta.dart';

class Model {
  Model({this.id, this.uuid});

  int? id;
  String? uuid;
}

class User extends Model {
  User({
    super.id,
    super.uuid,
    required this.group,
    required this.company,
    required this.username,
    required this.email,
    this.lastName,
    this.firstName,
  });

  ModelOrId<Group> group;
  ModelOrId<Company> company;
  String username;
  String email;
  String? lastName;
  String? firstName;
}

class ShiftRecord extends Model {
  ShiftRecord({
    super.id,
    super.uuid,
    required this.user,
    required this.timestamp,
    required this.type,
  });

  ModelOrId<User> user;
  DateTime timestamp;
  ShiftType type;
}

enum ShiftType {
  clockIn(label: 'Clock In'),
  clockOut(label: 'Clock Out'),
  breakStart(label: 'Break Start'),
  breakEnd(label: 'Break End');

  const ShiftType({required this.label});

  final String label;
}

class Supplier extends Model {
  Supplier({
    super.id,
    super.uuid,
    required this.company,
    required this.address,
    required this.name,
    required this.phoneNumber,
    required this.email,
  });

  ModelOrId<Company> company;
  ModelOrId<Address> address;
  String name;
  String phoneNumber;
  String email;
}

class ItemSource extends Model {
  ItemSource({
    super.id,
    super.uuid,
    required this.supplier,
    required this.itemMeta,
    required this.unitPrice,
    required this.minOrderQuantity,
    required this.estimatedLeadTime,
  });

  ModelOrId<Supplier> supplier;
  ModelOrId<ItemMeta> itemMeta;
  double unitPrice;
  int minOrderQuantity;
  int estimatedLeadTime;
}

class ItemSupplyData extends Model {
  ItemSupplyData({
    super.id,
    super.uuid,
    required this.itemSource,
    required this.itemMeta,
    required this.onLowStockAction,
    required this.defaultRestockQuantity,
    required this.restockingPoint,
  });

  ModelOrId<ItemSource> itemSource;
  ModelOrId<ItemMeta> itemMeta;
  RestockAction onLowStockAction;
  int defaultRestockQuantity;
  int restockingPoint;
}

enum RestockAction {
  email,
  notify,
  none,
}

class Order extends Model {
  Order({
    super.id,
    super.uuid,
    required this.company,
    required this.supplier,
    required this.user,
    required this.status,
    required this.remark,
    required this.timestamp,
  });

  ModelOrId<Company> company;
  ModelOrId<Supplier> supplier;
  ModelOrId<User> user;
  OrderStatus status;
  String remark;
  DateTime timestamp;
}

enum OrderStatus {
  created(label: 'Created'),
  canceled(label: 'Canceled'),
  confirmed(label: 'Confirmed'),
  delivering(label: 'Delivering'),
  completed(label: 'Completed');

  const OrderStatus({required this.label});

  final String label;
}

class OrderItem extends Model {
  OrderItem({
    super.id,
    super.uuid,
    required this.order,
    required this.itemSource,
    required this.quantity,
  });

  ModelOrId<Order> order;
  ModelOrId<ItemSource> itemSource;
  int quantity;
}

class ItemSaleData extends Model {
  ItemSaleData({
    super.id,
    super.uuid,
    required this.itemMeta,
    required this.price,
    required this.startedAt,
  });

  ModelOrId<ItemMeta> itemMeta;
  double price;
  DateTime startedAt;
}

class ItemPriceModifier extends Model {
  ItemPriceModifier({
    super.id,
    super.uuid,
    required this.itemSaleData,
    required this.price,
    required this.startedAt,
    required this.endedAt,
  });

  ModelOrId<ItemSaleData> itemSaleData;
  double price;
  DateTime startedAt;
  DateTime endedAt;
}

class Customer extends Model {
  Customer({
    super.id,
    super.uuid,
    required this.company,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  ModelOrId<Company> company;
  String name;
  String email;
  String phoneNumber;
}

class Checkout extends Model {
  Checkout({
    super.id,
    super.uuid,
    required this.company,
    required this.customer,
    required this.user,
    required this.amount,
    required this.timestamp,
    required this.status,
    required this.paymentMethod,
  });

  ModelOrId<Company> company;
  ModelOrId<Customer> customer;
  ModelOrId<User> user;
  double amount;
  DateTime timestamp;
  String status;
  String paymentMethod;
}

class CheckoutItem extends Model {
  CheckoutItem({
    super.id,
    super.uuid,
    required this.itemSaleData,
    required this.checkout,
    this.modifier,
    required this.quantity,
  });

  ModelOrId<ItemSaleData> itemSaleData;
  ModelOrId<Checkout> checkout;
  ModelOrId<ItemPriceModifier>? modifier;
  int quantity;
}
