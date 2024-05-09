import 'package:flutter/material.dart';
import 'package:supermarket_management/model/entity/item_meta.dart';

class ItemStockPanel extends StatefulWidget {
  final ItemMeta itemMeta;

  const ItemStockPanel({super.key, required this.itemMeta});

  @override
  State<ItemStockPanel> createState() => _ItemStockPanelState();
}

class _ItemStockPanelState extends State<ItemStockPanel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    Text("Category: ${widget.itemMeta.category?.data?.name ?? '-'}"),
                    Text("Brand/Origin: ${widget.itemMeta.brand?.data?.name ?? '-'}"),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Divider(indent: 8, endIndent: 8),
        Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView(
                children: widget.itemMeta.stocks!.map((e) => Card(
                  child: ListTile(
                    title: Text(e.stockLocation.data!.name),
                    trailing: Text(e.quantity.toString()),
                  ),
                )).toList(),
              ),
            )
        ),
      ],
    );
  }
}