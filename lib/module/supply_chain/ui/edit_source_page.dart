import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:MarketEase/api/error_response.dart';
import 'package:MarketEase/model/entity/item_source.dart';
import 'package:MarketEase/model/entity/supplier.dart';
import 'package:MarketEase/module/supply_chain/action/supply.action.dart';

class EditSourcePage extends StatefulWidget {
  final ItemSource itemSource;
  final Supplier supplier;

  const EditSourcePage({super.key, required this.itemSource, required this.supplier});

  @override
  State<EditSourcePage> createState() => _EditSourcePageState();
}

class _EditSourcePageState extends State<EditSourcePage> {
  final _formKey = GlobalKey<FormBuilderState>();

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
                      child: TextField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Item'
                        ),
                        controller: TextEditingController(text: widget.itemSource.itemMeta.data?.name),
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                child: TextField(
                  controller: TextEditingController(text: widget.supplier.name),
                  readOnly: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Supplier'
                  ),
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
                  initialValue: widget.itemSource.unitPrice.toString(),
                  name: 'unit_price',
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                child: FormBuilderTextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Minimum Order Quantity'
                ),
                initialValue: widget.itemSource.minOrderQuantity.toString(),
                name: 'min_order_quantity',
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                child: FormBuilderTextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Estimated Lead Time (Days)'
                  ),
                  initialValue: widget.itemSource.estimatedLeadTime.toString(),
                  name: 'estimated_lead_time',
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

              SupplyAction.of(context).updateItemSource(
                id: widget.itemSource.id,
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
                    const SnackBar(content: Text('Supplier Profile Updated Successfully'))
                );

                Navigator.of(context).pop();
              });
            },
            child: const Text('Update'))
        ,
      ],
    );
  }
}