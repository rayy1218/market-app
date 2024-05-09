import 'package:flutter/material.dart';
import 'package:supermarket_management/dumb.dart';
import 'package:supermarket_management/model/model.dart';

import '../../../model/entity/item_meta.dart';

class ItemDetailPanel extends StatefulWidget {
  final ItemMeta itemMeta;
  const ItemDetailPanel({super.key, required this.itemMeta});

  @override
  State<ItemDetailPanel> createState() => _ItemDetailPanelState();
}

class _ItemDetailPanelState extends State<ItemDetailPanel> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
          child: Text('Item Information'),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
          child: TextFormField(
            readOnly: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Item Name'
            ),
            initialValue: widget.itemMeta.name,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
          child: TextFormField(
            readOnly: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Stock Keeping Unit'
            ),
            initialValue: widget.itemMeta.stockKeepingUnit,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
          child: TextFormField(
            readOnly: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Universal Product Code'
            ),
            initialValue: widget.itemMeta.universalProductCode,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
          child: TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Brand',
            ),
            initialValue: widget.itemMeta.brand?.data?.name,
          ),
        ),
        TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Category',
          ),
          initialValue: widget.itemMeta.category?.data?.name,
        ),
      ],
    );
  }
}