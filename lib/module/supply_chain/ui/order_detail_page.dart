import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:MarketEase/api/error_response.dart';
import 'package:MarketEase/helper.dart';
import 'package:MarketEase/model/entity/order.dart';
import 'package:MarketEase/module/supply_chain/action/supply.action.dart';

class OrderDetailPage extends StatefulWidget {
  final int id;
  const OrderDetailPage({super.key, required this.id});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  Order? entry;

  void fetch() async {
    SupplyAction.of(context).fetchOrder(id: widget.id).then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        entry = Order.fromMap(response['data']);
      });
    });
  }

  void refresh() {
    setState(() {
      entry = null;
    });

    fetch();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetch();
    });
  }

  void onStatusEditClick() async {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        final formKey = GlobalKey<FormBuilderState>();

        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: FormBuilder(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormBuilderDropdown(
                    name: 'status',
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: entry!.status.value,
                    items: [
                      OrderStatus.created, OrderStatus.pending,
                      OrderStatus.confirmed, OrderStatus.delivering,
                      OrderStatus.completed, OrderStatus.canceled
                    ].map((e) => DropdownMenuItem(
                        value: e.value,
                        child: Text(e.label))
                    ).toList()
                )
              ],
            )
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No', style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                formKey.currentState?.save();
                onConfirmStatusEditClick(formKey.currentState!.value['status']);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void onConfirmStatusEditClick(String status) {
    SupplyAction.of(context).setOrderStatus(id: entry!.id, status: status).then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        entry!.status = OrderStatus.fromString(response['new_status']);
        entry!.updatedTimestamp = DateTime.parse(response['timestamp']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: entry != null ? ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text('Supplier'),
                  ),
                  const Divider(indent: 8, endIndent: 8),
                  ListTile(
                    title: const Text('Name'),
                    subtitle: Text(entry!.supplier.data!.name),
                  ),
                  ListTile(
                    title: const Text('Phone Number'),
                    subtitle: Text(entry!.supplier.data!.phone),
                  ),
                  ListTile(
                    title: const Text('Email Address'),
                    subtitle: Text(entry!.supplier.data!.email),
                  ),
                  ListTile(
                    title: const Text('Location Address'),
                    subtitle: Text(entry!.supplier.data!.address.toString()),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.list_alt),
                    ),
                    title: Text('Order'),
                  ),
                  const Divider(indent: 8, endIndent: 8),
                  ListTile(
                    title: const Text('Created At'),
                    subtitle: Text(DateFormat('MMM d, y HH:mm').format(entry!.timestamp)),
                  ),
                  ListTile(
                    title: const Text('Maximum Estimated Lead Time'),
                    subtitle: Text(entry!.orderItems!.map((e) => e.itemSource.data!.estimatedLeadTime).reduce(max).toString()),
                  ),
                  ListTile(
                    title: const Text('Status'),
                    subtitle: Text(entry!.status.label),
                    trailing: entry!.status != OrderStatus.completed ? IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        onStatusEditClick();
                      },
                    ) : IconButton(
                      icon: const Icon(Icons.inventory),
                      onPressed: () async {
                        onStatusEditClick();
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Updated At'),
                    subtitle: Text(DateFormat('MMM d, y HH:mm').format(entry!.updatedTimestamp)),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.inventory),
                    ),
                    title: Text('Item'),
                  ),
                  const Divider(indent: 8, endIndent: 8),
                  ...entry!.orderItems!.map((e) => ListTile(
                    title: Text('${e.itemSource.data!.itemMeta.data!.name} (${e.itemSource.data!.itemMeta.data!.brand!.data!.name})'),
                    subtitle: Text('${Helper.getCurrencyString(e.itemSource.data!.unitPrice)} per unit'),
                    trailing: Text('${e.quantity} unit(s)'),
                  )),
                ],
              ),
            ),
          ),
        ],
      ) : const Center(child: CircularProgressIndicator()),
    );
  }
}