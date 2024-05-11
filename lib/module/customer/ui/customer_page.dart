import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:supermarket_management/dumb.dart';
import 'package:supermarket_management/model/model.dart';
import 'package:supermarket_management/module/customer/ui/create_customer_profile_page.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  late List<Customer> customers = DumbData.customers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer List'),
      ),
      body: ListView(
        children: customers.map((e) => ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.person),
          ),
          title: Text(e.name),
          subtitle: Text(e.phoneNumber),
          onTap: () {
            // Navigator.of(context).push(
            //     MaterialPageRoute(builder: (context) => CustomerDetailPage(customerId: e.id!))
            // );
          },
        )).toList(),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        spacing: 8,
        children: [
          SpeedDialChild(
              label: 'Add Customer',
              child: const Icon(Icons.add_box),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const CreateCustomerProfilePage())
                );
              }
          ),
        ],
      ),
    );
  }
}