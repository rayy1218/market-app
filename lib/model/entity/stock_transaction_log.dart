import 'package:collection/collection.dart';
import 'package:MarketEase/model/entity/item_meta.dart';
import 'package:MarketEase/model/entity/order_item.dart';
import 'package:MarketEase/model/entity/stock_location.dart';
import 'package:MarketEase/model/entity/user.dart';
import 'package:MarketEase/model/model.dart';
import 'package:MarketEase/model/entity/checkout_item.dart';

enum StockTransactionType {
  stockIn(value: 'stock_in', label: 'Stock In'),
  stockOut(value: 'stock_out', label: 'Stock Out'),
  transfer(value: 'transfer', label: 'Stock Transfer'),
  split(value: 'split', label: 'Stock Split'),
  orderStockIn(value: 'order_stock_in', label: 'Stock In From Order'),
  checkoutStockOut(value: 'checkout_stock_out', label: 'Stock Out From Checkout');

  const StockTransactionType({required this.value, required this.label});

  final String value, label;

  static StockTransactionType? fromString(String str) {
    return StockTransactionType.values
        .firstWhereOrNull((e) => e.value == str);
  }
}

class StockTransactionLog extends Model {
  ItemMeta? stockInItem, stockOutItem;
  StockLocation? stockInLocation, stockOutLocation;
  int? stockInQuantity, stockOutQuantity;
  CheckoutItem? checkoutItem;
  OrderItem? orderItem;
  StockTransactionType type;
  DateTime createdAt;
  User? user;

  StockTransactionLog.fromMap(Map<String, dynamic> data):
      user = User.fromMap(data['user']),
      type = StockTransactionType.fromString(data['type'])!,
      stockInItem = data['stock_in_item'] != null ? ItemMeta.fromMap(data['stock_in_item']) : null,
      stockOutItem = data['stock_out_item'] != null ? ItemMeta.fromMap(data['stock_out_item']) : null,
      stockInLocation = data['stock_in_location'] != null ? StockLocation.fromMap(data['stock_in_location']) : null,
      stockOutLocation =  data['stock_out_location'] != null ? StockLocation.fromMap(data['stock_out_location']) : null,
      stockInQuantity = data['stock_in_quantity'],
      stockOutQuantity = data['stock_out_quantity'],
      checkoutItem = data['checkout_item'] != null ? CheckoutItem.fromMap(data['checkout_item']) : null,
      orderItem = data['order_item'],
      createdAt = DateTime.parse(data['created_at']),
      super(id: data['id']);
}