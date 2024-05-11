import 'package:flutter/material.dart';

class ShiftReportPage extends StatefulWidget {
  const ShiftReportPage({super.key});

  @override
  State<ShiftReportPage> createState() => _ShiftReportPageState();
}

class _ShiftReportPageState extends State<ShiftReportPage> {
  @override
  Widget build(BuildContext context) {
    // Show shift hour of each employee this month
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shift Report'),
      ),
    );
  }
}