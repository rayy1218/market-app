import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supermarket_management/api/error_response.dart';
import 'package:supermarket_management/model/entity/shift_record.dart';
import 'package:supermarket_management/module/shift/action/shift.action.dart';

class ShiftPage extends StatefulWidget {
  const ShiftPage({super.key});

  @override
  State<ShiftPage> createState() => _ShiftPageState();
}

class _ShiftPageState extends State<ShiftPage> {
  List<ShiftRecord>? entries;
  bool isProcessing = false;

  void fetch() async {
    ShiftAction.of(context).fetchToday().then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        entries = (response['data'] as List).map((item) => ShiftRecord.fromMap(item)).toList();
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
        title: const Text('Shift'),
      ),
      body: entries != null ? Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ListTile(
            leading: const Icon(Icons.punch_clock),
            title: Text(entries!.isEmpty ? 'Shift yet to begin' : entries!.last.type.label),
          ),
          Row(
            children: [
              if (entries!.isNotEmpty && entries!.last.type != ShiftType.clockOut && entries!.last.type != ShiftType.breakStart)
                Expanded(
                    child: TextButton(
                        onPressed: !isProcessing ? () {
                          setState(() {
                            isProcessing = true;
                          });

                          ShiftAction.of(context).create(type: 'start_break').then((response) {
                            if (response is ErrorResponse) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(response.message))
                              );

                              return;
                            }

                            setState(() {
                              entries!.add(ShiftRecord(timestamp: DateTime.now(), type: ShiftType.breakStart));
                              isProcessing = false;
                            });
                          });
                        } : null,
                        child: const Text('Start Break')
                    )
                ),
              if (entries!.isNotEmpty && entries!.last.type == ShiftType.breakStart)
                Expanded(
                    child: TextButton(
                        onPressed: !isProcessing ? () {
                          setState(() {
                            isProcessing = true;
                          });

                          ShiftAction.of(context).create(type: 'end_break').then((response) {
                            if (response is ErrorResponse) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(response.message))
                              );

                              return;
                            }

                            setState(() {
                              entries!.add(ShiftRecord(timestamp: DateTime.now(), type: ShiftType.breakEnd));
                              isProcessing = false;
                            });
                          });
                        } : null,
                        child: const Text('End Break')
                    )
                ),
              if (entries!.isEmpty)
                Expanded(
                  child: TextButton(
                    onPressed: !isProcessing ? () {
                      setState(() {
                        isProcessing = true;
                      });

                      ShiftAction.of(context).create(type: 'start_shift').then((response) {
                        if (response is ErrorResponse) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(response.message))
                          );

                          return;
                        }

                        setState(() {
                          entries!.add(ShiftRecord(timestamp: DateTime.now(), type: ShiftType.clockIn));
                          isProcessing = false;
                        });
                      });
                    } : null,
                    child: const Text('Start Shift')
                  )
                ),
              if (entries!.isNotEmpty && entries!.last.type != ShiftType.clockOut)
                Expanded(
                    child: TextButton(
                        onPressed: !isProcessing ? () {
                          setState(() {
                            isProcessing = true;
                          });

                          ShiftAction.of(context).create(type: 'end_shift').then((response) {
                            if (response is ErrorResponse) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(response.message))
                              );

                              return;
                            }

                            setState(() {
                              entries!.add(ShiftRecord(timestamp: DateTime.now(), type: ShiftType.clockOut));
                              isProcessing = false;
                            });
                          });
                        } : null,
                        child: const Text('End Shift'),

                    )
                ),
            ],
          ),
          Expanded(
            child: ListView(
              children: entries!.reversed.map((e) => ListTile(
                title: Text(e.type.label),
                subtitle: Text(DateFormat('HH:mm').format(e.timestamp))
              )).toList(),
            )
          )
        ],
      ) : const Center(child: CircularProgressIndicator()),
    );
  }
}