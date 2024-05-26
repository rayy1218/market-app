import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:supermarket_management/api/error_response.dart';
import 'package:supermarket_management/model/entity/customer.dart';
import 'package:supermarket_management/module/customer/action/customer.action.dart';
import 'package:supermarket_management/module/customer/ui/create_customer_profile_page.dart';
import 'package:supermarket_management/module/customer/ui/customer_detail_page.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  List<Customer>? customers;

  void fetch() async {
    CustomerAction.of(context).fetchCustomers().then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        customers = (response['data'] as List).map((item) => Customer.fromMap(item)).toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer List'),
      ),
      body: customers != null ? ListView(
        children: customers!.map((e) => ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.person),
          ),
          title: Text(e.name),
          subtitle: Text(e.phoneNumber),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CustomerDetailPage(customerId: e.id!))
            );
          },
        )).toList(),
      ) : const Center(child: CircularProgressIndicator()),
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
                ).then((_) {
                  setState(() {
                    customers = null;
                  });

                  fetch();
                });
              }
          ),
        ],
      ),
    );
  }
}