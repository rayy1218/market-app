import 'package:flutter/material.dart';
import 'package:supermarket_management/dumb.dart';
import 'package:supermarket_management/model/entity/group.dart';
import 'package:supermarket_management/module/managerial/action/group.action.dart';
import 'package:supermarket_management/module/managerial/ui/create_group_page.dart';
import 'package:supermarket_management/module/managerial/ui/group_detail_page.dart';

class ManageGroupPanel extends StatefulWidget {
  const ManageGroupPanel({super.key});

  @override
  State<ManageGroupPanel> createState() => _ManageGroupPanelState();
}

class _ManageGroupPanelState extends State<ManageGroupPanel> {
  List<Group> entries = [];
  int page = 0;
  bool loading = false;

  void fetchMore() async {
    setState(() {
      loading = true;
    });

    GroupAction.of(context).fetchByPage().then((response) {
      setState(() {
        entries.addAll((response['data'] as List).map((item) => Group.fromMap(item)).toList());
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
      ),
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