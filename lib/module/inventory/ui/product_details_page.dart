import 'package:flutter/material.dart';
import 'package:supermarket_management/api/error_response.dart';
import 'package:supermarket_management/dumb.dart';
import 'package:supermarket_management/model/entity/item_meta.dart';
import 'package:supermarket_management/model/model.dart';
import 'package:supermarket_management/module/inventory/action/inventory.action.dart';
import 'package:supermarket_management/module/inventory/ui/item_detail_panel.dart';
import 'package:supermarket_management/module/inventory/ui/item_sales_panel.dart';
import 'package:supermarket_management/module/inventory/ui/item_stock_panel.dart';
import 'package:supermarket_management/module/inventory/ui/item_supply_panel.dart';

import '../../../model/entity/item_stock_data.dart';

class ProductDetailsPage extends StatefulWidget {
  int id;

  ProductDetailsPage({super.key, required this.id});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int currentPageIndex = 0;

  ItemMeta? item;

  void fetch() async {
    InventoryAction.of(context).fetchItem(id: widget.id).then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        item = ItemMeta.fromMap(response['data']);
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
        title: const Text('Item Detail'),
      ),
      body: item != null ? [
        ItemStockPanel(itemMeta: item!),
        ItemDetailPanel(itemMeta: item!),
        ItemSalesPanel(itemMeta: item!),
        ItemSupplyPanel(itemMeta: item!),
      ][currentPageIndex] : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.inventory),
              label: 'Stock'
          ),
          NavigationDestination(
              icon: Icon(Icons.list),
              label: 'Detail'
          ),
          NavigationDestination(
              icon: Icon(Icons.shopping_cart),
              label: 'Sales'
          ),
          NavigationDestination(
              icon: Icon(Icons.local_shipping),
              label: 'Supply'
          ),
        ],
      ),
    );
  }
}