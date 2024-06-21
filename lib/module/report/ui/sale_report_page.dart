import 'package:flutter/material.dart';

class SaleReportPage extends StatefulWidget {
  const SaleReportPage({super.key});

  @override
  State<SaleReportPage> createState() => _SaleReportPageState();
}

class _SaleReportPageState extends State<SaleReportPage> {
  @override
  Widget build(BuildContext context) {
    // Sale item quantity and value
    // Overall sales and by product
    // Revenue this month
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Report'),
      ),
      body: ListView(
        children: const [
          RevenueCard(),
          TotalCheckoutCard(),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: MostProductiveItemCard(),
              ),
              Expanded(
                child: HottestItemCard(),
              ),
            ],
          )
        ],
      )
    );
  }
}

class RevenueCard extends StatelessWidget {
  const RevenueCard({super.key});

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
                      Text('RM 529.99', style: TextStyle(color: Colors.greenAccent, fontSize: 18)),
                      Text('Income'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('RM 159.99', style: TextStyle(color: Colors.blueAccent, fontSize: 18)),
                      Text('Net Revenue'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('RM 370.00', style: TextStyle(color: Colors.redAccent, fontSize: 18)),
                      Text('Restocking Cost'),
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

class TotalCheckoutCard extends StatelessWidget {
  const TotalCheckoutCard({super.key});

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
            const ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              title: Text('Total Checkout Count', style: TextStyle(fontSize: 18)),
              trailing: Text('78', style: TextStyle(fontSize: 18)),
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

class MostProductiveItemCard extends StatelessWidget {
  const MostProductiveItemCard({super.key});

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
            const Text('Most Productive Item', style: TextStyle(fontSize: 18)),
            const ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              title: Text('DumbData.itemMetas[0].name'),
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.inventory),
              ),
              subtitle: Text('RM 399 Produced'),
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

class HottestItemCard extends StatelessWidget {
  const HottestItemCard({super.key});

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
            const Text('Highest Sales Item', style: TextStyle(fontSize: 18)),
            const ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              title: Text('DumbData.itemMetas[1].name'),
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.inventory),
              ),
              subtitle: Text('38 Sold'),
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