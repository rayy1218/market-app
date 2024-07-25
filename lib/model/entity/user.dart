import 'package:MarketEase/model/entity/company.dart';
import 'package:MarketEase/model/entity/group.dart';
import 'package:MarketEase/model/model.dart';
import 'package:MarketEase/model/model_or_id.dart';

class User extends Model {
  User({
    super.id,
    super.uuid,
    required this.group,
    required this.company,
    required this.username,
    required this.email,
    required this.status,
    required this.joinedAt,
    this.lastName,
    this.firstName,
  });

  User.fromMap(Map<String, dynamic> data):
        username = data['username'],
        email = data['email'],
        lastName = data['last_name'],
        firstName = data['first_name'],
        status = data['status'],
        joinedAt = DateTime.parse(data['created_at']),
        group = data['group_id'] != null && data['group'] == null ? ModelOrId.id(id: data['group_id']) : data['group'] is int
            ? ModelOrId.id(id: data['group'])
            : ModelOrId.data(data: Group.fromMap(data['group']), id: data['group']['id']),
        company = (data['company'] != null)
            ? ModelOrId.data(data: data['company'], id: data['id'])
            : ModelOrId.id(id: data['company_id']),
        super(id: data['id']);

  ModelOrId<Group> group;
  ModelOrId<Company> company;
  String username;
  String email;
  String status;
  DateTime joinedAt;
  String? lastName;
  String? firstName;
}