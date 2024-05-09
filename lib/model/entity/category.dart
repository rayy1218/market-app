import 'package:supermarket_management/model/model.dart';

class Category extends Model {
  String name;

  Category({required this.name});

  Category.fromMap(Map<String, dynamic> data):
        name = data['name'],
        super(id: data['id']);
}