import 'package:supermarket_management/model/entity/customer.dart';
import 'package:supermarket_management/model/entity/user.dart';
import 'package:supermarket_management/model/model_or_id.dart';
import 'package:supermarket_management/model/entity/company.dart';
import 'package:supermarket_management/model/entity/item_meta.dart';

class Model {
  Model({this.id, this.uuid});

  int? id;
  String? uuid;
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
