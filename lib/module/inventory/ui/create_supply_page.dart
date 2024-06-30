import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:MarketEase/api/error_response.dart';
import 'package:MarketEase/model/entity/item_meta.dart';
import 'package:MarketEase/model/entity/item_source.dart';
import 'package:MarketEase/model/entity/item_supply_data.dart';
import 'package:MarketEase/module/inventory/action/inventory.action.dart';

class CreateSupplyPage extends StatefulWidget {
  final ItemMeta itemMeta;
  final ItemSource itemSource;

  const CreateSupplyPage({super.key, required this.itemMeta, required this.itemSource});

  @override
  State<CreateSupplyPage> createState() => _CreateSupplyPageState();
}

class _CreateSupplyPageState extends State<CreateSupplyPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Item Supply'),
      ),
      body: FormBuilder(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormBuilderDropdown(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'On Low Stock Action',
                  ),
                  name: 'onLowStockAction',
                  items: [RestockAction.email, RestockAction.notify, RestockAction.none].map((e) => DropdownMenuItem(value: e.value, child: Text(e.label))).toList(),
                ),
                const Padding(padding: EdgeInsets.all(8)),
                FormBuilderTextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Default Restock Quantity'
                  ),
                  name: 'defaultRestockQuantity',
                ),
                const Padding(padding: EdgeInsets.all(8)),
                FormBuilderTextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Restock Point'
                  ),
                  name: 'restockPoint',
                ),
              ],
            ),
          )
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

              final String onLowStockAction = _formKey.currentState?.value['onLowStockAction'];
              final int defaultRestockQuantity = int.parse(_formKey.currentState?.value['defaultRestockQuantity']);
              final int restockPoint = int.parse(_formKey.currentState?.value['restockPoint']);

              InventoryAction.of(context).setSupply(
                  id: widget.itemMeta.id,
                  sourceId: widget.itemSource.id,
                  onLowStockAction: onLowStockAction,
                  defaultRestockQuantity: defaultRestockQuantity,
                  restockPoint: restockPoint
              ).then((response) {
                if (response is ErrorResponse) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response.message))
                  );

                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Supply Set Successfully'))
                );

                Navigator.of(context).pop();
              });
            },
            child: const Text('Set')
        ),
      ],
    );
  }
}