import 'package:flutter/material.dart';
import 'package:supermarket_management/dumb.dart';
import 'package:supermarket_management/model/entity/item_meta.dart';
import 'package:supermarket_management/model/model.dart';

class ItemSupplyPanel extends StatefulWidget {
  final ItemMeta itemMeta;
  const ItemSupplyPanel({super.key, required this.itemMeta});

  @override
  State<ItemSupplyPanel> createState() => _ItemSupplyPanelState();
}

class _ItemSupplyPanelState extends State<ItemSupplyPanel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.inventory),
                ),
                Container(width: 24),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${widget.itemMeta.name}'),
                    Text("Purchasing Price: RM 12"),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Divider(indent: 8, endIndent: 8),
      ],
    );
  }
}