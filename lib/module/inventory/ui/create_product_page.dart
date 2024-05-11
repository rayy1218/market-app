import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:supermarket_management/api/error_response.dart';
import 'package:supermarket_management/model/entity/brand.dart';
import 'package:supermarket_management/model/entity/category.dart';
import 'package:supermarket_management/module/inventory/action/inventory.action.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  final brandInputController = TextEditingController();
  final categoryInputController = TextEditingController();

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

  Future onCreateBrandClick(name) async {
    await InventoryAction.of(context).createBrand(name: name).then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        brandInputController.clear();

        return;
      }

      Brand brand = Brand.fromMap(response['data']);

      setState(() {
        brandDropdown?.add(brand);
        brandInputController.clear();
      });
    });
  }

  Future onCreateCategoryClick(name) async {
    await InventoryAction.of(context).createCategory(name: name).then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        categoryInputController.clear();

        return;
      }

      Category category = Category.fromMap(response['data']);

      setState(() {
        categoryDropdown?.add(category);
        categoryInputController.clear();
      });
    });
  }

  void onAddBrandClick() async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Brand'),
          content: TextField(
            controller: brandInputController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Item Name'
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No', style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                final newBrand = brandInputController.value.text;

                onCreateBrandClick(newBrand).then((value) {
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void onAddCategoryClick() async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Category'),
          content: TextField(
            controller: categoryInputController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Item Name'
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No', style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                final newCategory = categoryInputController.value.text;

                onCreateCategoryClick(newCategory).then((value) {
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
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
        title: const Text('Create Item'),
      ),
      body: FormBuilder(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
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
                name : 'name'
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: FormBuilderTextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Stock Keeping Unit'
                ),
                name: 'sku'
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Universal Product Code'
                      ),
                      keyboardType: TextInputType.number,
                      name: 'upc'
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: const Icon(Icons.barcode_reader),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            ),
            brandDropdown != null ?
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: FormBuilderDropdown(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Brand',
                      ),
                      name: 'brand',
                      items: brandDropdown!.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        onAddBrandClick();
                      },
                    ),
                  ),
                ],
              ),
            ) : Container(),
            categoryDropdown != null ?
            Row(
              children: [
                Expanded(
                  child: FormBuilderDropdown(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Category',
                    ),
                    items: categoryDropdown!.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                    name: 'category'
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      onAddCategoryClick();
                    },
                  ),
                ),
              ],
            ) : Container(),
            const Divider(),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: Text('Item Sales Information'),
            ),
            FormBuilderTextField(
              inputFormatters: [CurrencyTextInputFormatter.currency(symbol: '\$')],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Price'
              ),
              keyboardType: TextInputType.number,
              name: 'price'
            ),
          ],
        )
      ),
      persistentFooterButtons: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
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
            final price = double.parse(_formKey.currentState?.value['price'].split('\$')[1]);

            InventoryAction.of(context).createItem(
                name: name, upc: upc, sku: sku, brand: brand, category: category, price: price
            ).then((response) {
              if (response is ErrorResponse) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response.message))
                );

                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Item Created Successfully'))
              );

              Navigator.of(context).pop();
            });
          },
          child: const Text('Create')
        ),
      ],
    );
  }
}