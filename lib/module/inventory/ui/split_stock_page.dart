import 'package:MarketEase/module/inventory/ui/scan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:MarketEase/api/error_response.dart';
import 'package:MarketEase/model/entity/item_meta.dart';
import 'package:MarketEase/model/entity/item_stock_data.dart';
import 'package:MarketEase/model/entity/stock_location.dart';
import 'package:MarketEase/module/inventory/action/inventory.action.dart';

class SplitStockPage extends StatefulWidget {
  const SplitStockPage({super.key});

  @override
  State<SplitStockPage> createState() => _SplitStockPageState();
}

class _SplitStockPageState extends State<SplitStockPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  List<StockLocation>? stockLocations;
  List<ItemMeta>? items;
  List<ItemStockData>? itemStockDataOnLocation;

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
        title: const Text('Stock Splitting'),
      ),
      body: FormBuilder(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: FormBuilderDropdown(
                decoration: const InputDecoration(
                  labelText: 'Location of splitting item',
                  border: OutlineInputBorder(),
                ),
                name: 'location',
                onChanged: (value) async {
                  if (value != null) {
                    setState(() {
                      itemStockDataOnLocation = null;
                    });

                    InventoryAction.of(context).fetchItemsOnLocation(locationId: value).then((response) {
                      if (response is ErrorResponse) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(response.message))
                        );

                        return;
                      }

                      setState(() {
                        itemStockDataOnLocation = (response['data'] as List).map((item) => ItemStockData.fromMap(item)).toList();
                      });
                    });
                  }
                },
                items: stockLocations == null ? [] : stockLocations!.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: Row(
                children: [
                  Flexible(
                    child: FormBuilderDropdown(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Item to split',
                      ),
                      name: 'item_stock_data',
                      items: itemStockDataOnLocation == null ? [] : itemStockDataOnLocation!.map((e) => DropdownMenuItem(value: e.id, child: Text('${e.itemMeta.data!.name} (${e.quantity})'))).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ScanPage(
                                  onScanClick: (barcode) {
                                    if (barcode?.rawValue?.toString() != null) {
                                      int result = itemStockDataOnLocation!.lastIndexWhere((element) {
                                        return element.itemMeta.data!.universalProductCode == barcode?.rawValue?.toString();
                                      });

                                      if (result == -1) return false;

                                      setState(() {
                                        _formKey.currentState!.value['item_stock_data'] = result;
                                      });

                                      return true;
                                    }

                                    return false;
                                  }
                              ))
                          );
                        },
                        icon: const Icon(Icons.barcode_reader)
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: FormBuilderTextField(
                decoration: const InputDecoration(
                  labelText: 'Quantity to split',
                  border: OutlineInputBorder(),
                ),
                name: 'quantity',
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16.0),
              child: FormBuilderDropdown(
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                name: 'output_location',
                items: stockLocations == null ? [] : stockLocations!.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: FormBuilderDropdown(
                      items: items == null ? [] : items!.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Product'
                      ),
                      name: 'output_item',
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
                                    _formKey.currentState!.value['output_item'] = result;
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
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: FormBuilderTextField(
                decoration: const InputDecoration(
                  labelText: 'Quantity for each item split',
                  border: OutlineInputBorder(),
                ),
                name: 'output_quantity',
              ),
            ),
          ],
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

              final itemStockData = _formKey.currentState?.value['item_stock_data'];
              final quantity = int.parse(_formKey.currentState?.value['quantity']);
              final outputLocation = _formKey.currentState?.value['output_location'];
              final outputItem = _formKey.currentState?.value['output_item'];
              final outputQuantity = int.parse(_formKey.currentState?.value['output_quantity']);

              InventoryAction.of(context).stockSplit(
                  itemStockData: itemStockData, quantity: quantity,
                  outputLocation: outputLocation, outputItem: outputItem,
                  outputQuantity: outputQuantity
              ).then((response) {
                if (response is ErrorResponse) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response.message))
                  );

                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Stock Split Successfully'))
                );

                Navigator.of(context).pop();
              });
            },
            child: const Text('Split Item')
        ),
      ],
    );
  }
}