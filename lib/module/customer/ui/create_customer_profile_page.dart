import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CreateCustomerProfilePage extends StatefulWidget {
  const CreateCustomerProfilePage({super.key});

  @override
  State<CreateCustomerProfilePage> createState() => _CreateCustomerProfilePageState();
}

class _CreateCustomerProfilePageState extends State<CreateCustomerProfilePage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Customer Profile'),
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
                    labelText: 'Customer Name',
                  ),
                ),
                Padding(padding: const EdgeInsets.all(8)),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Customer Email'
                  ),
                ),
                Padding(padding: const EdgeInsets.all(8)),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Customer Phone Number'
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