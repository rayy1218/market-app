import 'package:supermarket_management/model/entity/checkout.dart';
import 'package:supermarket_management/model/entity/item_sale_data.dart';
import 'package:supermarket_management/model/model.dart';
import 'package:supermarket_management/model/model_or_id.dart';

class CheckoutItem extends Model {
  CheckoutItem({
    super.id,
    super.uuid,
    required this.itemSaleData,
    required this.checkout,
    required this.quantity,
  });

  ModelOrId<ItemSaleData> itemSaleData;
  ModelOrId<Checkout> checkout;
  int quantity;

  CheckoutItem.fromMap(Map<String, dynamic> data):
      itemSaleData = data['sale_data'] != null
          ? ModelOrId.data(data: ItemSaleData.fromMap(data['sale_data']))
          : ModelOrId.id(id: data['item_sale_data_id']),
      checkout = data['checkout'] != null
          ? ModelOrId.data(data: Checkout.fromMap(data['checkout']))
          : ModelOrId.id(id: data['checkout_id']),
      quantity = data['quantity'],
      super(id: data['id']);
}