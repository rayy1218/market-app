import 'package:MarketEase/model/entity/item_meta.dart';
import 'package:MarketEase/model/entity/item_source.dart';
import 'package:MarketEase/model/model.dart';
import 'package:MarketEase/model/model_or_id.dart';

class ItemSupplyData extends Model {
  ModelOrId<ItemSource> itemSource;
  ModelOrId<ItemMeta> itemMeta;
  RestockAction onLowStockAction;
  int defaultRestockQuantity;
  int restockingPoint;

  ItemSupplyData({required this.itemSource, required this.itemMeta, required this.onLowStockAction, required this.defaultRestockQuantity, required this.restockingPoint});

  ItemSupplyData.fromMap(Map<String, dynamic> data):
      itemSource = data['source'] == null 
          ? ModelOrId.id(id: data['item_source_id'])
          : ModelOrId.data(data: ItemSource.fromMap(data['source'])),
      itemMeta = data['item_meta'] == null
          ? ModelOrId.id(id: data['item_meta_id'])
          : ModelOrId.data(data: ItemMeta.fromMap(data['item_meta'])),
      onLowStockAction = RestockAction.fromString(data['on_low_stock_action']),
      defaultRestockQuantity = data['default_restock_quantity'],
      restockingPoint = data['restock_point'],
      super(id: data['id']);
}

enum RestockAction {
  email(value: 'email', label: 'Auto create order with mail sent to supplier'),
  notify(value: 'notify', label: 'Display on dashboard'),
  none(value: 'none', label: 'Do nothing');

  const RestockAction({required this.value, required this.label});

  final String value;
  final String label;

  static fromString(String str) {
    switch(str) {
      case 'email':
        return RestockAction.email;
      case 'notify':
        return RestockAction.notify;
      case 'none':
        return RestockAction.none;
    }
  }
}