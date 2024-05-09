import 'package:flutter/material.dart';
import 'package:supermarket_management/dumb.dart';

class InventoryReportPage extends StatefulWidget {
  const InventoryReportPage({super.key});

  @override
  State<InventoryReportPage> createState() => _InventoryReportPageState();
}

class _InventoryReportPageState extends State<InventoryReportPage> {
  @override
  // Stock in this month
  // Stock out this month
  // Stock reach restocking point
  // Under stock prediction
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Report'),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StockFlowCard(),
          UnderStockCard(),
        ],
      )
    );
  }
}

class StockFlowCard extends StatelessWidget {
  const StockFlowCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('February 2024', style: TextStyle(fontSize: 18)),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('200', style: TextStyle(color: Colors.greenAccent, fontSize: 18)),
                        Text('Stock In Quantity'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('132', style: TextStyle(color: Colors.redAccent, fontSize: 18)),
                        Text('Stock Out Quantity'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('7', style: TextStyle(color: Colors.greenAccent, fontSize: 18)),
                        Text('Order Created'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('78', style: TextStyle(color: Colors.redAccent, fontSize: 18)),
                        Text('Checkout Created'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UnderStockCard extends StatelessWidget {
  const UnderStockCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
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
            Divider(),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.warning_amber),
              ),
              title: Text("Products Approaching Low Stock Number"),
            ),
            Divider(indent: 8, endIndent: 8),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.inventory),
              ),
              title: Text(DumbData.itemMetas[1].name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.close)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward))
                ],
              ),
              subtitle: Text('Understock in 3 days'),
            ),
          ],
        ),
      ),
    );
  }

}

