import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:MarketEase/api/error_response.dart';
import 'package:MarketEase/module/customer/action/customer.action.dart';

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
        title: const Text('Create Customer Profile'),
      ),
      body: FormBuilder(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormBuilderTextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Customer Name',
                  ),
                  name: 'name',
                ),
                const Padding(padding: EdgeInsets.all(8)),
                FormBuilderTextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Customer Email'
                  ),
                  name: 'email',
                ),
                const Padding(padding: EdgeInsets.all(8)),
                FormBuilderTextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Customer Phone Number'
                  ),
                  name: 'phone',
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

            final String name = _formKey.currentState?.value['name'];
            final String phone = _formKey.currentState?.value['phone'];
            final String email = _formKey.currentState?.value['email'];

            CustomerAction.of(context).createCustomer(
                name: name, phone: phone, email: email
            ).then((response) {
              if (response is ErrorResponse) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response.message))
                );

                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Supply Created Successfully'))
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