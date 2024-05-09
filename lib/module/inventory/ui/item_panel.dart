import 'package:flutter/material.dart';
import 'package:supermarket_management/api/error_response.dart';
import 'package:supermarket_management/module/inventory/action/inventory.action.dart';
import 'package:supermarket_management/module/inventory/ui/create_product_page.dart';
import 'package:supermarket_management/module/inventory/ui/product_details_page.dart';
import 'package:supermarket_management/model/entity/item_meta.dart';

class ItemPanel extends StatefulWidget {
  const ItemPanel({super.key});

  @override
  State<ItemPanel> createState() => _ItemPanelState();
}

class _ItemPanelState extends State<ItemPanel> {
  List<ItemMeta>? items;

  Future fetch() async {
    InventoryAction.of(context).fetchItems().then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
        
        return;
      }
      
      setState(() {
        items = (response['data'] as List).map((e) => ItemMeta.fromMap(e)).toList();
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
      body: items != null ? ListView(
        children: items!.map((e) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.inventory),
            ),
            title: Text(e.name),
            subtitle: Text(e.stockKeepingUnit),
            trailing: Text((e.stockNumber != null && e.stockNumber! > 0) ? e.stockNumber.toString() : '-'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ProductDetailsPage(id: e.id!))
              );
            },
          );
        }).toList(),
      ) : Container(),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CreateProductPage())
            ).then((_) {
              setState(() {
                items = null;
              });
              fetch();
            });
          }
      ),
    );
  }
}