import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MarketEase/main.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        bloc: BlocProvider.of<AuthenticationBloc>(context),
        builder: (context, state) {
          state = state as LogonState;

          return Scaffold(
            appBar: AppBar(title: const Text('Setting'), automaticallyImplyLeading: false),
            body: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () => BlocProvider.of<AuthenticationBloc>(context).add(LogOutEvent()),
                ),
              ],
            )
          );
        },
      );
  }
}