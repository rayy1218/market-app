import 'package:flutter/material.dart';
import 'package:MarketEase/api/error_response.dart';
import 'package:MarketEase/model/entity/customer.dart';
import 'package:MarketEase/module/customer/action/customer.action.dart';

class CustomerDetailPage extends StatefulWidget {
  final int customerId;

  const CustomerDetailPage({super.key, required this.customerId});

  @override
  State<CustomerDetailPage> createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  Customer? customer;

  void fetch() async {
    CustomerAction.of(context).fetchCustomer(id: widget.customerId).then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        customer = Customer.fromMap(response['data']);
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
        title: const Text('Customer Detail'),
      ),
      body: customer != null ? ListView(
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
                    title: Text('Profile'),
                  ),
                  const Divider(indent: 8, endIndent: 8),
                  ListTile(
                    title: const Text('Name'),
                    subtitle: Text(customer!.name),
                  ),
                  ListTile(
                    title: const Text('Phone Number'),
                    subtitle: Text(customer!.phoneNumber),
                  ),
                  ListTile(
                    title: const Text('Email Address'),
                    subtitle: Text(customer!.email),
                  ),
                ],
              ),
            ),
          ),
        ],
      ) : const Center(child: CircularProgressIndicator()),
    );
  }
}