import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket_management/module/home/ui/dashboard_page.dart';
import 'package:supermarket_management/module/home/ui/operation_page.dart';
import 'package:supermarket_management/module/home/ui/profile_page.dart';
import 'package:supermarket_management/module/home/ui/report_page.dart';

import '../../../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(
            bottomNavigationBar: NavigationBar(
              onDestinationSelected: (int index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              selectedIndex: currentPageIndex,
              destinations: const [
                NavigationDestination(
                    icon: Icon(Icons.home),
                    label: 'Home'
                ),
                NavigationDestination(
                    icon: Icon(Icons.store),
                    label: 'Operation'
                ),
                NavigationDestination(
                    icon: Icon(Icons.assessment),
                    label: 'Report'
                ),
                NavigationDestination(
                    icon: Icon(Icons.person_2),
                    label: 'Profile'
                ),
              ],
            ),
            body: [
              const DashboardPage(),
              const OperationPage(),
              const ReportPage(),
              const ProfilePage(),
            ][currentPageIndex]
        );
      },
    );
  }
}