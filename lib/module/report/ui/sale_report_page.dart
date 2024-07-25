import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:MarketEase/helper.dart';
import 'package:MarketEase/model/entity/item_meta.dart';
import 'package:MarketEase/module/report/action/report_action.dart';
import 'package:MarketEase/api/error_response.dart';

class SaleReportPage extends StatefulWidget {
  const SaleReportPage({super.key});

  @override
  State<SaleReportPage> createState() => _SaleReportPageState();
}

class _SaleReportPageState extends State<SaleReportPage> {
  double? income, cost;
  int? total;
  List<ItemMeta>? items;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetch();
    });
  }

  void fetch() async {
    ReportAction.of(context).fetchFinanceReport().then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        income = double.parse(response['income'].toString());
        cost = double.parse(response['cost'].toString());
        total = response['totalCheckout'];
        items = (response['items'] as List).map((e) => ItemMeta.fromMap(e)).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sale item quantity and value
    // Overall sales and by product
    // Revenue this month
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Report'),
      ),
      body: income != null ? ListView(
        children: [
          RevenueCard(income: income!, cost: cost!),
          TotalCheckoutCard(total: total!),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: MostProductiveItemCard(items: items!),
              ),
              Expanded(
                child: HottestItemCard(items: items!),
              ),
            ],
          )
        ],
      ) : const Center(child: CircularProgressIndicator())
    );
  }
}

class RevenueCard extends StatelessWidget {
  const RevenueCard({super.key, required this.income, required this.cost});

  final double income, cost;

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
            Text(DateFormat('MMM y').format(DateTime.now()), style: const TextStyle(fontSize: 18)),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(NumberFormat.currency(symbol: '\$').format(income), style: const TextStyle(color: Colors.greenAccent, fontSize: 18)),
                      const Text('Income'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(NumberFormat.currency(symbol: '\$').format(income - cost), style: const TextStyle(color: Colors.blueAccent, fontSize: 18)),
                      const Text('Net Revenue'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(NumberFormat.currency(symbol: '\$').format(cost), style: const TextStyle(color: Colors.redAccent, fontSize: 18)),
                      const Text('Restocking Cost'),
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
  const TotalCheckoutCard({super.key, required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              title: const Text('Total Checkout Count', style: TextStyle(fontSize: 18)),
              trailing: Text('$total', style: const TextStyle(fontSize: 18)),
            ),
            // const Divider(),
            // Row(
            //   children: [
            //     const Expanded(child: Text('More Details')),
            //     IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward_ios)),
            //   ],
            // )
          ],
        ),
      ),
    );
  }

}

class MostProductiveItemCard extends StatelessWidget {
  const MostProductiveItemCard({super.key, required this.items});

  final List<ItemMeta> items;

  @override
  Widget build(BuildContext context) {
    final ItemMeta display = items.reduce((current, next) => current.capital! > next.capital! ? current : next);

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Most Productive Item', style: TextStyle(fontSize: 18)),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              title: Text(display.name),
              leading: const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.inventory),
              ),
              subtitle: Text('${Helper.getCurrencyString(display.capital!)} Produced'),
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(child: Text('More Details')),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => DetailListPage(items: items))
                      );
                    },
                    icon: const Icon(Icons.arrow_forward_ios)
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class HottestItemCard extends StatelessWidget {
  const HottestItemCard({super.key, required this.items});

  final List<ItemMeta> items;

  @override
  Widget build(BuildContext context) {
    final ItemMeta display = items.reduce((current, next) => current.quantity! > next.quantity! ? current : next);

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Highest Sales Item', style: TextStyle(fontSize: 18)),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              title: Text(display.name),
              leading: const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.inventory),
              ),
              subtitle: Text('${display.quantity!} Sold'),
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(child: Text('More Details')),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => DetailListPage(items: items))
                      );
                    },
                    icon: const Icon(Icons.arrow_forward_ios)
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DetailListPage extends StatefulWidget {
  const DetailListPage({super.key, required this.items});

  final List<ItemMeta> items;

  @override
  State<DetailListPage> createState() => _DetailListPageState();
}

class _DetailListPageState extends State<DetailListPage> {
  bool capitalMode = true;

  @override
  Widget build(BuildContext context) {
    List<ItemMeta> itemsByCapital = List.from(widget.items)..sort((a, b) => b.capital!.compareTo(a.capital!));
    List<ItemMeta> itemsByQuantity  = List.from(widget.items)..sort((a, b) => b.quantity!.compareTo(a.quantity!));

    return Scaffold(
      appBar: AppBar(
        actions: [
          capitalMode ? IconButton(
            onPressed: () {
              setState(() {
                capitalMode = false;
              });
            },
            icon: const Icon(Icons.monetization_on),
          ) : IconButton(
            onPressed: () {
              setState(() {
                capitalMode = true;
              });
            },
            icon: const Icon(Icons.numbers),
          ),
        ],
      ),
      body: ListView(
        children: (capitalMode ? itemsByCapital : itemsByQuantity).map((e) => ListTile(
          title: Text(e.name),
          trailing: Text(capitalMode
              ? '${Helper.getCurrencyString(e.capital!)} Produced'
              : '${e.quantity.toString()} Sold'
          ),
        )).toList(),
      ),
    );
  }
}