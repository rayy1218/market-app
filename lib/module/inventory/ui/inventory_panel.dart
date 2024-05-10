import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:supermarket_management/api/error_response.dart';
import 'package:supermarket_management/model/entity/stock_location.dart';
import 'package:supermarket_management/module/inventory/action/inventory.action.dart';
import 'package:supermarket_management/module/inventory/ui/product_details_page.dart';
import 'package:supermarket_management/module/inventory/ui/split_stock_page.dart';
import 'package:supermarket_management/module/inventory/ui/stock_in_page.dart';
import 'package:supermarket_management/module/inventory/ui/stock_transfer_page.dart';
import 'package:supermarket_management/module/inventory/ui/create_location_page.dart';

class InventoryPanel extends StatefulWidget {
  const InventoryPanel({super.key});

  @override
  State<InventoryPanel> createState() => _InventoryPanelState();
}

class _InventoryPanelState extends State<InventoryPanel> {
  List<StockLocation>? locations;

  void fetch() async {
    InventoryAction.of(context).fetchInventory().then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        locations = (response['data'] as List).map((item) => StockLocation.fromMap(item)).toList();
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

  List<Widget> recursively({int layer = 0, required StockLocation entity}) {
    if (entity.children == null) {
      return [
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(16.0 + 16.0 * layer, 0, 0, 0),
          title: Text(entity.name),
        ),
        ...entity.stocks!.map((stock) => ListTile(
          contentPadding: EdgeInsets.fromLTRB(16.0 + 16.0 * layer, 0, 16, 0),
          leading: const CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.inventory),
          ),
          title: Text(stock.itemMeta.data!.name),
          trailing: Text(stock.quantity.toString()),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProductDetailsPage(id: stock.itemMeta.id))
            );
          },
        )),
      ];
    }
    else {
      return [
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(16.0 + 16.0 * layer, 0, 0, 0),
          title: Text(entity.name),
        ),
        ...entity.stocks!.map((stock) => ListTile(
          contentPadding: EdgeInsets.fromLTRB(16.0 + 16.0 * layer, 0, 16, 0),
          leading: const CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.inventory),
          ),
          title: Text(stock.itemMeta.data!.name),
          trailing: Text(stock.quantity.toString()),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProductDetailsPage(id: stock.itemMeta.id))
            ).then((_) {
              setState(() {
                locations = null;
              });

              fetch();
            });
          },
        )),
        ...entity.children!.map((e) => recursively(entity: e, layer: layer + 1)).toList().flattened
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: locations != null ? locations!.map((e) => recursively(entity: e)).flattened.toList() : [],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        spacing: 8,

        children: [
          SpeedDialChild(
              label: "Create Stock Location",
              child: const Icon(Icons.warehouse),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const CreateLocationPage())
                ).then((_) {
                  setState(() {
                    locations = null;
                  });

                  fetch();
                });
              }
          ),
          SpeedDialChild(
              label: "Stock In",
              child: const Icon(Icons.login),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const StockInPage())
                ).then((_) {
                  setState(() {
                    locations = null;
                  });

                  fetch();
                });
              }
          ),
          SpeedDialChild(
              label: "Move Stock Item",
              child: const Icon(Icons.move_down),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const StockTransferPage())
                ).then((_) {
                  setState(() {
                    locations = null;
                  });

                  fetch();
                });
              }
          ),
          SpeedDialChild(
              label: "Stock Splitting",
              child: const Icon(Icons.call_split),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SplitStockPage())
                ).then((_) {
                  setState(() {
                    locations = null;
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