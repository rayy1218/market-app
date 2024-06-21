import 'package:supermarket_management/model/entity/customer.dart';
import 'package:supermarket_management/model/entity/user.dart';
import 'package:supermarket_management/model/model.dart';
import 'package:supermarket_management/model/model_or_id.dart';

class Checkout extends Model {
  Checkout({
    super.id,
    super.uuid,
    required this.customer,
    required this.user,
    required this.amount,
    required this.timestamp,
    required this.paymentMethod,
    required this.referenceCode,
  });

  ModelOrId<Customer> customer;
  ModelOrId<User> user;
  double amount;
  DateTime timestamp;
  String paymentMethod;
  String referenceCode;

  Checkout.fromMap(Map<String, dynamic> data):
      customer = data['customer'] != null
          ? ModelOrId.data(data: Customer.fromMap(data['customer']))
          : ModelOrId.id(id: data['customer_id']),
      user = data['user'] != null
          ? ModelOrId.data(data: User.fromMap(data['user']))
          : ModelOrId.id(id: data['user_id']),
      amount = data['amount'] != null ? double.parse(data['amount'].toString()) : 0,
      timestamp = DateTime.parse(data['created_at']),
      paymentMethod = data['payment_method'],
      referenceCode = data['reference_code'],
      super(id: data['id']);
}