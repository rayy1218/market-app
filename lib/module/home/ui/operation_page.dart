import 'package:MarketEase/main.dart';
import 'package:flutter/material.dart';
import 'package:MarketEase/module/checkout/ui/checkout_page.dart';
import 'package:MarketEase/module/customer/ui/customer_page.dart';
import 'package:MarketEase/module/inventory/ui/inventory_page.dart';
import 'package:MarketEase/module/managerial/ui/managerial_page.dart';
import 'package:MarketEase/module/shift/ui/shift_page.dart';
import 'package:MarketEase/module/supply_chain/ui/supply_chain_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OperationPage extends StatefulWidget {
  const OperationPage({super.key});

  @override
  State<OperationPage> createState() => _OperationPageState();
}

class _OperationPageState extends State<OperationPage> {
  Map? enable;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = BlocProvider.of<AuthenticationBloc>(context);

      setState(() {
        enable = {
          'managerial': (bloc.state as LogonState).accessRights!.any((element) => element.name == 'managerial setting'),
          'shift': (bloc.state as LogonState).accessRights!.any((element) => element.name == 'shift edit'),
          'supply': (bloc.state as LogonState).accessRights!.any((element) => element.name == 'supply supplier view'),
          'inventory': (bloc.state as LogonState).accessRights!.any((element) => element.name == 'inventory view'),
          'customer': (bloc.state as LogonState).accessRights!.any((element) => element.name == 'sales customer view'),
          'checkout': (bloc.state as LogonState).accessRights!.any((element) => element.name == 'sales checkout')
        };
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Operations'),
        automaticallyImplyLeading: false,
      ),
      body: enable != null ? GridView.count(
        padding: const EdgeInsets.all(16.0),
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        crossAxisCount: 2,
        children: [
          if (enable!['managerial']) GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ManagerialPage())
              );
            },
            child: const Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people, size: 80),
                  Text('Managerial'),
                ],
              ),
            ),
          ),
          if (enable!['shift']) GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ShiftPage())
              );
            },
            child: const Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Icon(Icons.calendar_today, size: 80),
                  ),
                  Text('Shift'),
                ],
              ),
            ),
          ),
          if (enable!['supply']) GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SupplyChainPage())
              );
            },
            child: const Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_shipping, size: 80),
                  Text('Supply Chain'),
                ],
              ),
            ),
          ),
          if (enable!['inventory']) GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const InventoryPage())
              );
            },
            child: const Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory, size: 80),
                  Text('Inventory'),
                ],
              ),
            ),
          ),
          if (enable!['customer']) GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CustomerPage())
              );
            },
            child: const Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.loyalty, size: 80),
                  Text('Customer'),
                ],
              ),
            ),
          ),
          if (enable!['checkout']) GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CheckoutPage())
              );
            },
            child: const Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart, size: 80),
                  Text('Checkout'),
                ],
              ),
            ),
          ),
        ],
      ) : const Center(child: CircularProgressIndicator()),
    );
  }
}
