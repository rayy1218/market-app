import 'package:MarketEase/model/entity/item_sale_data.dart';
import 'package:MarketEase/model/entity/brand.dart';
import 'package:MarketEase/model/entity/category.dart';
import 'package:MarketEase/model/entity/company.dart';
import 'package:MarketEase/model/entity/item_source.dart';
import 'package:MarketEase/model/entity/item_stock_data.dart';
import 'package:MarketEase/model/entity/item_supply_data.dart';
import 'package:MarketEase/model/entity/stock_location.dart';
import 'package:MarketEase/model/model.dart';
import 'package:MarketEase/model/model_or_id.dart';

class ItemMeta extends Model {
  ModelOrId<Company> company;
  String name;
  String stockKeepingUnit;
  String universalProductCode;
  ModelOrId<Brand>? brand;
  ModelOrId<Category>? category;
  List<ItemStockData>? stocks;
  int? stockNumber;
  List<ItemSource>? sources;
  ModelOrId<ItemSupplyData>? supply;
  ItemSaleData? saleData;
  double? capital;
  int? quantity;
  ModelOrId<StockLocation>? receive;

  ItemMeta({
    required this.company, required this.name, required this.stockKeepingUnit,
    required this.universalProductCode, this.brand,
    this.category, required this.supply
  });

  ItemMeta.fromMap(Map<String, dynamic> data):
      company = ModelOrId.id(id: (data['company_id'])),
      name = data['name'],
      stockKeepingUnit = data['stock_keeping_unit'],
      universalProductCode = data['universal_product_code'],
      brand = data['brand'] == null ? null : data['brand'] is int ? ModelOrId.id(id: data['brand']) : ModelOrId.data(data: Brand.fromMap(data['brand'])),
      category =  data['brand'] == null ? null : data['category'] is int ? ModelOrId.id(id: data['category']) : ModelOrId.data(data: Category.fromMap(data['category'])),
      stockNumber = data['stock_count'],
      stocks = data['stocks'] == null
          ? null
          : (data['stocks'] as List).map((item) => ItemStockData.fromMap(item)).toList(),
      sources = data['sources'] == null
          ? null
          : (data['sources'] as List).map((item) => ItemSource.fromMap(item)).toList(),
      supply = data['supply_data'] == null
          ? null
          : ModelOrId.data(data: ItemSupplyData.fromMap(data['supply_data'])),
      saleData = data['sale_data'] == null
          ? null
          : ItemSaleData.fromMap(data['sale_data']),
      capital = data['capital'] == null ? null : double.parse(data['capital'].toString()),
      quantity = data['quantity'],
      receive = data['default_receive_location'] == null
          ? null
          : data['default_receive_location'] is int
            ? ModelOrId.id(id: data['default_receive_location'])
            : ModelOrId.data(data: StockLocation.fromMap(data['default_receive_location'])),
      super(id: data['id']);
}