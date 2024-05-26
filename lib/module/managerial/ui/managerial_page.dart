import 'package:flutter/material.dart';
import 'package:supermarket_management/model/entity/group.dart';
import 'package:supermarket_management/model/entity/user.dart';
import 'package:supermarket_management/module/managerial/action/employee.action.dart';
import 'package:supermarket_management/module/managerial/action/group.action.dart';
import 'package:supermarket_management/module/managerial/ui/create_employee_page.dart';
import 'package:supermarket_management/module/managerial/ui/create_group_page.dart';
import 'package:supermarket_management/module/managerial/ui/employee_detail_page.dart';
import 'package:supermarket_management/module/managerial/ui/group_detail_page.dart';

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

class ManageEmployeePanel extends StatefulWidget {
  const ManageEmployeePanel({super.key});

  @override
  State<ManageEmployeePanel> createState() => _ManageEmployeePanelState();
}

class _ManageEmployeePanelState extends State<ManageEmployeePanel> {
  List<User>? entries;
  int page = 0;

  void fetchMore() async {
    EmployeeAction.of(context).fetchByPage(context: context, page: page).then((response) {
      setState(() {
        entries = (response.data['data'] as List).map((item) => User.fromMap(item)).toList();
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
      body: entries != null ? ListView(
        children: entries!.map((e) => ListTile(
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
      ) : const Center(child: CircularProgressIndicator()),
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

class ManageGroupPanel extends StatefulWidget {
  const ManageGroupPanel({super.key});

  @override
  State<ManageGroupPanel> createState() => _ManageGroupPanelState();
}

class _ManageGroupPanelState extends State<ManageGroupPanel> {
  List<Group>? entries;
  int page = 0;

  void fetchMore() async {
    GroupAction.of(context).fetchByPage().then((response) {
      setState(() {
        entries = (response['data'] as List).map((item) => Group.fromMap(item)).toList();
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
      body: entries != null ? ListView(
        children: entries!.map((e) => ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.person),
          ),
          title: Text(e.name),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => GroupDetailPage(id: e.id!))
            ).then((_) {
              entries = [];
              page = 0;

              fetchMore();
            });
          },
        )).toList(),
      ) : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CreateGroupPage())
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