import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:MarketEase/model/entity/access_right.dart';
import 'package:MarketEase/model/entity/group.dart';
import 'package:MarketEase/model/entity/group_access_right.dart';
import 'package:MarketEase/model/entity/user.dart';
import 'package:MarketEase/module/managerial/action/group.action.dart';
import 'package:MarketEase/module/managerial/ui/employee_detail_page.dart';

class GroupDetailPage extends StatefulWidget {
  const GroupDetailPage({super.key, required this.id});

  final int id;

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  Group? group;
  List<GroupAccessRight>? enabledAccessRight;
  Map<String, List<GroupAccessRight>>? accessRights;
  List<User>? employees;
  
  void fetchGroup() async {
    GroupAction.of(context).fetchOne(id: widget.id).then((response) {
      setState(() {
        group = Group.fromMap(response['data']);
        enabledAccessRight = (response['data']['access_right'] as List).map((item) => GroupAccessRight.fromMap(item)).toList().where((element) => element.enabled).toList();
        accessRights = groupBy((response['data']['access_right'] as List).map((item) => GroupAccessRight.fromMap(item)).toList(), (GroupAccessRight p0) => p0.name.split(' ')[0]);
        employees = (response['data']['employees'] as List).map((item) => User.fromMap(item)).toList();
      });
    });
  }
  
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchGroup();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Group Detail'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Members'),
              Tab(text: 'Access Rights'),
            ],
          ),
        ),
        body: group != null ? TabBarView(
          children: [
            GroupDetailMembersTab(id: widget.id, employees: employees!),
            GroupDetailAccessRightTab(id: widget.id, accessRights: accessRights!, enabledAccessRight: enabledAccessRight!)
          ],
        ) : Container()
      ),
    );
  }
}

class GroupDetailMembersTab extends StatefulWidget {
  const GroupDetailMembersTab({super.key, required this.id, required this.employees});

  final int id;
  final List<User> employees;

  @override
  State<GroupDetailMembersTab> createState() => _GroupDetailMembersTabState();
}

class _GroupDetailMembersTabState extends State<GroupDetailMembersTab> {
  bool editing = false;
  List<User>? employees;
  List<int> selected = [];

  void fetchEmployees() async {
    GroupAction.of(context).getMemberList(id: widget.id).then((response) {
      setState(() {
        employees = (response['data'] as List).map((item) => User.fromMap(item)).toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !editing ? ListView(
        padding: const EdgeInsets.all(16),
        children: widget.employees.map((e) => ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.person),
          ),
          title: Text(e.username),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EmployeeDetailPage(id: e.id!, allowDelete: false))
            );
          },
        )).toList(),
      ) : ListView(
        padding: const EdgeInsets.all(16),
        children: employees!.map((e) => ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.person),
          ),
          title: Text(e.username),
          trailing: Checkbox(
            value: selected.contains(e.id!),
            onChanged: (bool? value) {
              if (value == true) {
                setState(() {
                  selected.add(e.id!);
                });
              }
              else {
                setState(() {
                  selected.remove(e.id!);
                });
              }
            },
          ),
        )).toList(),
      ),
      floatingActionButton: !editing && employees != null ? FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {
          setState(() {
            editing = true;
          });
        },
      ) : null,
      persistentFooterButtons: editing ? [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            setState(() {
              editing = false;
              selected = [];
            });
          },
        ),
        TextButton(
            onPressed: () {
              GroupAction.of(context).updateMember(id: widget.id, newMember: selected)
                  .then((response) {
                if (response == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Updated'))
                  );
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response))
                  );
                }

                setState(() {
                  editing = false;
                });

                Navigator.of(context).pop();
              });
            },
            child: const Text('Save')
        ),
      ] : null,
    );
  }
}

class GroupDetailAccessRightTab extends StatefulWidget {
  const GroupDetailAccessRightTab({super.key, required this.id, required this.accessRights, required this.enabledAccessRight});

  final int id;
  final List<GroupAccessRight> enabledAccessRight;
  final Map<String, List<GroupAccessRight>> accessRights;

  @override
  State<GroupDetailAccessRightTab> createState() => _GroupDetailAccessRightTabState();
}

class _GroupDetailAccessRightTabState extends State<GroupDetailAccessRightTab> {
  bool editing = false;
  Map<String, List<AccessRight>>? accessRights;
  late List<int> enabled = widget.enabledAccessRight.map((e) => e.id!).toList();

  final accessRightGroupingName = {
    'managerial': 'Managerial',
    'shift': 'Shift Scheduling',
    'inventory': 'Inventory Management',
    'supply': 'Supply Chain Management',
    'sales': 'Sales Management',
    'report': 'Reporting'
  };

  void fetchAccessRight() async {
    GroupAction.of(context).fetchAccessRightDropdown().then((response) {
      setState(() {
        final List<AccessRight> data = (response['data']['accessRight'] as List).map((item) => AccessRight.fromMap(item)).toList();
        accessRights = groupBy(data, (AccessRight p0) => p0.name.split(' ')[0]);
      });
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAccessRight();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !editing ? ListView(
        padding: const EdgeInsets.all(16),
        children: widget.accessRights.keys.map((e) => <Widget>[
          ListTile(
            title: Text(accessRightGroupingName[e]!),
          ),
          ...widget.accessRights[e]!.map((GroupAccessRight item) => ListTile(
            leading: Checkbox(
                value: item.enabled,
                onChanged: (bool? value) {}
            ),
            title: Text(item.label),
          )).toList(),
        ]).flattened.toList(),
      ) : ListView(
        padding: const EdgeInsets.all(16),
        children: accessRights!.keys.map((e) => <Widget>[
          ListTile(
            title: Text(accessRightGroupingName[e]!),
          ),
          ...accessRights![e]!.map((AccessRight item) => ListTile(
            leading: Checkbox(
                value: enabled.contains(item.id),
                onChanged: (bool? value) {
                  if (value!) {
                    setState(() {
                      enabled.add(item.id!);
                    });
                  }
                  else {
                    setState(() {
                      enabled.remove(item.id);
                    });
                  }
                }
            ),
            title: Text(item.label),
          )).toList(),
        ]).flattened.toList(),
      ),
      floatingActionButton: !editing && accessRights != null ? FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {
          setState(() {
            editing = true;
          });
        },
      ) : null,
      persistentFooterButtons: editing ? [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            setState(() {
              editing = false;
              enabled = widget.enabledAccessRight.map((e) => e.id!).toList();
            });
          },
        ),
        TextButton(
          onPressed: () {
            GroupAction.of(context).updateAccessRight(id: widget.id, accessRight: enabled)
                .then((response) {
                  if (response == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Updated'))
                    );
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response))
                    );
                  }

                  setState(() {
                    editing = false;
                  });

                  Navigator.of(context).pop();
                });
          },
          child: const Text('Save')
        ),
      ] : null,
    );
  }
}