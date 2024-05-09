import 'package:flutter/material.dart';
import 'package:supermarket_management/dumb.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Home'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.redAccent,
                        child: Icon(Icons.warning_amber),
                      ),
                      title: const Text("Shift Start Not Recorded Yet"),
                      trailing: IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.redAccent,
                        child: Icon(Icons.warning_amber),
                      ),
                      title: Text("Products In Low Stock Number"),
                    ),
                    Divider(indent: 8, endIndent: 8),
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.inventory),
                      ),
                      title: Text(DumbData.itemMetas[2].name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(onPressed: () {}, icon: Icon(Icons.close)),
                          IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward))
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.inventory),
                      ),
                      title: Text(DumbData.itemMetas[3].name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(onPressed: () {}, icon: Icon(Icons.close)),
                          IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}