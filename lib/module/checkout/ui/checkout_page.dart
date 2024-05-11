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
            const Padding(padding: EdgeInsets.all(16)),
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Customer'
              ),
            ),
            const Padding(padding: EdgeInsets.all(8)),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    decoration: const InputDecoration(
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
                  const Text('Item(s)'),
                  const Padding(padding: EdgeInsets.all(2)),
                  Card(child: ListTile(title: Text(DumbData.itemMetas[0].name), subtitle: Text(DumbData.itemMetas[0].universalProductCode), trailing: const Text('1'))),
                  Card(child: ListTile(title: Text(DumbData.itemMetas[1].name), subtitle: Text(DumbData.itemMetas[1].universalProductCode), trailing: const Text('1') )),
                  Card(child: ListTile(title: Text(DumbData.itemMetas[2].name), subtitle: Text(DumbData.itemMetas[2].universalProductCode), trailing: const Text('3'))),
                  Card(child: ListTile(title: Text(DumbData.itemMetas[3].name), subtitle: Text(DumbData.itemMetas[3].universalProductCode), trailing: const Text('1'))),
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