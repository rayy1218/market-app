import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supermarket_management/api/error_response.dart';
import 'package:supermarket_management/model/entity/supplier.dart';
import 'package:supermarket_management/module/supply_chain/action/supply.action.dart';
import 'package:supermarket_management/module/supply_chain/ui/create_order_page.dart';
import 'package:supermarket_management/module/supply_chain/ui/create_source_page.dart';
import 'package:supermarket_management/module/supply_chain/ui/edit_source_page.dart';
import 'package:supermarket_management/module/supply_chain/ui/supplier_profile_edit_page.dart';

class SupplierDetailPage extends StatefulWidget {
  final int id;

  const SupplierDetailPage({super.key, required this.id});

  @override
  State<SupplierDetailPage> createState() => _SupplierDetailPageState();
}

class _SupplierDetailPageState extends State<SupplierDetailPage> {
  Supplier? entry;

  void fetch() async {
    SupplyAction.of(context).fetchSupplier(id: widget.id).then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        entry = Supplier.fromMap(response['data']);
      });
    });
  }

  void refresh() {
    setState(() {
      entry = null;
    });

    fetch();
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Supplier Details'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Profile'),
              Tab(text: 'Source'),
              Tab(text: 'Order'),
            ],
          ),
        ),
        body: entry != null ? TabBarView(
          children: [
            SupplierProfileTab(supplier: entry!, refresh: refresh),
            SupplierSourceTab(supplier: entry!, refresh: refresh),
            SupplierOrderTab(supplier: entry!, refresh: refresh),
          ],
        ) : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class SupplierProfileTab extends StatelessWidget {
  final Supplier supplier;
  final Function refresh;
  const SupplierProfileTab({super.key, required this.supplier, required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text('Profile'),
                  ),
                  const Divider(indent: 8, endIndent: 8),
                  ListTile(
                    title: const Text('Name'),
                    subtitle: Text(supplier.name),
                  ),
                  ListTile(
                    title: const Text('Phone Number'),
                    subtitle: Text(supplier.phone),
                  ),
                  ListTile(
                    title: const Text('Email Address'),
                    subtitle: Text(supplier.email),
                  ),
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
                      child: Icon(Icons.location_on),
                    ),
                    title: Text('Address'),
                  ),
                  const Divider(indent: 8, endIndent: 8),
                  ListTile(
                    title: const Text('Line 1'),
                    subtitle: Text(supplier.address!.line1 ?? ''),
                  ),
                  ListTile(
                    title: const Text('Line 2'),
                    subtitle: Text(supplier.address!.line2 ?? ''),
                  ),
                  ListTile(
                    title: const Text('City'),
                    subtitle: Text(supplier.address!.city ?? ''),
                  ),
                  ListTile(
                    title: const Text('State'),
                    subtitle: Text(supplier.address!.state ?? ''),
                  ),
                  ListTile(
                    title: const Text('Zipcode'),
                    subtitle: Text(supplier.address!.postcode ?? ''),
                  ),
                  ListTile(
                    title: const Text('Country'),
                    subtitle: Text(supplier.address!.country ?? ''),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SupplierProfileEditPage(supplier: supplier))
          ).then((_) {
            refresh();
          });
        },
      ),
    );
  }
}

class SupplierSourceTab extends StatelessWidget {
  final Supplier supplier;
  final Function refresh;
  const SupplierSourceTab({super.key, required this.supplier, required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: supplier.sources!.isNotEmpty ? ListView(
        children: supplier.sources!.map((e) => ListTile(
          title: Text(e.itemMeta.data!.name),
          subtitle: Text('\$${e.unitPrice} per unit, ${e.minOrderQuantity} minimum'),
          trailing: Text('${e.estimatedLeadTime} day(s)'),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditSourcePage(itemSource: e, supplier: supplier))
            ).then((_) {
              refresh();
            });
          },
        )).toList(),
      ) : const Center(child: Text('Empty')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CreateSourcePage(supplier: supplier))
          ).then((_) {
            refresh();
          });
        },
      ),
    );
  }
}

class SupplierOrderTab extends StatelessWidget {
  final Supplier supplier;
  final Function refresh;
  const SupplierOrderTab({super.key, required this.supplier, required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: supplier.orders!.isNotEmpty ? ListView(
        children:  supplier.orders!.map((e) => ListTile(
          title: Text(DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(e.timestamp)),
          subtitle: Text(e.status.label),
        )).toList(),
      ) : const Center(child: Text('Empty')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CreateOrderPage(supplierId: supplier.id!))
          ).then((_) {
            refresh();
          });
        },
      ),
    );
  }
}