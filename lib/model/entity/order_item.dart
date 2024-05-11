import 'package:supermarket_management/model/entity/item_source.dart';
import 'package:supermarket_management/model/entity/order.dart';
import 'package:supermarket_management/model/model.dart';
import 'package:supermarket_management/model/model_or_id.dart';

class OrderItem extends Model {
  OrderItem({
    required this.order,
    required this.itemSource,
    required this.quantity,
  });

  ModelOrId<Order> order;
  ModelOrId<ItemSource> itemSource;
  int quantity;

  OrderItem.fromMap(Map<String, dynamic> data):
      order = data['order'] == null
          ? ModelOrId.id(id: data['order_id'])
          : ModelOrId.data(data: data['order']),
      itemSource = data['item_source'] == null
          ? ModelOrId.id(id: data['item_source_id'])
          : ModelOrId.data(data: ItemSource.fromMap(data['item_source'])),
      quantity = data['quantity'],
      super(id: data['id']);
}