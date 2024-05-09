import 'package:supermarket_management/model/entity/item_stock_data.dart';
import 'package:supermarket_management/model/model.dart';
import 'package:supermarket_management/model/model_or_id.dart';

class StockLocation extends Model {
  ModelOrId<StockLocation>? parent;
  List<StockLocation>? children;
  List<ItemStockData>? stocks;
  String name;

  StockLocation({required this.parent, required this.name, this.stocks, this.children});

  StockLocation.fromMap(Map<String, dynamic> data):
    parent = data['parent_id'] == null
        ? null
        : data['parent'] == null
          ? ModelOrId.id(id: data['parent_id'])
          : ModelOrId.data(data: StockLocation.fromMap(data['parent']), id: data['parent_id']),
    children = data['children'] == null
        ? null
        : (data['children'] as List).map((item) => StockLocation.fromMap(item)).toList(),
    stocks = data['stocks'] == null
        ? null
        : (data['stocks'] as List).map((item) => ItemStockData.fromMap(item)).toList(),
    name = data['name'],
    super(id: data['id']);
}