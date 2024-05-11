import 'dart:core';
import 'package:collection/collection.dart';
import 'package:supermarket_management/model/entity/company.dart';
import 'package:supermarket_management/model/entity/group.dart';
import 'package:supermarket_management/model/entity/supplier.dart';
import 'package:supermarket_management/model/entity/user.dart';
import 'package:supermarket_management/model/model.dart';
import 'package:supermarket_management/model/model_or_id.dart';
import 'model/entity/address.dart';
import 'model/entity/item_meta.dart';
import 'model/entity/item_source.dart';
import 'model/entity/item_stock_data.dart';
import 'model/entity/order.dart';
import 'model/entity/order_item.dart';
import 'model/entity/stock_location.dart';

class DumbData {
  static List<Company> companies = [
    Company(id: 1,name: 'Super Big Market', status: 'active', address: ModelOrId.data(data: Address(id: 1)))
  ].mapIndexed((i, e) => e..id = i + 1).toList();

  static List<Group> groups = [
    Group(company: ModelOrId.data(data: companies[0]), name: 'Owner'),
    Group(company: ModelOrId.data(data: companies[0]), name: 'Admin'),
    Group(company: ModelOrId.data(data: companies[0]), name: 'Inventory Employee'),
    Group(company: ModelOrId.data(data: companies[0]), name: 'Counter Employee'),
  ].mapIndexed((i, e) => e..id = i + 1).toList();

  static List<User> employees = [
    User(group: ModelOrId.data(data: groups[0]), company: ModelOrId.data(data: companies[0]), username: 'Joe', email: 'joe@mail.com', status: 'active', joinedAt: DateTime.now()),
    User(group: ModelOrId.data(data: groups[1]), company: ModelOrId.data(data: companies[0]), username: 'Ray', email: 'ray@mail.com', status: 'active', joinedAt: DateTime.now()),
    User(group: ModelOrId.data(data: groups[2]), company: ModelOrId.data(data: companies[0]), username: 'Brandon', email: 'brandon@mail.com', status: 'active', joinedAt: DateTime.now()),
    User(group: ModelOrId.data(data: groups[2]), company: ModelOrId.data(data: companies[0]), username: 'May', email: 'may@mail.com', status: 'active', joinedAt: DateTime.now()),
    User(group: ModelOrId.data(data: groups[3]), company: ModelOrId.data(data: companies[0]), username: 'Gauss', email: 'gauss@mail.com', status: 'active', joinedAt: DateTime.now()),
  ].mapIndexed((i, e) => e..id = i + 1).toList();

  static List<Supplier> suppliers = [
    Supplier(address: Address(id: 1), name: 'Ee Ruo Xiah', phone: '+60 06767-3086', email: 'wee@yahoo.com'),
    Supplier(address: Address(id: 1), name: 'Muhammet Haji Syuqeri Maswari', phone: '+60 3523598', email: 'sambanthan.rena@hotmail.com')
  ].mapIndexed((i, e) => e..id = i + 1).toList();

  static List<ItemMeta> itemMetas = [
    ItemMeta(company: ModelOrId.data(data: companies[0]), name: 'Spaghetti 250g', stockKeepingUnit: 'MX-I-2', universalProductCode: '23134123421'),
    ItemMeta(company: ModelOrId.data(data: companies[0]), name: 'Bolognese Sauce 500g', stockKeepingUnit: 'MX-I-8', universalProductCode: '215723248712'),
    ItemMeta(company: ModelOrId.data(data: companies[0]), name: 'Onion 1kg', stockKeepingUnit: 'BF-2', universalProductCode: '237212412492'),
    ItemMeta(company: ModelOrId.data(data: companies[0]), name: 'Salt 500g', stockKeepingUnit: 'BF-1', universalProductCode: '125623452336'),
  ].mapIndexed((i, e) => e..id = i + 1).toList();

  static List<StockLocation> locations = [
    StockLocation(name: 'Warehouse', parent: null),
    StockLocation(name: 'Room A', parent: ModelOrId.id(id: 1)),
    StockLocation(name: 'Room B', parent: ModelOrId.id(id: 1)),
    StockLocation(name: 'Room C', parent: ModelOrId.id(id: 1)),
    StockLocation(name: 'Shelve', parent: null),
    StockLocation(name: 'Processed Food Row', parent: ModelOrId.id(id: 5)),
    StockLocation(name: 'Ingredient Row', parent: ModelOrId.id(id: 5)),
    StockLocation(name: 'Vegetable Area', parent: ModelOrId.id(id: 5)),
    StockLocation(name: 'Left Side', parent: ModelOrId.id(id: 8)),
    StockLocation(name: 'Right Side', parent: ModelOrId.id(id: 8)),
    StockLocation(name: 'Centre', parent: ModelOrId.id(id: 8)),
  ].mapIndexed((i, e) => e..id = i + 1).toList();

  static List<ItemStockData> itemStocksData = [
    ItemStockData(itemMeta: ModelOrId.data(data: itemMetas[0]), stockLocation: ModelOrId.data(data: locations[2]), quantity: 50),
    ItemStockData(itemMeta: ModelOrId.data(data: itemMetas[0]), stockLocation: ModelOrId.data(data: locations[5]), quantity: 23),
    ItemStockData(itemMeta: ModelOrId.data(data: itemMetas[1]), stockLocation: ModelOrId.data(data: locations[1]), quantity: 100),
    ItemStockData(itemMeta: ModelOrId.data(data: itemMetas[1]), stockLocation: ModelOrId.data(data: locations[5]), quantity: 12),
    ItemStockData(itemMeta: ModelOrId.data(data: itemMetas[2]), stockLocation: ModelOrId.data(data: locations[9]), quantity: 12),
  ].mapIndexed((i, e) => e..id = i + 1).toList();

  static List<ItemSource> itemSources = [
    ItemSource(supplier: ModelOrId.data(data: suppliers[0]), itemMeta: ModelOrId.data(data: itemMetas[0]), unitPrice: 3.4, minOrderQuantity: 100, estimatedLeadTime: 72),
    ItemSource(supplier: ModelOrId.data(data: suppliers[0]), itemMeta: ModelOrId.data(data: itemMetas[1]), unitPrice: 13.99, minOrderQuantity: 100, estimatedLeadTime: 72),
    ItemSource(supplier: ModelOrId.data(data: suppliers[1]), itemMeta: ModelOrId.data(data: itemMetas[2]), unitPrice: 3, minOrderQuantity: 100, estimatedLeadTime: 72),
    ItemSource(supplier: ModelOrId.data(data: suppliers[1]), itemMeta: ModelOrId.data(data: itemMetas[3]), unitPrice: 5.99, minOrderQuantity: 100, estimatedLeadTime: 48),
  ].mapIndexed((i, e) => e..id = i + 1).toList();

  static List<Order> orders = [
    Order(supplier: ModelOrId.data(data: suppliers[0]), user: ModelOrId.data(data: employees[0]), status: OrderStatus.created, remark: '', timestamp: DateTime.now(), updatedTimestamp: DateTime.now()),
    Order(supplier: ModelOrId.data(data: suppliers[1]), user: ModelOrId.data(data: employees[0]), status: OrderStatus.completed, remark: '', timestamp: DateTime.now(), updatedTimestamp: DateTime.now()),
    Order(supplier: ModelOrId.data(data: suppliers[0]), user: ModelOrId.data(data: employees[0]), status: OrderStatus.delivering, remark: '', timestamp: DateTime.now(), updatedTimestamp: DateTime.now()),
  ].mapIndexed((i, e) => e..id = i + 1).toList();

  static List<OrderItem> orderItems = [
    OrderItem(order: ModelOrId.data(data: orders[0]), itemSource: ModelOrId.data(data: itemSources[0]), quantity: 200),
    OrderItem(order: ModelOrId.data(data: orders[0]), itemSource: ModelOrId.data(data: itemSources[1]), quantity: 50),
    OrderItem(order: ModelOrId.data(data: orders[1]), itemSource: ModelOrId.data(data: itemSources[2]), quantity: 300),
    OrderItem(order: ModelOrId.data(data: orders[2]), itemSource: ModelOrId.data(data: itemSources[1]), quantity: 500),
  ].mapIndexed((i, e) => e..id = i + 1).toList();

  static List<Customer> customers = [
    Customer(company: ModelOrId.data(data: companies[0]), name: 'Tom', email: 'tom@mail.com', phoneNumber: '+60112123123'),
    Customer(company: ModelOrId.data(data: companies[0]), name: 'Kelly', email: 'kelly@mail.com', phoneNumber: '+601125643'),
    Customer(company: ModelOrId.data(data: companies[0]), name: 'Bob', email: 'bob@mail.com', phoneNumber: '+60112378'),
  ].mapIndexed((i, e) => e..id = i + 1).toList();
}

