import 'package:flutter/material.dart';

class SelectPage extends StatefulWidget {
  final List items;
  final List Function(List items, String text) filter;
  final Widget Function(dynamic item) transformer;

  const SelectPage({super.key, required this.items, required this.filter, required this.transformer});

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search')
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search',
              ),
              onChanged: (String value) {
                setState(() {
                  text = value;
                });
              },
            ),
          ),
          ...widget.filter(widget.items, text).map((item) => widget.transformer(item)).toList()
        ],
      ),
    );
  }
}