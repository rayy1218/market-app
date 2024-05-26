import 'package:flutter/material.dart';
import 'package:supermarket_management/module/checkout/ui/checkout_page.dart';
import 'package:supermarket_management/module/customer/ui/customer_page.dart';
import 'package:supermarket_management/module/inventory/ui/inventory_page.dart';
import 'package:supermarket_management/module/managerial/ui/managerial_page.dart';
import 'package:supermarket_management/module/shift/ui/shift_page.dart';
import 'package:supermarket_management/module/supply_chain/ui/supply_chain_page.dart';

class OperationPage extends StatefulWidget {
  const OperationPage({super.key});

  @override
  State<OperationPage> createState() => _OperationPageState();
}

class _OperationPageState extends State<OperationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Operations'),
        automaticallyImplyLeading: false,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16.0),
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        crossAxisCount: 2,
        children: [
          GestureDetector(
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
          GestureDetector(
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
          GestureDetector(
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
          GestureDetector(
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
          GestureDetector(
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
          GestureDetector(
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
      ),
    );
  }
}
