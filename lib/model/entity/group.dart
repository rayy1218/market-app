import 'package:supermarket_management/model/model.dart';
import 'package:supermarket_management/model/model_or_id.dart';

import 'company.dart';

class Group extends Model {
  Group({super.id, super.uuid, required this.company, required this.name});

  Group.fromMap(Map<String, dynamic> data):
        name = data['name'],
        company = (data['company'] != null || data['company_id'] != null)
            ? (data['company'] != null)
              ? ModelOrId.data(data: data['company'], id: data['id'])
              : ModelOrId.id(id: data['company_id'])
            : null,
        super(id: data['id']);

  ModelOrId<Company>? company;
  String name;
}