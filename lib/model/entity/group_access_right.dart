import 'package:supermarket_management/model/model.dart';

class GroupAccessRight extends Model {
  GroupAccessRight({super.id, super.uuid, required this.name, required this.label, required this.enabled});

  GroupAccessRight.fromMap(Map<String, dynamic> data):
        name = data['meta']['name'],
        label = data['meta']['label'],
        enabled = data['is_enabled'] == 1,
        super(id: data['meta']['id']);

  String name;
  String label;
  bool enabled;
}