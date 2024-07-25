import 'package:MarketEase/model/entity/checkout_item.dart';
import 'package:MarketEase/model/entity/item_meta.dart';
import 'package:MarketEase/model/entity/stock_location.dart';
import 'package:MarketEase/model/model.dart';
import 'package:MarketEase/model/model_or_id.dart';

class ItemSaleData extends Model {
  ItemSaleData({
    super.id,
    super.uuid,
    required this.itemMeta,
    required this.price,
    required this.startedAt,
    required this.defaultStockOutLocation
  });

  ModelOrId<ItemMeta> itemMeta;
  double price;
  DateTime startedAt;
  ModelOrId<StockLocation>? defaultStockOutLocation;
  List<CheckoutItem>? checkoutItems;

  ItemSaleData.fromMap(Map<String, dynamic> data):
      itemMeta = data['item_meta'] == null
          ? ModelOrId.id(id: data['item_meta_id'])
          : ModelOrId.data(data: ItemMeta.fromMap(data['item_meta'])),
      price = double.parse(data['price'].toString()),
      startedAt = DateTime.parse(data['started_at']),
      defaultStockOutLocation = data['default_stock_out_location'] == null
          ? data['default_stock_out_location_id'] == null ? null : ModelOrId.id(id: data['default_stock_out_location_id'])
          : ModelOrId.data(data: StockLocation.fromMap(data['default_stock_out_location'])),
      checkoutItems = data['checkout_items'] == null
          ? null
          : (data['checkout_items'] as List).map((item) => CheckoutItem.fromMap(item)).toList(),
      super(id: data['id']);
}