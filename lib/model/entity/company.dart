import 'package:supermarket_management/model/model.dart';
import 'package:supermarket_management/model/model_or_id.dart';
import 'package:supermarket_management/model/entity/address.dart';

class Company extends Model {
  Company({super.id, super.uuid, required this.address, required this.name, required this.status});

  Company.fromMap(Map<String, dynamic> data)
      : name = data['name'],
        status = data['status'],
        address = data['address'] is int
            ? ModelOrId.id(id: data['address'])
            : ModelOrId.data(
            data: data['address'], id: data['address']['id']),
        super(id: data['id']);

  ModelOrId<Address> address;
  String name;
  String status;
}