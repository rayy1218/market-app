import 'package:flutter/material.dart';
import 'package:supermarket_management/module/managerial/action/employee.action.dart';
import 'package:supermarket_management/model/entity/user.dart';
import 'package:supermarket_management/module/managerial/ui/create_employee_page.dart';
import 'package:supermarket_management/module/managerial/ui/employee_detail_page.dart';

class ManageEmployeePanel extends StatefulWidget {
  const ManageEmployeePanel({super.key});

  @override
  State<ManageEmployeePanel> createState() => _ManageEmployeePanelState();
}

class _ManageEmployeePanelState extends State<ManageEmployeePanel> {
  List<User> entries = [];
  int page = 0;
  bool loading = false;

  void fetchMore() async {
    setState(() {
      loading = true;
    });

    EmployeeAction.of(context).fetchByPage(context: context, page: page).then((response) {
      setState(() {
        entries.addAll((response.data['data'] as List).map((item) => User.fromMap(item)).toList());
        loading = false;
        page += 1;
      });

    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchMore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: entries.map((e) => ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.person),
          ),
          title: Text(e.username),
          subtitle: Text(e.group.data!.name),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EmployeeDetailPage(id: e.id!))
            ).then((_) {
              entries = [];
              page = 0;

              fetchMore();
            });
          },
        )).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CreateEmployeePage())
          ).then((_) {
            entries = [];
            page = 0;

            fetchMore();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}