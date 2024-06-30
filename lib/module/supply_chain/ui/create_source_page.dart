import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:MarketEase/api/error_response.dart';
import 'package:MarketEase/model/entity/item_meta.dart';
import 'package:MarketEase/model/entity/supplier.dart';
import 'package:MarketEase/module/inventory/action/inventory.action.dart';
import 'package:MarketEase/module/supply_chain/action/supply.action.dart';

class CreateSourcePage extends StatefulWidget {
  final ItemMeta? itemMeta;
  final Supplier? supplier;

  const CreateSourcePage({super.key, this.itemMeta, this.supplier});

  @override
  State<CreateSourcePage> createState() => _CreateSourcePageState();
}

class _CreateSourcePageState extends State<CreateSourcePage> {
  final _formKey = GlobalKey<FormBuilderState>();

  List<ItemMeta>? items;
  List<Supplier>? suppliers;

  void fetch() async {
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

    SupplyAction.of(context).fetchSuppliers().then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        suppliers = (response['data'] as List).map((item) => Supplier.fromMap(item)).toList();
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
        title: const Text('Create Item Source')
      ),
      body: FormBuilder(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: FormBuilderDropdown(
                        items: items == null ? [] : items!.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Item'
                        ),
                        initialValue: items == null ? null : widget.itemMeta?.id,
                        name: 'item_meta',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: const Icon(Icons.barcode_reader),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                child: FormBuilderDropdown(
                  items: suppliers == null ? [] : suppliers!.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Supplier'
                  ),
                  initialValue: suppliers == null ? null : widget.supplier?.id,
                  name: 'supplier',
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                child: FormBuilderTextField(
                    inputFormatters: [CurrencyTextInputFormatter.currency(symbol: '\$')],
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Unit Price'
                    ),
                    name: 'unit_price'
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                child: FormBuilderTextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Minimum Order Quantity'
                    ),
                    name: 'min_order_quantity'
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                child: FormBuilderTextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Estimated Lead Time (Days)'
                    ),
                    name: 'estimated_lead_time'
                ),
              ),
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
              _formKey.currentState!.save();

              SupplyAction.of(context).createItemSource(
                itemMeta: _formKey.currentState?.value['item_meta'],
                supplier: _formKey.currentState?.value['supplier'],
                unitPrice: double.parse(_formKey.currentState?.value['unit_price'].split('\$')[1]),
                minOrderQuantity: int.parse(_formKey.currentState?.value['min_order_quantity']),
                estimatedLeadTime: int.parse(_formKey.currentState?.value['estimated_lead_time']),
              ).then((response) {
                if (response is ErrorResponse) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response.message))
                  );

                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Supplier Profile Created Successfully'))
                );

                Navigator.of(context).pop();
              });
            },
            child: const Text('Create'))
        ,
      ],
    );
  }
}