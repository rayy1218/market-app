import 'package:supermarket_management/model/entity/item_meta.dart';
import 'package:supermarket_management/model/entity/supplier.dart';
import 'package:supermarket_management/model/model.dart';
import 'package:supermarket_management/model/model_or_id.dart';

class ItemSource extends Model {
  ModelOrId<Supplier> supplier;
  ModelOrId<ItemMeta> itemMeta;
  double unitPrice;
  int minOrderQuantity;
  int estimatedLeadTime;

  ItemSource({
    required this.supplier,
    required this.itemMeta,
    required this.unitPrice,
    required this.minOrderQuantity,
    required this.estimatedLeadTime,
  });

  ItemSource.fromMap(Map<String, dynamic> data):
      supplier = data['supplier'] == null
          ? ModelOrId.id(id: data['supplier_id'])
          : ModelOrId.data(data: Supplier.fromMap(data['supplier'])),
      itemMeta = data['item_meta'] == null
          ? ModelOrId.id(id: data['item_meta_id'])
          : ModelOrId.data(data: ItemMeta.fromMap(data['item_meta'])),
      unitPrice = data['unit_price'].toDouble(),
      minOrderQuantity = data['min_order_quantity'],
      estimatedLeadTime = data['estimated_lead_time_day'],
      super(id: data['id']);
}