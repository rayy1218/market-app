import 'package:flutter/material.dart';
import 'package:supermarket_management/module/report/ui/inventory_report_page.dart';
import 'package:supermarket_management/module/report/ui/sale_report_page.dart';
import 'package:supermarket_management/module/report/ui/shift_report_page.dart';
import 'package:supermarket_management/module/report/ui/supply_chain_report.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Report'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                leading: Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.blue,
                    shape: CircleBorder(),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.money, color: Colors.white),
                  ),
                ),
                title: const Text('Sales Report'),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SaleReportPage())
                  );
                },
              ),
              ListTile(
                leading: Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.blue,
                    shape: CircleBorder(),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.inventory, color: Colors.white),
                  ),
                ),
                title: const Text('Inventory Report'),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const InventoryReportPage())
                  );
                },
              ),
              ListTile(
                leading: Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.blue,
                    shape: CircleBorder(),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.calendar_month, color: Colors.white),
                  ),
                ),
                title: const Text('Shift and Schedule Report'),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ShiftReportPage())
                  );
                },
              ),
              ListTile(
                leading: Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.blue,
                    shape: CircleBorder(),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.local_shipping, color: Colors.white),
                  ),
                ),
                title: const Text('Supply Chain Report'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SupplyChainReport())
                  );
                },
              ),
            ],
          )
      ),
    );
  }
}