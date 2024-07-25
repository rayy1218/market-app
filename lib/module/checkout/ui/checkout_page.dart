import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:MarketEase/api/error_response.dart';
import 'package:MarketEase/model/entity/customer.dart';
import 'package:MarketEase/model/entity/item_meta.dart';
import 'package:MarketEase/module/checkout/action/checkout_action.dart';
import 'package:MarketEase/module/customer/action/customer.action.dart';
import 'package:MarketEase/module/inventory/action/inventory.action.dart';

class CheckoutQueue {
  ItemMeta item;
  int quantity;

  CheckoutQueue({required this.item, required this.quantity});
}

class CheckoutPage extends StatefulWidget {
  
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int step = 0;

  List<ItemMeta>? itemDatabase;
  List<Customer>? customerDatabase;

  List<CheckoutQueue> items = [];
  int? customerId;

  void fetch() async {
    CustomerAction.of(context).fetchCustomers().then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        customerDatabase = (response['data'] as List).map((item) => Customer.fromMap(item)).toList();
      });
    });

    InventoryAction.of(context).fetchItems().then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );

        return;
      }

      setState(() {
        itemDatabase = (response['data'] as List).map((e) => ItemMeta.fromMap(e)).toList();
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

  formOnStep() {
    switch (step) {
      case 0:
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
          children: [
            const Padding(padding: EdgeInsets.all(16)),
            FormBuilderDropdown(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Customer'
              ),
              name: 'customer',
              onChanged: (value) {
                setState(() {
                  customerId = (value as int?)!;
                });
              },
              initialValue: null,
              items: [
                const DropdownMenuItem(value: null, child: Text('Not Assigned')),
                ...customerDatabase == null
                    ? []
                    : customerDatabase!.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList()
              ],
            ),
          ],
        );

      case 1:
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Scanning'),
                  Tab(text: 'Items'),
                ],
              ),
              actions: [
                ...itemDatabase != null ? [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AddCheckoutItemPage(items: itemDatabase!, onAdd: (ItemMeta item) {
                        final checkout = items.firstWhereOrNull((element) => element.item.id == item.id);
                        if (checkout == null) {
                          setState(() {
                            items.add(CheckoutQueue(item: item, quantity: 1));
                          });
                        }
                        else {
                          setState(() {
                            checkout.quantity += 1;
                          });
                        }
                      }))
                    );
                  },
                  icon: const Icon(Icons.add)
                )] : [],
              ],
            ),
            body: TabBarView(
              children: [
                BarcodeScanner(
                  onScanClick: (Barcode? barcode) {
                    if (barcode?.rawValue?.toString() != null) {
                      final item = itemDatabase!.firstWhere((element) => element.universalProductCode == barcode!.rawValue!.toString());
                      final checkout = items.firstWhereOrNull((element) => element.item.universalProductCode == barcode!.rawValue!.toString());
                      if (checkout == null) {
                        setState(() {
                          items.add(CheckoutQueue(item: item, quantity: 1));
                        });
                      }
                      else {
                        setState(() {
                          checkout.quantity += 1;
                        });
                      }

                      return true;
                    }
                    
                    return false;
                  },
                ),
                ListView(
                  children: [
                    ...items.map((e) => ListTile(
                      title: Text('${e.item.name} ${e.item.brand != null ? "(${e.item.brand!.data!.name})" : ""}'),
                      subtitle: Text('\$${e.item.saleData!.price.toStringAsFixed(2)} per unit'),
                      trailing: Text('${e.quantity} unit(s)'),
                    )),
                  ],
                )
              ],
            ),
          ),
        );
      case 2:
        final Customer? customer = customerId != null
            ? customerDatabase?.firstWhere((element) => element.id == customerId)
            : null;
        
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
          children: [
            customer != null ?
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text('Profile'),
                    ),
                    const Divider(indent: 8, endIndent: 8),
                    ListTile(
                      title: const Text('Name'),
                      subtitle: Text(customer.name),
                    ),
                    ListTile(
                      title: const Text('Phone Number'),
                      subtitle: Text(customer.phoneNumber),
                    ),
                    ListTile(
                      title: const Text('Email Address'),
                      subtitle: Text(customer.email),
                    ),
                  ],
                ),
              ),
            ) : Container(),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text('Items'),
                    ),
                    const Divider(indent: 8, endIndent: 8),
                    ...items.map((e) => ListTile(
                      title: Text('${e.item.name} ${e.item.brand != null ? "(${e.item.brand!.data!.name})" : ""}'),
                      subtitle: Text('\$${e.item.saleData!.price.toStringAsFixed(2)} per unit'),
                      trailing: Text('${e.quantity} unit(s)'),
                    )),
                  ],
                ),
              ),
            ),
          ],
        );
    }
  }

  footButtonOnStep() {
    switch (step) {
      case 0:
        return [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  step = 1;
                });
              },
              child: const Text('Next')
          ),
        ];

      case 1:
        return [
          TextButton(
            child: const Text('Back'),
            onPressed: () {
              setState(() {
                step = 0;
              });
            },
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  step = 2;
                });
              },
              child: const Text('Next')
          ),
        ];

      case 2:
        return [
          TextButton(
            child: const Text('Back'),
            onPressed: () {
              setState(() {
                step = 1;
              });
            },
          ),
          TextButton(
            onPressed: () {
              final customer = customerId;
              final checkoutItems = items.map((e) => {
                'item_id': e.item.id,
                'quantity': e.quantity,
              }).toList();

              CheckoutAction.of(context).create(customer: customer, items: checkoutItems).then((response) {
                if (response is ErrorResponse) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response.message)),
                  );

                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Checkout Successfully')),
                );
                Navigator.of(context).pop();
              });
            },
            child: const Text('Checkout')
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: itemDatabase != null && customerDatabase != null ? formOnStep() : const Center(child: CircularProgressIndicator()),
      persistentFooterButtons: itemDatabase != null && customerDatabase != null ? footButtonOnStep() : null,
    );
  }
}

class AddCheckoutItemPage extends StatelessWidget {
  final List<ItemMeta> items;
  final Function onAdd;

  const AddCheckoutItemPage({super.key, required this.items, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: items.map((e) => ListTile(
          title: Text(e.name),
          subtitle: Text(e.universalProductCode),
          onTap: () {
            onAdd(e);
            Navigator.of(context).pop();
          },
        )).toList(),
      ),
    );
  }
}

class BarcodeScanner extends StatefulWidget {
  final Function onScanClick;
  
  const BarcodeScanner({super.key, required this.onScanClick});

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> with WidgetsBindingObserver {
  Barcode? _barcode;

  final MobileScannerController controller = MobileScannerController(
    // required options for the scanner
  );

  StreamSubscription<Object?>? _subscription;

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!controller.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen(_handleBarcode);

        unawaited(controller.start());
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }

  @override
  void initState() {
    super.initState();
    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Start listening to the barcode events.
    _subscription = controller.barcodes.listen(_handleBarcode);

    // Finally, start the scanner itself.
    unawaited(controller.start());
  }

  @override
  Future<void> dispose() async {
    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    // Stop listening to the barcode events.
    unawaited(_subscription?.cancel());
    _subscription = null;
    // Dispose the widget itself.
    super.dispose();
    // Finally, dispose of the controller.
    await controller.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(
              SnackBar(content: Text(widget.onScanClick(_barcode) ? 'Scanned' : 'Not barcode found'))
          );
        },
        child: MobileScanner(
          onDetect: _handleBarcode,
        ),
      ),
    );
  }
}