import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:supermarket_management/module/supply_chain/ui/create_order_page.dart';
import 'package:supermarket_management/module/supply_chain/ui/create_supplier_page.dart';
import 'package:supermarket_management/module/supply_chain/ui/manage_order_page.dart';
import 'package:supermarket_management/module/supply_chain/ui/manage_supplier_page.dart';



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
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        spacing: 8,
        children: [
          SpeedDialChild(
            label: 'Create Order',
            child: const Icon(Icons.local_shipping),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CreateOrderPage())
              );
            }
          ),
          SpeedDialChild(
            label: 'Add Supplier',
            child: const Icon(Icons.people),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CreateSupplierPage())
              );
            }
          )
        ],
      ),
    );
  }
}