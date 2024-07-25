import 'package:MarketEase/module/inventory/ui/scan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:MarketEase/api/error_response.dart';
import 'package:MarketEase/model/entity/item_stock_data.dart';
import 'package:MarketEase/model/entity/stock_location.dart';
import 'package:MarketEase/module/inventory/action/inventory.action.dart';

class StockTransferPage extends StatefulWidget {
  const StockTransferPage({super.key});

  @override
  State<StockTransferPage> createState() => _StockTransferPageState();
}

class _StockTransferPageState extends State<StockTransferPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  List<StockLocation>? stockLocations;
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
        title: const Text('Stock Transfer'),
      ),
      body: FormBuilder(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: FormBuilderDropdown(
                validator: (value) {
                  if (value == null) {
                    return 'Required';
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Location to transfer from',
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
                      validator: (value) {
                        if (value == null) {
                          return 'Required';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Item to transfer',
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
                                        _formKey.currentState?.fields['item_stock_data']?.didChange(result);
                                      });

                                      return true;
                                    }

                                    return false;
                                  }
                              ))
                          );
                        },
                        icon: const Icon(Icons.qr_code)
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16.0),
              child: FormBuilderDropdown(
                validator: (value) {
                  if (value == null) {
                    return 'Required';
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                name: 'new_location',
                items: stockLocations == null ? [] : stockLocations!.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: FormBuilderTextField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                name: 'quantity',
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
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;
            _formKey.currentState?.save();

            final itemStockData = _formKey.currentState?.value['item_stock_data'];
            final quantity = int.parse(_formKey.currentState?.value['quantity']);
            final location = _formKey.currentState?.value['new_location'];

            InventoryAction.of(context).stockTransfer(
              itemStockData: itemStockData, quantity: quantity, location: location
            ).then((response) {
              if (response is ErrorResponse) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response.message))
                );

                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Stock Transfer Successfully'))
              );

              Navigator.of(context).pop();
            });
          },
          child: const Text('Transfer Item')
        ),
      ],
    );
  }
}