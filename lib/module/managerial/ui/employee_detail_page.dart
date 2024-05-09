import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:supermarket_management/module/managerial/action/employee.action.dart';
import 'package:supermarket_management/model/entity/user.dart';
import 'package:supermarket_management/model/entity/group.dart';

class EmployeeDetailPage extends StatefulWidget {
  const EmployeeDetailPage({super.key, required this.id, this.allowDelete});

  final int id;
  final bool? allowDelete;

  @override
  State<EmployeeDetailPage> createState() => _EmployeeDetailPageState();
}

class _EmployeeDetailPageState extends State<EmployeeDetailPage> {
  User? entry;
  List<Group>? groups;

  void fetchUser() async {
    EmployeeAction.of(context).fetchOne(id: widget.id).then((response) {
      setState(() {
        entry = User.fromMap(response['data']);
      });
    });
  }

  void fetchGroupDropdown() async {
    EmployeeAction.of(context).fetchGroupDropdown().then((response) {
      setState(() {
        groups = (response['data'] as List).map((item) => Group.fromMap(item)).toList();
      });
    });
  }

  void onDeleteClick() async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          actions: <Widget>[
            TextButton(
              child: const Text('No', style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                Navigator.of(context).pop();

              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                delete();
              },
            ),
          ],
        );
      },
    );
  }

  void delete() async {
    EmployeeAction.of(context).delete(id: widget.id).then((response) {
      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response)));
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Employee has been deleted")));
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchUser();
      fetchGroupDropdown();
    });
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Detail'),
        actions: widget.allowDelete == null || !(widget.allowDelete!) ? [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
                onPressed: onDeleteClick,
                icon: const Icon(Icons.delete)
            ),
          ),
        ] : [],
      ),
      body: entry != null ? FormBuilder(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const Center(
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 60,
                  child: Icon(Icons.person, size: 60),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 32.0, 16, 8.0),
                child: TextField(
                  controller: TextEditingController(text: entry!.username),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                  readOnly: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16.0, 16, 8.0),
                child: TextField(
                  controller: TextEditingController(text: entry!.status),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Status',
                  ),
                  readOnly: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16.0, 16, 8.0),
                child: TextField(
                  controller: TextEditingController(text: entry!.email),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email Address',
                  ),
                  readOnly: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16.0, 16, 8.0),
                child: TextField(
                  controller: TextEditingController(text: entry!.group.data?.name),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Group',
                  ),
                  readOnly: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16.0, 16, 8.0),
                child: TextField(
                  controller: TextEditingController(text: DateFormat("y MMM d HH:MM").format(entry!.joinedAt)),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Joined At',
                  ),
                  readOnly: true,
                ),
              ),
            ],
          ),
        ),
      ) : const Center( child: CircularProgressIndicator()),
    );
  }
}