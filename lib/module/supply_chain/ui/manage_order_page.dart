import 'package:flutter/material.dart';
import 'package:supermarket_management/dumb.dart';
import 'package:intl/intl.dart';
import 'package:supermarket_management/model/model.dart';

class ManageOrderPage extends StatefulWidget {
  const ManageOrderPage({super.key});

  @override
  State<ManageOrderPage> createState() => _ManageOrderPageState();
}

class _ManageOrderPageState extends State<ManageOrderPage> {
  List<Order> entries = DumbData.orders;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: entries.map((e) => ListTile(
        title: Text('${DumbData.suppliers.firstWhere((element) => element.id == e.supplier.id).name} at ${DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(e.timestamp)}'),
        subtitle: Text(e.status.label),
      )).toList(),
    );
  }
}