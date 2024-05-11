import 'package:supermarket_management/model/entity/order_item.dart';
import 'package:supermarket_management/model/entity/supplier.dart';
import 'package:supermarket_management/model/entity/user.dart';
import 'package:supermarket_management/model/model.dart';
import 'package:supermarket_management/model/model_or_id.dart';

enum OrderStatus {
  created(value: 'created', label: 'Created'),
  pending(value: 'pending', label: 'Pending'),
  confirmed(value: 'preparing', label: 'Confirmed'),
  delivering(value: 'delivering', label: 'Delivering'),
  completed(value: 'received', label: 'Completed'),
  canceled(value: 'canceled', label: 'Canceled'),
  error(value: 'error', label: 'Error');

  const OrderStatus({required this.label, required this.value});

  static fromString(String data) {
    switch (data) {
      case 'created':
        return OrderStatus.created;

      case 'pending':
        return OrderStatus.pending;

      case 'preparing':
        return OrderStatus.confirmed;

      case 'delivering':
        return OrderStatus.delivering;

      case 'received':
        return OrderStatus.completed;

      case 'canceled':
        return OrderStatus.canceled;

      default:
        return OrderStatus.error;
    }
  }

  final String label;
  final String value;
}

class Order extends Model {
  ModelOrId<Supplier> supplier;
  ModelOrId<User> user;
  OrderStatus status;
  String remark;
  DateTime timestamp;
  DateTime updatedTimestamp;
  List<OrderItem>? orderItems;

  Order({
    required this.supplier,
    required this.user,
    required this.status,
    required this.remark,
    required this.timestamp,
    required this.updatedTimestamp,
  });

  Order.fromMap(Map<String, dynamic> data):
      supplier = data['supplier'] == null
          ? ModelOrId.id(id: data['supplier_id'])
          : ModelOrId.data(data: Supplier.fromMap(data['supplier'])),
      user = data['created_by'] == null
          ? ModelOrId.id(id: data['user_id'])
          : ModelOrId.data(data: User.fromMap(data['created_by'])),
      status = OrderStatus.fromString(data['status']),
      remark = data['remark'],
      timestamp = DateTime.parse(data['created_at']),
      updatedTimestamp = DateTime.parse(data['updated_at']),
      orderItems = data['order_items'] == null
          ? null
          : (data['order_items'] as List).map((e) => OrderItem.fromMap(e)).toList(),
      super(id: data['id']);
}