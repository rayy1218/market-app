import 'package:flutter/material.dart';
import 'package:supermarket_management/module/managerial/ui/manage_employee_panel.dart';
import 'package:supermarket_management/module/managerial/ui/manage_group_panel.dart';

class ManagerialPage extends StatefulWidget {
  const ManagerialPage({super.key});

  @override
  State<ManagerialPage> createState() => _ManagerialPageState();
}

class _ManagerialPageState extends State<ManagerialPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Managerial'),
      ),
      body: [
        const ManageEmployeePanel(),
        const ManageGroupPanel(),
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.badge),
              label: 'Employee'
          ),
          NavigationDestination(
              icon: Icon(Icons.groups),
              label: 'Group'
          ),
        ],
      ),
    );
  }
}