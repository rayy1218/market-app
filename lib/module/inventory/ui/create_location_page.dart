import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:supermarket_management/module/inventory/action/inventory.action.dart';
import 'package:supermarket_management/api/error_response.dart';
import 'package:supermarket_management/model/entity/stock_location.dart';

class CreateLocationPage extends StatefulWidget {
  const CreateLocationPage({super.key});

  @override
  State<CreateLocationPage> createState() => _CreateLocationPageState();
}

class _CreateLocationPageState extends State<CreateLocationPage> {
  List<StockLocation>? stockLocations;

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
    final _formKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Stock Location'),
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
                  child: FormBuilderTextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Stock Location Name'
                    ),
                    name: 'name',
                  ),
                ),
                stockLocations != null ?
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                  child: FormBuilderDropdown(
                    items: stockLocations!.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Stock Location Parent'
                    ),
                    name: 'parent',
                  ),
                ) : Container(),
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

            final String name = _formKey.currentState?.value['name'];
            final int? parent = _formKey.currentState?.value['parent'];

            InventoryAction.of(context).createLocation(
                name: name, parent: parent
            ).then((response) {
              if (response is ErrorResponse) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response.message))
                );

                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Location Created Successfully'))
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