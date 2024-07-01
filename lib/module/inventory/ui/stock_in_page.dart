import 'package:MarketEase/module/inventory/ui/scan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:MarketEase/api/error_response.dart';
import 'package:MarketEase/model/entity/item_meta.dart';
import 'package:MarketEase/model/entity/stock_location.dart';
import 'package:MarketEase/module/inventory/action/inventory.action.dart';

class StockInPage extends StatefulWidget {
  const StockInPage({super.key});

  @override
  State<StockInPage> createState() => _StockInPageState();
}

class _StockInPageState extends State<StockInPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  List<StockLocation>? stockLocations;
  List<ItemMeta>? items;

  void fetch() async {
    InventoryAction.of(context).fetchLocations().then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        stockLocations = (response['data'] as List).map((item) => StockLocation.fromMap(item)).toList();
      });
    });

    InventoryAction.of(context).fetchItems().then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        items = (response['data'] as List).map((item) => ItemMeta.fromMap(item)).toList();
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
        title: const Text('Inventory Stock In'),
      ),
      body: FormBuilder(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              items != null ?
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: FormBuilderDropdown(
                        items: items!.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Product'
                        ),
                        name: 'product',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: const Icon(Icons.barcode_reader),
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ScanPage(
                                  onScanClick: (barcode) {
                                    if (barcode?.rawValue?.toString() != null) {
                                      int result = items!.lastIndexWhere((element) {
                                        return element.universalProductCode == barcode?.rawValue?.toString();
                                      });

                                      if (result == -1) return false;

                                      setState(() {
                                        _formKey.currentState!.value['product'] = result;
                                      });

                                      return true;
                                    }

                                    return false;
                                  }
                              ))
                          );
                        },
                      ),
                    )
                  ],
                ),
              ) : Container(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                child: FormBuilderTextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Quantity'
                  ),
                  name: 'quantity'
                ),
              ),
              stockLocations != null ?
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                child: FormBuilderDropdown(
                  items: stockLocations!.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Location'
                  ),
                  name: 'location'
                ),
              ) : Container(),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          onPressed: () {
            _formKey.currentState?.save();

            final product = _formKey.currentState?.value['product'];
            final quantity = int.parse(_formKey.currentState?.value['quantity']);
            final location = _formKey.currentState?.value['location'];

            InventoryAction.of(context).stockIn(
                product: product, quantity: quantity, location: location
            ).then((response) {
              if (response is ErrorResponse) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response.message))
                );

                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Stock In Successfully'))
              );

              Navigator.of(context).pop();
            });
          },
          child: const Text('Stock In')
        ),
      ],
    );
  }
}