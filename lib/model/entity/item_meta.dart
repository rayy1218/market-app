import 'package:supermarket_management/model/entity/brand.dart';
import 'package:supermarket_management/model/entity/category.dart';
import 'package:supermarket_management/model/entity/company.dart';
import 'package:supermarket_management/model/entity/item_stock_data.dart';
import 'package:supermarket_management/model/model.dart';
import 'package:supermarket_management/model/model_or_id.dart';

class ItemMeta extends Model {
  ModelOrId<Company> company;
  String name;
  String stockKeepingUnit;
  String universalProductCode;
  ModelOrId<Brand>? brand;
  ModelOrId<Category>? category;
  List<ItemStockData>? stocks;
  int? stockNumber;

  ItemMeta({
    required this.company, required this.name, required this.stockKeepingUnit,
    required this.universalProductCode, this.brand,
    this.category,
  });

  ItemMeta.fromMap(Map<String, dynamic> data):
      company = ModelOrId.id(id: (data['company_id'])),
      name = data['name'],
      stockKeepingUnit = data['stock_keeping_unit'],
      universalProductCode = data['universal_product_code'],
      brand = data['brand'] is int ? ModelOrId.id(id: data['brand']) : ModelOrId.data(data: Brand.fromMap(data['brand'])),
      category = data['category'] is int ? ModelOrId.id(id: data['category']) : ModelOrId.data(data: Category.fromMap(data['category'])),
      stockNumber = data['stock_count'],
      stocks = data['stocks'] == null
          ? null
          : (data['stocks'] as List).map((item) => ItemStockData.fromMap(item)).toList(),
      super(id: data['id']);
}