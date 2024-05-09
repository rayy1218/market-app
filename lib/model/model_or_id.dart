import 'package:supermarket_management/model/model.dart';

class ModelOrId<T> {
  T? data;
  int id;
  
  dynamic get() {
    return data ?? id;
  }

  ModelOrId.id({required this.id, this.data});

  ModelOrId.data({required this.data, this.id = -1}) {
    if (id == -1) {
      this.id = (this.data as Model).id!;
    }
  }

  static ModelOrId? fromMap(String name, Map<String, dynamic> data) {
    if (data[name] != null) {
      return ModelOrId.data(data: data['name'], id: data['id']);
    }
    else if (data['${name}_id'] != null) {
      return ModelOrId.id(id: data['${name}_id']);
    }
    else {
      return null;
    }
  }
}
