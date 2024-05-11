import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:supermarket_management/api/error_response.dart';
import 'package:supermarket_management/model/entity/supplier.dart';
import 'package:supermarket_management/module/supply_chain/action/supply.action.dart';

class SupplierProfileEditPage extends StatefulWidget {
  final Supplier supplier;
  const SupplierProfileEditPage({super.key, required this.supplier});

  @override
  State<SupplierProfileEditPage> createState() => _SupplierProfileEditPageState();
}

class _SupplierProfileEditPageState extends State<SupplierProfileEditPage> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Supplier Profile Edit'),
      ),
      body: FormBuilder(
        key: formKey,
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
              initialValue: widget.supplier.name,
              name: 'name',
            ),
            const Padding(padding: EdgeInsets.all(8)),
            FormBuilderTextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Supplier Email'
              ),
              initialValue: widget.supplier.email,
              name: 'email',
            ),
            const Padding(padding: EdgeInsets.all(8)),
            FormBuilderTextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Supplier Phone Number'
              ),
              initialValue: widget.supplier.phone,
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
              initialValue: widget.supplier.address!.line1,
              name: 'line1',
            ),
            const Padding(padding: EdgeInsets.all(8)),
            FormBuilderTextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Line 2'
              ),
              initialValue: widget.supplier.address!.line2,
              name: 'line2',
            ),
            const Padding(padding: EdgeInsets.all(8)),
            FormBuilderTextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'City'
              ),
              initialValue: widget.supplier.address!.city,
              name: 'city',
            ),
            const Padding(padding: EdgeInsets.all(8)),
            FormBuilderTextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'State'
              ),
              initialValue: widget.supplier.address!.state,
              name: 'state',
            ),
            const Padding(padding: EdgeInsets.all(8)),
            FormBuilderTextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Zipcode'
              ),
              initialValue: widget.supplier.address!.postcode,
              name: 'zipcode',
            ),
            const Padding(padding: EdgeInsets.all(8)),
            FormBuilderTextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Country'
              ),
              initialValue: widget.supplier.address!.country,
              name: 'country',
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
              formKey.currentState!.save();

              SupplyAction.of(context).updateSupplier(
                id: widget.supplier.id!,
                name: formKey.currentState?.value['name'],
                phone:  formKey.currentState?.value['phone'],
                email: formKey.currentState?.value['email'],
                line1: formKey.currentState?.value['line1'],
                line2: formKey.currentState?.value['line2'],
                city: formKey.currentState?.value['city'],
                state: formKey.currentState?.value['state'],
                zipcode: formKey.currentState?.value['zipcode'],
                country: formKey.currentState?.value['country'],
              ).then((response) {
                if (response is ErrorResponse) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response.message))
                  );

                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Supplier Profile Update Successfully'))
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