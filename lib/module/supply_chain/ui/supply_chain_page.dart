import 'package:flutter/material.dart';
import 'package:MarketEase/module/supply_chain/ui/manage_order_page.dart';
import 'package:MarketEase/module/supply_chain/ui/manage_supplier_page.dart';

class SupplyChainPage extends StatefulWidget {
  const SupplyChainPage({super.key});

  @override
  State<SupplyChainPage> createState() => _SupplyChainPageState();
}

class _SupplyChainPageState extends State<SupplyChainPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Supply Chain'),
      ),
      body: [
        const ManageOrderPage(),
        const ManageSupplierPage(),
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.local_shipping),
              label: 'Order'
          ),
          NavigationDestination(
              icon: Icon(Icons.groups),
              label: 'Supplier'
          ),
        ],
      ),
    );
  }
}