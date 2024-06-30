import 'package:MarketEase/model/model.dart';

class Brand extends Model {
  String name;

  Brand({required this.name});

  Brand.fromMap(Map<String, dynamic> data):
    name = data['name'], super(id: data['id']);
}