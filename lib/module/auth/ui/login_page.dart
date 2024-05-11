import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:supermarket_management/module/auth/action/authentication.action.dart';
import 'package:supermarket_management/module/auth/ui/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormBuilderState>();

  void onLoginClick(BuildContext context) {
    final email = formKey.currentState?.fields['email']?.value;
    final password = formKey.currentState?.fields['password']?.value;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Password or Email must not be empty'),
      ));

      return;
    }

    AuthenticationAction.login(context, email as String, password as String).then((value) {
      switch (value) {
        case 'FAILED_PASSWORD_EMAIL':
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Incorrect Password or Email'),
          ));
          break;
      }
    });


  }

  void onRegisterClick(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RegisterPage())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormBuilder(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 80, 40, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 32),
                        child: Center(child: Text('Login', style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold))),
                      ),
                      FormBuilderTextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                        name: 'email',
                      ),
                      const Padding(padding: EdgeInsets.all(8)),
                      FormBuilderTextField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password'
                          ),
                          obscureText: true,
                          name: 'password'
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                            child: Center(
                              child: ElevatedButton(
                                  onPressed: () => onLoginClick(context),
                                  child: const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Login',
                                            style: TextStyle(fontSize: 18)),
                                        Icon(Icons.arrow_forward_ios_outlined)
                                      ],
                                    ),
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => onRegisterClick(context),
                    child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('Register')
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}