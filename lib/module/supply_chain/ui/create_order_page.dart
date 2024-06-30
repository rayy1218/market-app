import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:MarketEase/api/error_response.dart';
import 'package:MarketEase/model/entity/item_source.dart';
import 'package:MarketEase/model/entity/supplier.dart';
import 'package:MarketEase/module/supply_chain/action/supply.action.dart';

class CreateOrderPage extends StatefulWidget {
  final int? supplierId;
  const CreateOrderPage({super.key, this.supplierId});

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  List<Supplier>? suppliers;
  Map<int, int> sourcesSelected = {};

  void onSelectSource(ItemSource source, int quantity) {
    setState(() {
      sourcesSelected[source.id!] = quantity;
    });
  }

  void fetch() async {
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
        title: const Text('Create Order'),
      ),
      body: FormBuilder(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: FormBuilderDropdown(
                items: suppliers == null ? [] : suppliers!.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                decoration: const InputDecoration(
                  labelText: 'Supplier',
                  border: OutlineInputBorder(),
                ),
                initialValue: suppliers == null || widget.supplierId == null ? null : widget.supplierId,
                name: 'supplier',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: FormBuilderTextField(
                decoration: const InputDecoration(
                  labelText: 'Remark',
                  border: OutlineInputBorder(),
                ),
                name: 'remark',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: FormBuilderCheckbox(
                name: 'send_mail',
                initialValue: false,
                title: const Text('Send Email'),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Add Order Item'),
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  _formKey.currentState?.save();
                  int? id = _formKey.currentState?.value['supplier'];
                  if (id == null) {
                    return;
                  }
                  Supplier data = suppliers!.firstWhere((element) => element.id == id);
                  List<ItemSource> sources = data.sources!.where((e) => !sourcesSelected.keys.contains(e.id)).toList();

                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChooseSourcePage(sources: sources, onSelectSource: onSelectSource)
                      )
                  );
                },
              ),
            ),
            ...sourcesSelected.keys.map((e) {
              int? id = _formKey.currentState?.value['supplier'];
              ItemSource source = suppliers!
                  .firstWhere((element) => element.id == id).sources!
                  .firstWhere((element) => element.id == e);

              return Card(
                child: ListTile(
                  title: Text(source.itemMeta.data!.name),
                  subtitle: Text('RM${source.unitPrice} per unit'),
                  trailing: Text(sourcesSelected[e].toString()),
                ),
              );
            }),
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
              final supplier = _formKey.currentState!.value['supplier'];
              final remark = _formKey.currentState!.value['remark'] ?? '';
              final sendMail = _formKey.currentState!.value['send_mail'];
              final orderItems = sourcesSelected.keys.map((e) => {'id': e, 'quantity': sourcesSelected[e]}).toList();

              SupplyAction.of(context).createOrder(
                supplier: supplier, remark: remark, sendMail: sendMail,
                orderItems: orderItems,
              ).then((response) {
                if (response is ErrorResponse) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response.message))
                  );

                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order Created Successfully'))
                );

                Navigator.of(context).pop();
              });
            },
            child: const Text('Create')
        ),
      ],
    );
  }
}

class ChooseSourcePage extends StatefulWidget {
  final List<ItemSource> sources;
  final Function(ItemSource, int) onSelectSource;

  const ChooseSourcePage({super.key, required this.sources, required this.onSelectSource});

  @override
  State<ChooseSourcePage> createState() => _ChooseSourcePageState();
}

class _ChooseSourcePageState extends State<ChooseSourcePage> {
  final quantityInputController = TextEditingController();

  Future onClick(ItemSource source) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Brand'),
          content: TextField(
            controller: quantityInputController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Quantity'
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                widget.onSelectSource(source, int.parse(quantityInputController.value.text));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Source'),
      ),
      body: ListView(
        children: widget.sources.map((e) => ListTile(
          title: Text(e.itemMeta.data!.name),
          subtitle: Text('\$${e.unitPrice} per unit, ${e.minOrderQuantity} minimum'),
          trailing: Text('${e.estimatedLeadTime} day(s)'),
          onTap: () async {
            onClick(e).then((_) => Navigator.of(context).pop());
          },
        )).toList(),
      ),
    );
  }
}