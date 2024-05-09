import 'package:flutter/material.dart';
import 'package:supermarket_management/model/entity/item_meta.dart';

class ItemSalesPanel extends StatefulWidget {
  final ItemMeta itemMeta;
  const ItemSalesPanel({super.key, required this.itemMeta});

  @override
  State<ItemSalesPanel> createState() => _ItemSalesPanelState();
}

class _ItemSalesPanelState extends State<ItemSalesPanel> {
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
                    Text("Selling Price: RM 12"),
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