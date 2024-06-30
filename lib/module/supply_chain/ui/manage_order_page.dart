import 'package:flutter/material.dart';
import 'package:MarketEase/api/error_response.dart';
import 'package:intl/intl.dart';
import 'package:MarketEase/model/entity/order.dart';
import 'package:MarketEase/module/supply_chain/action/supply.action.dart';
import 'package:MarketEase/module/supply_chain/ui/order_detail_page.dart';

class ManageOrderPage extends StatefulWidget {
  const ManageOrderPage({super.key});

  @override
  State<ManageOrderPage> createState() => _ManageOrderPageState();
}

class _ManageOrderPageState extends State<ManageOrderPage> {
  List<Order>? entries;

  void fetch() async {
    SupplyAction.of(context).fetchOrders().then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        entries = (response['data'] as List).map((item) => Order.fromMap(item)).toList();
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
    return entries != null ? ListView(
      children: entries!.map((e) => ListTile(
        title: Text('${e.supplier.data!.name} at ${DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(e.timestamp)}'),
        subtitle: Text(e.status.label),
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => OrderDetailPage(id: e.id!))
          ).then((_) {
            setState(() {
              entries = null;
            });

            fetch();
          });
        },
      )).toList(),
    ) : const Center(child: CircularProgressIndicator());
  }
}