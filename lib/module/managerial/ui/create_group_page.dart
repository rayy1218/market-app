import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:MarketEase/model/entity/access_right.dart';
import 'package:MarketEase/module/managerial/action/group.action.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final accessRightGroupingName = {
    'managerial': 'Managerial',
    'shift': 'Shift Scheduling',
    'inventory': 'Inventory Management',
    'supply': 'Supply Chain Management',
    'sales': 'Sales Management',
    'report': 'Reporting'
  };
  final enabledAccessRight = [];

  Map<String, List<AccessRight>> accessRight = {};
  bool loading = false;

  void fetchAccessRight() async {
    setState(() {
      loading = true;
    });

    GroupAction.of(context).fetchAccessRightDropdown().then((response) {
      setState(() {
        final List<AccessRight> data = (response['data']['accessRight'] as List).map((item) => AccessRight.fromMap(item)).toList();
        accessRight = groupBy(data, (AccessRight p0) => p0.name.split(' ')[0]);
        loading = false;
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
      appBar: AppBar(
        title: const Text('Create Group'),
      ),
      body: FormBuilder(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                  child: FormBuilderTextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Group Name',
                    ),
                    name: 'name',
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView(
                    children: accessRight.keys.map((e) => [
                      ListTile(
                        title: Text(accessRightGroupingName[e]!),
                      ),
                      ...accessRight[e]!.map((AccessRight item) => ListTile(
                        leading: Checkbox(
                            value: enabledAccessRight.contains(item.id),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value!) {
                                  enabledAccessRight.add(item.id);
                                }
                                else {
                                  enabledAccessRight.remove(item.id);
                                }
                              });
                            }
                        ),
                        title: Text(item.label),
                      )).toList(),
                    ]).flattened.toList(),
                  ),
                )
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
            _formKey.currentState?.save();

            final String name = _formKey.currentState!.value['name'] as String;

            GroupAction.of(context).create(
              name: name,
              accessRight: enabledAccessRight,
            ).then((response) {
              if (response == 'FAILED_RECORD_EXISTED') {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('The group with same name has been registered before'))
                );
              }
              else if (response == 'FAILED_SERVER') {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Server error'))
                );
              }
              else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Group created successfully'))
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