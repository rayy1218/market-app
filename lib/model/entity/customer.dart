import 'package:supermarket_management/model/model.dart';

class Customer extends Model {
  Customer({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.points,
  });

  String name;
  String email;
  String phoneNumber;
  int points;

  Customer.fromMap(Map<String, dynamic> data):
      name = data['name'],
      email = data['email'],
      phoneNumber = data['phone_number'],
      points = data['points'],
      super(id: data['id']);
}