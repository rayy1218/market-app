import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:MarketEase/api/error_response.dart';
import 'package:MarketEase/module/supply_chain/action/supply.action.dart';

class CreateSupplierPage extends StatefulWidget {
  const CreateSupplierPage({super.key});

  @override
  State<CreateSupplierPage> createState() => _CreateSupplierPageState();
}

class _CreateSupplierPageState extends State<CreateSupplierPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Supplier Profile'),
      ),
      body: FormBuilder(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
            children: [
              const Text('Supplier Profile'),
              const Divider(),
              const Padding(padding: EdgeInsets.all(4)),
              FormBuilderTextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Supplier Name',
                ),
                name: 'name',
              ),
              const Padding(padding: EdgeInsets.all(8)),
              FormBuilderTextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Supplier Email'
                ),
                name: 'email',
              ),
              const Padding(padding: EdgeInsets.all(8)),
              FormBuilderTextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Supplier Phone Number'
                ),
                name: 'phone',
              ),
              const Padding(padding: EdgeInsets.all(8)),
              const Text('Supplier Address'),
              const Divider(),
              const Padding(padding: EdgeInsets.all(4)),
              FormBuilderTextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Line 1'
                ),
                name: 'line1',
              ),
              const Padding(padding: EdgeInsets.all(8)),
              FormBuilderTextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Line 2'
                ),
                name: 'line2',
              ),
              const Padding(padding: EdgeInsets.all(8)),
              FormBuilderTextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'City'
                ),
                name: 'city',
              ),
              const Padding(padding: EdgeInsets.all(8)),
              FormBuilderTextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'State'
                ),
                name: 'state',
              ),
              const Padding(padding: EdgeInsets.all(8)),
              FormBuilderTextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Zipcode'
                ),
                name: 'zipcode',
              ),
              const Padding(padding: EdgeInsets.all(8)),
              FormBuilderTextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Country'
                ),
                name: 'country',
              ),
            ],
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
            _formKey.currentState!.save();

            SupplyAction.of(context).createSupplier(
              name: _formKey.currentState?.value['name'],
              phone:  _formKey.currentState?.value['phone'],
              email: _formKey.currentState?.value['email'],
              line1: _formKey.currentState?.value['line1'],
              line2: _formKey.currentState?.value['line2'],
              city: _formKey.currentState?.value['city'],
              state: _formKey.currentState?.value['state'],
              zipcode: _formKey.currentState?.value['zipcode'],
              country: _formKey.currentState?.value['country'],
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