import 'package:flutter/material.dart';
import 'package:supermarket_management/dumb.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.all(16)),
            TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Customer'
              ),
            ),
            Padding(padding: const EdgeInsets.all(8)),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Stock Item Code/Barcode'
                    ),
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code)),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  Text('Item(s)'),
                  Padding(padding: const EdgeInsets.all(2)),
                  Card(child: ListTile(title: Text(DumbData.itemMetas[0].name), subtitle: Text(DumbData.itemMetas[0].universalProductCode), trailing: Text('1'))),
                  Card(child: ListTile(title: Text(DumbData.itemMetas[1].name), subtitle: Text(DumbData.itemMetas[1].universalProductCode), trailing: Text('1') )),
                  Card(child: ListTile(title: Text(DumbData.itemMetas[2].name), subtitle: Text(DumbData.itemMetas[2].universalProductCode), trailing: Text('3'))),
                  Card(child: ListTile(title: Text(DumbData.itemMetas[3].name), subtitle: Text(DumbData.itemMetas[3].universalProductCode), trailing: Text('1'))),
                ],
              ),
            ),
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
        TextButton(onPressed: () {}, child: const Text('Stock Out Stock Item(s)')),
      ],
    );
  }
}