import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supermarket_management/api/error_response.dart';
import 'package:supermarket_management/model/entity/stock_transaction_log.dart';
import 'package:supermarket_management/module/report/action/report_action.dart';

class InventoryReportPage extends StatefulWidget {
  const InventoryReportPage({super.key});

  @override
  State<InventoryReportPage> createState() => _InventoryReportPageState();
}

class _InventoryReportPageState extends State<InventoryReportPage> {
  int? stockInCount, stockOutCount, orderCount, checkoutCount;
  List<StockTransactionLog>? logs;

  void fetch() async {
    ReportAction.of(context).fetchStockFlowSummary().then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        stockInCount = response['data']['stockInNum'];
        stockOutCount = response['data']['stockOutNum'];
        orderCount = response['data']['orderNum'];
        checkoutCount = response['data']['checkoutNum'];
      });
    });

    ReportAction.of(context).fetchStockFlowLog().then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        logs = (response['data'] as List).map((e) => StockTransactionLog.fromMap(e)).toList();
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
  // Stock in this month
  // Stock out this month
  // Stock reach restocking point
  // Under stock prediction
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Report'),
      ),
      body: ListView(
        children: [
          stockInCount != null ?
          StockFlowCard(
            stockInCount: stockInCount!,
            stockOutCount: stockOutCount!,
            orderCount: orderCount!,
            checkoutCount: checkoutCount!
          ) : Container(),
          logs != null ?
          StockTransactionLogCard(logs: logs!) : Container(),
          // UnderStockCard(),
        ],
      )
    );
  }
}

class StockFlowCard extends StatelessWidget {
  final int stockInCount, stockOutCount, orderCount, checkoutCount;

  const StockFlowCard({super.key, required this.stockInCount, required this.stockOutCount, required this.orderCount, required this.checkoutCount});

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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stockInCount.toString(), style: const TextStyle(color: Colors.greenAccent, fontSize: 18)),
                        const Text('Stock In Quantity'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(stockOutCount.toString(), style: const TextStyle(color: Colors.redAccent, fontSize: 18)),
                        const Text('Stock Out Quantity'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(orderCount.toString(), style: const TextStyle(color: Colors.greenAccent, fontSize: 18)),
                        const Text('Order Created'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(checkoutCount.toString(), style: const TextStyle(color: Colors.redAccent, fontSize: 18)),
                        const Text('Checkout Created'),
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

class StockTransactionLogCard extends StatelessWidget {
  final List<StockTransactionLog> logs;

  const StockTransactionLogCard({super.key, required this.logs});

  buildIcon(StockTransactionLog log) {
    switch (log.type) {
      case StockTransactionType.stockIn:
        return const Icon(Icons.inbox);
      case StockTransactionType.stockOut:
        return const Icon(Icons.outbox);
      case StockTransactionType.transfer:
        return const Icon(Icons.move_down);
      case StockTransactionType.split:
        return const Icon(Icons.call_split);
      case StockTransactionType.orderStockIn:
      // TODO: Handle this case.
      case StockTransactionType.checkoutStockOut:
      // TODO: Handle this case.
    }
  }

  buildSubtitle(StockTransactionLog log) {
    switch (log.type) {
      case StockTransactionType.stockIn:
        return Text('${log.stockInItem!.name} x ${log.stockInQuantity} to ${log.stockInLocation!.name}\nAt ${DateFormat('MMM d, y HH:mm').format(log.createdAt)}\nBy ${log.user!.username}');
      case StockTransactionType.stockOut:
        return Text('${log.stockOutItem!.name} x ${log.stockOutItem} from ${log.stockOutLocation!.name}\nAt ${DateFormat('MMM d, y HH:mm').format(log.createdAt)}\nBy ${log.user!.username}');
      case StockTransactionType.transfer:
        return Text('${log.stockInItem!.name} x ${log.stockInQuantity} from ${log.stockOutLocation!.name} to ${log.stockInLocation!.name}\nAt ${DateFormat('MMM d, y HH:mm').format(log.createdAt)}\nBy ${log.user!.username}');
      case StockTransactionType.split:
        return Text('${log.stockOutItem!.name} x ${log.stockOutQuantity} split to ${log.stockInItem!.name} x ${log.stockInQuantity} at ${log.stockOutLocation!.name}\nAt ${DateFormat('MMM d, y HH:mm').format(log.createdAt)}\nBy ${log.user!.username}');
      case StockTransactionType.orderStockIn:
        // TODO: Handle this case.
      case StockTransactionType.checkoutStockOut:
        // TODO: Handle this case.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                child: Text('Transaction Log', style: TextStyle(fontSize: 18)),
              )
            ),
            const Divider(indent: 8, endIndent: 8),
            ...logs.take(10).map((log) => ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                child: buildIcon(log),
              ),
              title: Text(log.type.label),
              subtitle: buildSubtitle(log),
            )).toList(),
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
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.warning_amber),
              ),
              title: Text('Products In Low Stock Number'),
            ),
            const Divider(indent: 8, endIndent: 8),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.inventory),
              ),
              title: const Text('DumbData.itemMetas[2].name'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward))
                ],
              ),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.inventory),
              ),
              title: const Text('DumbData.itemMetas[3].name'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward))
                ],
              ),
            ),
            const Divider(),
            const ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.warning_amber),
              ),
              title: Text('Products Approaching Low Stock Number'),
            ),
            const Divider(indent: 8, endIndent: 8),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.inventory),
              ),
              title: const Text('DumbData.itemMetas[1].name'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward))
                ],
              ),
              subtitle: const Text('Understock in 3 days'),
            ),
          ],
        ),
      ),
    );
  }

}

