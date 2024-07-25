import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:MarketEase/api/error_response.dart';
import 'package:MarketEase/model/entity/item_meta.dart';
import 'package:MarketEase/model/entity/item_stock_data.dart';
import 'package:MarketEase/model/entity/order.dart';
import 'package:MarketEase/model/entity/stock_location.dart';
import 'package:MarketEase/module/home/action/home_action.dart';
import 'package:MarketEase/module/inventory/ui/product_details_page.dart';
import 'package:MarketEase/module/shift/ui/shift_page.dart';
import 'package:MarketEase/module/supply_chain/ui/order_detail_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
        children: const [
          ShiftCard(),
          ProductLowStockCard(),
          // LocationStockCards(),
          DeliveringOrderCard(),
        ],
      ),
    );
  }
}

class ShiftCard extends StatefulWidget {
  const ShiftCard({super.key});

  @override
  State<ShiftCard> createState() => _ShiftCardState();
}

class _ShiftCardState extends State<ShiftCard> {
  String? currentShiftStatus;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetch();
    });
  }

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
  }

  @override
  Widget build(BuildContext context) {
    return currentShiftStatus != null && currentShiftStatus == 'not record' ?
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
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ShiftPage())
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ) : Container();
  }
}

class ProductLowStockCard extends StatefulWidget {
  const ProductLowStockCard({super.key});

  @override
  State<ProductLowStockCard> createState() => _ProductLowStockCardState();
}

class _ProductLowStockCardState extends State<ProductLowStockCard> {
  List<ItemMeta>? underStockItems;

  void fetch() async {
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
    return Card(
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
    );
  }
}

class LocationStockCards extends StatefulWidget {
  const LocationStockCards({super.key});

  @override
  State<LocationStockCards> createState() => _LocationStockCardsState();
}

class _LocationStockCardsState extends State<LocationStockCards> {
  List<ItemStockData>? invalidStocks;
  List<ItemStockData>? lowStocks;
  List<StockLocation>? locations;

  void fetch() async {
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
      ],
    );
  }
}

class DeliveringOrderCard extends StatefulWidget {
  const DeliveringOrderCard({super.key});

  @override
  State<DeliveringOrderCard> createState() => _DeliveringOrderCardState();
}

class _DeliveringOrderCardState extends State<DeliveringOrderCard> {
  List<Order>? deliveringOrders;

  void fetch() async {
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
    return Card(
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
                            MaterialPageRoute(builder: (context) => OrderDetailPage(id: e.id!))
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
    );
  }
}