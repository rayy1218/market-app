import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supermarket_management/api/error_response.dart';
import 'package:supermarket_management/model/entity/supplier.dart';
import 'package:supermarket_management/module/report/action/report_action.dart';

class SupplyChainReport extends StatefulWidget {
  const SupplyChainReport({super.key});

  @override
  State<SupplyChainReport> createState() => _SupplyChainReportState();
}

class _SupplyChainReportState extends State<SupplyChainReport> {
  double? cost;
  int? createdCount;
  int? receivedCount;
  List<Supplier>? supplier;

  void fetch() async {
    ReportAction.of(context).fetchOrderSummary().then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        cost = (response['data']['cost'] as int).toDouble();
        createdCount = response['data']['totalCreated'];
        receivedCount = response['data']['totalCompleted'];
        supplier = (response['data']['supplier'] as List).map((item) => Supplier.fromMap(item)).toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Order This Month
    // Supplier Performance, Estimated Lead Time vs Actual Created to Received Time
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supply Chain Report'),
      ),
      body: supplier != null ? ListView(
        children: [
          SupplyOverviewCard(
              cost: cost!,
              createdCount: createdCount!,
              receivedCount: receivedCount!
          ),
          TopOrderSupplierCard(supplier: supplier!),
        ],
      ) : const Center(child: CircularProgressIndicator()),
    );
  }
}

class SupplyOverviewCard extends StatelessWidget {
  final double cost;
  final int createdCount;
  final int receivedCount;

  const SupplyOverviewCard({
    super.key,
    required this.cost,
    required this.createdCount,
    required this.receivedCount
  });

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
            Text(DateFormat('MMM y').format(DateTime.now()), style: TextStyle(fontSize: 18)),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('RM ${cost.toStringAsFixed(2).toString()}', style: const TextStyle(color: Colors.greenAccent, fontSize: 18)),
                      const Text('Restocking Cost'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(createdCount.toString(), style: const TextStyle(color: Colors.blueAccent, fontSize: 18)),
                      const Text('Order Created'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(receivedCount.toString(), style: const TextStyle(color: Colors.redAccent, fontSize: 18)),
                      const Text('Order Received'),
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
  final List<Supplier> supplier;

  const TopOrderSupplierCard({super.key, required this.supplier});

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
            ...widget.supplier.mapIndexed((index, e) => ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
              leading: Text((index + 1).toString(), style: TextStyle(fontSize: 14)),
              title: Text(e.name),
              trailing: Text(useValue ? 'RM ${e.orderCapital!.toStringAsFixed(2)}' : '${e.orderNumber} Orders'),
            )).toList(),
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