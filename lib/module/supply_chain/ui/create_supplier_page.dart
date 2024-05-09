import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

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
        title: Text('Create Supplier Profile'),
      ),
      body: FormBuilder(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Supplier Name',
                  ),
                ),
                Padding(padding: const EdgeInsets.all(8)),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Supplier Email'
                  ),
                ),
                Padding(padding: const EdgeInsets.all(8)),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Supplier Phone Number'
                  ),
                ),
                Padding(padding: const EdgeInsets.all(8)),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Supplier Address'
                  ),
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
        TextButton(onPressed: () {}, child: const Text('Create')),
      ],
    );
  }
}