import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:supermarket_management/api/error_response.dart';
import 'package:supermarket_management/model/entity/brand.dart';
import 'package:supermarket_management/model/entity/category.dart';
import 'package:supermarket_management/model/entity/item_meta.dart';
import 'package:supermarket_management/module/inventory/action/inventory.action.dart';

class ItemDetailPanel extends StatefulWidget {
  final ItemMeta itemMeta;
  const ItemDetailPanel({super.key, required this.itemMeta});

  @override
  State<ItemDetailPanel> createState() => _ItemDetailPanelState();
}

class _ItemDetailPanelState extends State<ItemDetailPanel> {
  bool editing = false;

  List<Brand>? brandDropdown;
  List<Category>? categoryDropdown;

  void fetch() async {
    InventoryAction.of(context).fetchBrandDropdown().then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        brandDropdown = (response['data'] as List).map((item) => Brand.fromMap(item)).toList();
      });
    });

    InventoryAction.of(context).fetchCategoriesDropdown().then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        categoryDropdown = (response['data'] as List).map((item) => Category.fromMap(item)).toList();
      });
    });
  }

  void onEditClick() {
    setState(() {
      editing = true;
    });
  }

  void onCancelClick() {
    setState(() {
      editing = false;
    });
  }

  void onSubmit({name, upc, sku, brand, category}) {
    InventoryAction.of(context).editItem(
        id: widget.itemMeta.id, name: name, upc: upc, sku: sku, brand: brand,
        category: category
    ).then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item Updated Successfully'))
      );

      Navigator.of(context).pop();
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
      body: !editing ? ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
            child: Text('Item Information'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
            child: TextFormField(
              readOnly: !editing,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Item Name'
              ),
              initialValue: widget.itemMeta.name,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
            child: TextFormField(
              readOnly: !editing,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Stock Keeping Unit'
              ),
              initialValue: widget.itemMeta.stockKeepingUnit,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
            child: TextFormField(
              readOnly: !editing,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Universal Product Code'
              ),
              initialValue: widget.itemMeta.universalProductCode,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
            child: TextFormField(
              readOnly: !editing,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Brand',
              ),
              initialValue: widget.itemMeta.brand?.data?.name,
            ),
          ),
          TextFormField(
            readOnly: !editing,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Category',
            ),
            initialValue: widget.itemMeta.category?.data?.name,
          ),
        ],
      ) : ItemDetailForm(itemMeta: widget.itemMeta, brandDropdown: brandDropdown!, categoryDropdown: categoryDropdown!, onCancelClick: onCancelClick, onSubmit: onSubmit),
      floatingActionButton: editing ? null : FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () => onEditClick(),
      ),
    );
  }
}

class ItemDetailForm extends StatefulWidget {
  final ItemMeta itemMeta;
  final List<Brand> brandDropdown;
  final List<Category> categoryDropdown;
  final Function onCancelClick;
  final Function onSubmit;

  const ItemDetailForm({
    super.key, required this.itemMeta, required this.brandDropdown,
    required this.categoryDropdown, required this.onCancelClick,
    required this.onSubmit
  });

  @override
  State<ItemDetailForm> createState() => _ItemDetailFormState();
}

class _ItemDetailFormState extends State<ItemDetailForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormBuilder(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: Text('Item Information'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: FormBuilderTextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Item Name'
                ),
                initialValue: widget.itemMeta.name,
                name: 'name',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: FormBuilderTextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Stock Keeping Unit'
                ),
                initialValue: widget.itemMeta.stockKeepingUnit,
                name: 'sku',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: FormBuilderTextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Universal Product Code'
                ),
                initialValue: widget.itemMeta.universalProductCode,
                name: 'upc',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: FormBuilderDropdown(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Brand',
                ),
                initialValue: widget.itemMeta.brand?.data?.id,
                name: 'brand',
                items: widget.brandDropdown.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
              ),
            ),
            FormBuilderDropdown(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Category',
              ),
              name: 'category',
              initialValue: widget.itemMeta.category?.data?.id,
              items: widget.categoryDropdown.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            widget.onCancelClick();
          },
        ),
        TextButton(
            onPressed: () {
              _formKey.currentState!.save();

              final name = _formKey.currentState?.value['name'];
              final upc = _formKey.currentState?.value['upc'];
              final sku = _formKey.currentState?.value['sku'];
              final brand = _formKey.currentState?.value['brand'];
              final category = _formKey.currentState?.value['category'];

              widget.onSubmit(name: name, upc: upc, sku: sku, brand: brand, category: category);
            },
            child: const Text('Create')
        ),
      ],
    );
  }
}