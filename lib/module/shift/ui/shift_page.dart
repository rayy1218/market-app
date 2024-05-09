import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supermarket_management/model/model.dart';
import 'package:supermarket_management/model/model_or_id.dart';

class ShiftPage extends StatefulWidget {
  const ShiftPage({super.key});

  @override
  State<ShiftPage> createState() => _ShiftPageState();
}

class _ShiftPageState extends State<ShiftPage> {
  List<ShiftRecord> entries = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shift'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ListTile(
            leading: const Icon(Icons.punch_clock),
            title: Text(entries.isEmpty ? 'Shift yet to begin' : entries.last.type.label),
          ),
          Row(
            children: [
              if (entries.isNotEmpty && entries.last.type != ShiftType.clockOut && entries.last.type != ShiftType.breakStart)
                Expanded(
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            entries.add(ShiftRecord(timestamp: DateTime.now(), type: ShiftType.breakStart, user: ModelOrId.id(id: 0)));
                          });
                        },
                        child: const Text('Start Break')
                    )
                ),
              if (entries.isNotEmpty && entries.last.type == ShiftType.breakStart)
                Expanded(
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            entries.add(ShiftRecord(timestamp: DateTime.now(), type: ShiftType.breakEnd, user: ModelOrId.id(id: 0)));
                          });
                        },
                        child: const Text('End Break')
                    )
                ),
              if (entries.isEmpty)
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        entries.add(ShiftRecord(timestamp: DateTime.now(), type: ShiftType.clockIn, user: ModelOrId.id(id: 0)));
                      });
                    },
                    child: const Text('Start Shift')
                  )
                ),
              if (entries.isNotEmpty && entries.last.type != ShiftType.clockOut)
                Expanded(
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            entries.add(ShiftRecord(timestamp: DateTime.now(), type: ShiftType.clockOut, user: ModelOrId.id(id: 0)));
                          });
                        },
                        child: const Text('End Shift')
                    )
                ),
            ],
          ),
          Expanded(
            child: ListView(
              children: entries.reversed.map((e) => ListTile(
                title: Text(e.type.label),
                subtitle: Text(DateFormat("${DateFormat.YEAR_ABBR_MONTH_DAY} HH:MM").format(e.timestamp))
              )).toList(),
            )
          )
        ],
      ),
    );
  }
}