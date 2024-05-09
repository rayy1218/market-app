import 'package:supermarket_management/model/entity/item_meta.dart';
import 'package:supermarket_management/model/entity/stock_location.dart';
import 'package:supermarket_management/model/model.dart';
import 'package:supermarket_management/model/model_or_id.dart';

class ItemStockData extends Model {
  ModelOrId<ItemMeta> itemMeta;
  ModelOrId<StockLocation> stockLocation;
  int quantity;

  ItemStockData({required this.itemMeta, required this.stockLocation, required this.quantity});

  ItemStockData.fromMap(Map<String, dynamic> data):
      itemMeta = data['item_meta'] == null
          ? ModelOrId.id(id: data['item_meta_id'])
          : ModelOrId.data(data: ItemMeta.fromMap(data['item_meta'])),
      stockLocation = data['stock_location'] == null
          ? ModelOrId.id(id: data['location_id'])
          : ModelOrId.data(data: StockLocation.fromMap(data['stock_location'])),
      quantity = data['quantity'],
      super(id: data['id']);
}