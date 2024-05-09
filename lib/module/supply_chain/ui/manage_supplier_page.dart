import 'package:flutter/material.dart';
import 'package:supermarket_management/dumb.dart';
import 'package:supermarket_management/model/model.dart';

class ManageSupplierPage extends StatefulWidget {
  const ManageSupplierPage({super.key});

  @override
  State<ManageSupplierPage> createState() => _ManageSupplierPageState();
}

class _ManageSupplierPageState extends State<ManageSupplierPage> {
  List<Supplier> entries = DumbData.suppliers;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: entries.map((e) => ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.person),
        ),
        title: Text(e.name),
      )).toList(),
    );
  }
}