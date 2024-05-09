import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:supermarket_management/module/inventory/ui/create_location_page.dart';
import 'package:supermarket_management/module/inventory/ui/create_product_page.dart';
import 'package:supermarket_management/module/inventory/ui/inventory_panel.dart';
import 'package:supermarket_management/module/inventory/ui/item_panel.dart';
import 'package:supermarket_management/module/inventory/ui/split_stock_page.dart';
import 'package:supermarket_management/module/inventory/ui/stock_in_page.dart';
import 'package:supermarket_management/module/inventory/ui/stock_transfer_page.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: [
        const InventoryPanel(),
        const ItemPanel(),
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
              icon: Icon(Icons.badge),
              label: 'Inventory'
          ),
          NavigationDestination(
              icon: Icon(Icons.groups),
              label: 'Item Database'
          ),
        ],
      ),
    );
  }
}