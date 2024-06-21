import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:supermarket_management/api/error_response.dart';
import 'package:supermarket_management/model/entity/item_meta.dart';
import 'package:supermarket_management/model/entity/item_stock_data.dart';
import 'package:supermarket_management/model/entity/order.dart';
import 'package:supermarket_management/model/entity/stock_location.dart';
import 'package:supermarket_management/module/home/action/home_action.dart';
import 'package:supermarket_management/module/inventory/ui/product_details_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? currentShiftStatus;
  List<ItemMeta>? underStockItems;
  List<Order>? deliveringOrders;
  List<ItemStockData>? invalidStocks;
  List<ItemStockData>? lowStocks;
  List<StockLocation>? locations;

  void fetch() async {
    HomeAction.of(context).fetchShift().then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        currentShiftStatus = response['data'];
      });
    });

    HomeAction.of(context).fetchUnderStock().then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        underStockItems = (response['data'] as List).map((e) => ItemMeta.fromMap(e)).toList();
      });
    });

    HomeAction.of(context).fetchStockLocationSummary().then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        locations = (response['data']['locations'] as List).map((e) => StockLocation.fromMap(e)).toList();
        lowStocks = (response['data']['await_restock'] as List).map((e) => ItemStockData.fromMap(e)).toList();
        invalidStocks = (response['data']['invalid'] as List).map((e) => ItemStockData.fromMap(e)).toList();
      });
    });

    HomeAction.of(context).fetchDeliveringOrders().then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        deliveringOrders = (response['data'] as List).map((e) => Order.fromMap(e)).toList();
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Home'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          currentShiftStatus != null && currentShiftStatus == 'not record' ?
          Card(
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
                    title: const Text('Shift Start Not Recorded Yet'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ) : Container(),
          Card(
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
                    title: Text('Products have Low Stock Number'),
                  ),
                  const Divider(indent: 8, endIndent: 8),
                  ...underStockItems != null ? underStockItems!.map((e) => ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.inventory),
                    ),
                    title: Text(e.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ProductDetailsPage(id: e.id!))
                            );
                          },
                          icon: const Icon(Icons.arrow_forward)
                        )
                      ],
                    ),
                  )).toList() : []
                ],
              ),
            ),
          ),
          Card(
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
                    title: Text('Location have Low Stock Number'),
                  ),
                  const Divider(indent: 8, endIndent: 8),
                  ...(lowStocks != null && locations != null) ? locations!.map((e) {
                    final stocks = lowStocks!.where((element) => element.stockLocation.data!.id == e.id).toList();

                    if (stocks.isEmpty) {
                      return [];
                    }

                    return [
                      ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.inventory),
                        ),
                        title: Text(e.name),
                        // trailing: Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     IconButton(
                        //         onPressed: () {
                        //           Navigator.of(context).push(
                        //               MaterialPageRoute(builder: (context) => ProductDetailsPage(id: e.id!))
                        //           );
                        //         },
                        //         icon: const Icon(Icons.arrow_forward)
                        //     )
                        //   ],
                        // ),
                      ),
                      ...stocks.map((stock) => ListTile(
                        title: Text(stock.itemMeta.data!.name),
                      )).toList(),
                    ];
                  }).toList().flattened.toList() : []
                ],
              ),
            ),
          ),
          Card(
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
                    title: Text('Location have Invalid Stock Number'),
                  ),
                  const Divider(indent: 8, endIndent: 8),
                  ...(invalidStocks != null && locations != null) ? locations!.map((e) {
                    final stocks = invalidStocks!.where((element) => element.stockLocation.data!.id == e.id).toList();

                    return [
                      ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.inventory),
                        ),
                        title: Text(e.name),
                        // trailing: Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     IconButton(
                        //         onPressed: () {
                        //           Navigator.of(context).push(
                        //               MaterialPageRoute(builder: (context) => ProductDetailsPage(id: e.id!))
                        //           );
                        //         },
                        //         icon: const Icon(Icons.arrow_forward)
                        //     )
                        //   ],
                        // ),
                      ),
                      ...stocks.map((stock) => ListTile(
                        title: Text(stock.itemMeta.data!.name),
                        trailing: Text(stock.quantity.toString()),
                      )).toList(),
                    ];
                  }).toList().flattened.toList() : []
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.amberAccent,
                      child: Icon(Icons.warning_amber, color: Colors.black87),
                    ),
                    title: Text('Delivering Order'),
                  ),
                  const Divider(indent: 8, endIndent: 8),
                  ...deliveringOrders != null ? deliveringOrders!.map((e) => ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.inventory),
                    ),
                    title: Text(e.referenceCode),
                    subtitle: Text(e.supplier.data!.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => ProductDetailsPage(id: e.id!))
                              );
                            },
                            icon: const Icon(Icons.arrow_forward)
                        )
                      ],
                    ),
                  )).toList() : []
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}