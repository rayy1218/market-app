import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:MarketEase/module/auth/action/authentication.action.dart';

class RegisterPage extends StatefulWidget {

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  void onRegisterClick(BuildContext context) {
    final email = _formKey.currentState?.fields['email']?.value as String;
    final password = _formKey.currentState?.fields['password']?.value as String;
    final username = _formKey.currentState?.fields['username']?.value as String;
    final firstName = _formKey.currentState?.fields['firstName']?.value as String;
    final lastName = _formKey.currentState?.fields['lastName']?.value as String;
    final companyName = _formKey.currentState?.fields['companyName']?.value as String;

    AuthenticationAction.register(
        context, email, password, username, firstName, lastName, companyName
    ).then((value) {
      switch (value) {
        case 'FAILED_EMAIL':
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Email is registered before'),
          ));
          break;
      }

      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FormBuilder(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Text('Account Information'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                  child: FormBuilderTextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                    ),
                    name: 'username',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                  child: FormBuilderTextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    name: 'email',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                  child: FormBuilderTextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    name: 'password',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                  child: FormBuilderTextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Re-enter Password',
                    ),
                    obscureText: true,
                    name: 'reEnterPassword',
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                  child: Text('Profile Information'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                  child: FormBuilderTextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'First Name',
                    ),
                    name: 'firstName',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                  child: FormBuilderTextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Last Name',
                    ),
                    name: 'lastName',
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                  child: Text('Company Information'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                  child: FormBuilderTextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Company Name',
                    ),
                    name: 'companyName',
                  ),
                ),
              ],
            )
        ),
        persistentFooterButtons: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Register'),
            onPressed: () {
              onRegisterClick(context);
            },
          )
        ],
      );
  }
}