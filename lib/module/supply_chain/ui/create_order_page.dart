import 'package:flutter/material.dart';
import 'package:supermarket_management/dumb.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key});

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Supplier',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Remark',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: Row(
                children: [
                  Checkbox(value: false, onChanged: (bool? value) {  }),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                      child: Text('Send Email'),
                    ),
                  ),

                ],
              ),
            ),
            Divider(),
            ListTile(
              title: Text('Add Order Item'),
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {  },
              ),
            ),
            Card(
              child: ListTile(
                title: Text(DumbData.itemSources[0].itemMeta.data!.name),
                subtitle: Text('RM${DumbData.itemSources[0].unitPrice} per unit'),
                trailing: const Text('300'),
              ),
            )
          ],
        ),
      ),
      persistentFooterButtons: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
            onPressed: () {},
            child: const Text('Split Item')
        ),
      ],
    );
  }
}