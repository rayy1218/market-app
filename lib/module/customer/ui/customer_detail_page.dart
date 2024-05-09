import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supermarket_management/dumb.dart';
import 'package:supermarket_management/model/model.dart';

class CustomerDetailPage extends StatefulWidget {
  int customerId;

  CustomerDetailPage({super.key, required this.customerId});

  @override
  State<CustomerDetailPage> createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  late Customer customer;
  late List activities;

  @override
  Widget build(BuildContext context) {
    customer = DumbData.customers[widget.customerId];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.inventory),
                  ),
                  Container(width: 24),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${customer.name}'),
                      Text("Email Address: ${customer.email ?? '-'}"),
                      Text("Phone Number: ${customer.phoneNumber ?? '-'}"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(indent: 8, endIndent: 8),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView(
                  children: activities.map((e) => Card(
                    child: ListTile(
                      title: Text(e.type.label),
                      subtitle: Text(DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(e.timestamp)),
                    ),
                  )).toList(),
                ),
              )
          ),
        ],
      ),
    );
  }
}