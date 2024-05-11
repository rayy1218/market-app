import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:supermarket_management/model/entity/group.dart';
import 'package:supermarket_management/module/managerial/action/employee.action.dart';
import 'package:supermarket_management/module/managerial/action/group.action.dart';

class CreateEmployeePage extends StatefulWidget {
  const CreateEmployeePage({super.key});

  @override
  State<CreateEmployeePage> createState() => _CreateEmployeePageState();
}

class _CreateEmployeePageState extends State<CreateEmployeePage> {
  final formKey = GlobalKey<FormBuilderState>();

  List<Group> groups = [];
  bool loading = false;

  void fetchGroupDropdown() {
    setState(() {
      loading = true;
    });

    GroupAction.of(context).fetchAll().then((response) {
      setState(() {
        groups.addAll((response['data'] as List).map((item) => Group.fromMap(item)).toList());
        loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchGroupDropdown();
    });
  }

  onCreateClick() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Employee'),
      ),
      body: FormBuilder(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                  child: FormBuilderTextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Employee Name',
                    ),
                    name: 'username',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                  child: FormBuilderDropdown(
                    isExpanded: true,
                    items: groups.map((value) {
                      return DropdownMenuItem(value: value.id!, child: Text(value.name));
                    }).toList(),
                    onChanged: (value) {  },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Employee Group',
                    ),
                    name: 'group',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                  child: FormBuilderTextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Employee Email',
                    ),
                    name: 'email',
                  ),
                ),
              ],
            ),
          )
      ),
      persistentFooterButtons: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
            onPressed: () {
              formKey.currentState?.save();

              final String email = formKey.currentState!.value['email'] as String;
              final int group = formKey.currentState!.value['group'] as int;
              final String username = formKey.currentState!.value['username'] as String;

              EmployeeAction.of(context).create(
                email: email,
                group: group,
                username: username,
              ).then((response) {
                if (response == 'FAILED_RECORD_EXISTED') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('The email has been registered before'))
                  );
                }
                else if (response == 'FAILED_SERVER') {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Server error'))
                  );
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Employee created successfully'))
                  );

                  Navigator.of(context).pop();
                }
              });
            },
            child: const Text('Create')
        ),
      ],
    );
  }
}