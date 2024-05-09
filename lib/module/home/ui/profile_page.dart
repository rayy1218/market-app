import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket_management/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        bloc: BlocProvider.of<AuthenticationBloc>(context),
        builder: (context, state) {
          state = state as LogonState;

          return Scaffold(
            appBar: AppBar(title: const Text('Profile'), automaticallyImplyLeading: false),
            body: Column(
              children: [
                Text(state.token),
                TextButton(
                    onPressed: () => BlocProvider.of<AuthenticationBloc>(context).add(LogOutEvent()),
                    child: const Text('Logout')
                ),
              ],
            ),
          );
        },
      );
  }
}