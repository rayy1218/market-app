import 'package:supermarket_management/model/model.dart';

class Address extends Model {
  String? line1, line2, city, state, postcode, country;

  Address({
    super.id,
    super.uuid,
    this.line1,
    this.line2,
    this.city,
    this.state,
    this.postcode,
    this.country
  });

  Address.fromMap(Map<String, dynamic> data):
      line1 = data['line1'],
      line2 = data['line2'],
      city = data['city'],
      state = data['state'],
      postcode = data['zipcode'],
      country = data['country'],
      super(id: data['id']);

  @override
  String toString() {
    return '$line1, $line2, $city, $state $postcode, $country';
  }
}