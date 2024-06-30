import 'package:flutter/material.dart';
import 'package:MarketEase/api/error_response.dart';
import 'package:MarketEase/model/entity/supplier.dart';
import 'package:MarketEase/module/supply_chain/action/supply.action.dart';
import 'package:MarketEase/module/supply_chain/ui/supplier_detail_page.dart';

class ManageSupplierPage extends StatefulWidget {
  const ManageSupplierPage({super.key});

  @override
  State<ManageSupplierPage> createState() => _ManageSupplierPageState();
}

class _ManageSupplierPageState extends State<ManageSupplierPage> {
  List<Supplier>? entries;

  void fetch() async {
    SupplyAction.of(context).fetchSuppliers().then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        entries = (response['data'] as List).map((item) => Supplier.fromMap(item)).toList();
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
        leading: const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.person),
        ),
        title: Text(e.name),
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SupplierDetailPage(id: e.id!))
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