import 'package:flutter/material.dart';
import 'package:supermarket_management/dumb.dart';

class SupplyChainReport extends StatefulWidget {
  const SupplyChainReport({super.key});

  @override
  State<SupplyChainReport> createState() => _SupplyChainReportState();
}

class _SupplyChainReportState extends State<SupplyChainReport> {
  @override
  Widget build(BuildContext context) {
    // Order This Month
    // Supplier Performance, Estimated Lead Time vs Actual Created to Received Time
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supply Chain Report'),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SupplyOverviewCard(),
          TopOrderSupplierCard(),
        ],
      ),
    );
  }
}

class SupplyOverviewCard extends StatelessWidget {
  const SupplyOverviewCard({super.key});

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('RM 370.00', style: TextStyle(color: Colors.greenAccent, fontSize: 18)),
                      Text('Restocking Cost'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('7', style: TextStyle(color: Colors.blueAccent, fontSize: 18)),
                      Text('Order Created'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('6', style: TextStyle(color: Colors.redAccent, fontSize: 18)),
                      Text('Order Received'),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TopOrderSupplierCard extends StatefulWidget {
  const TopOrderSupplierCard({super.key});

  @override
  State<TopOrderSupplierCard> createState() => _TopOrderSupplierCardState();
}

class _TopOrderSupplierCardState extends State<TopOrderSupplierCard> {
  bool useValue = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(child: Text('Order Statistic By Supplier', style: TextStyle(fontSize: 18))),
                IconButton(
                  onPressed: () {
                    setState(() {
                      useValue = !useValue;
                    });
                  },
                  icon: Icon(useValue ? Icons.monetization_on : Icons.numbers)
                )
              ],
            ),
            const Divider(),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
              leading: const Text('1', style: TextStyle(fontSize: 14)),
              title: Text(DumbData.suppliers[0].name),
              trailing: Text(useValue ? 'RM 300.00' : '5 Orders'),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
              leading: const Text('2', style: TextStyle(fontSize: 14)),
              title: Text(DumbData.suppliers[1].name),
              trailing: Text(useValue ? 'RM 70.00' : '3 Orders'),
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(child: Text('More Details')),
                IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward_ios)),
              ],
            )
          ],
        ),
      ),
    );
  }
}