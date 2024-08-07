import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:MarketEase/api/error_response.dart';
import 'package:MarketEase/helper.dart';
import 'package:MarketEase/model/entity/brand.dart';
import 'package:MarketEase/model/entity/category.dart';
import 'package:MarketEase/model/entity/item_meta.dart';
import 'package:MarketEase/model/entity/item_source.dart';
import 'package:MarketEase/model/entity/stock_location.dart';
import 'package:MarketEase/module/inventory/action/inventory.action.dart';
import 'package:MarketEase/module/inventory/ui/create_supply_page.dart';

class ProductDetailsPage extends StatefulWidget {
  final int id;

  const ProductDetailsPage({super.key, required this.id});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int currentPageIndex = 0;

  ItemMeta? item;

  void fetch() async {
    InventoryAction.of(context).fetchItem(id: widget.id).then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        item = ItemMeta.fromMap(response['data']);
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
        title: const Text('Item Detail'),
      ),
      body: item != null ? [
        ItemStockPanel(itemMeta: item!),
        ItemDetailPanel(itemMeta: item!),
        ItemSalesPanel(itemMeta: item!),
        ItemSupplyPanel(itemMeta: item!),
      ][currentPageIndex] : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.inventory),
              label: 'Stock'
          ),
          NavigationDestination(
              icon: Icon(Icons.list),
              label: 'Detail'
          ),
          NavigationDestination(
              icon: Icon(Icons.shopping_cart),
              label: 'Sales'
          ),
          NavigationDestination(
              icon: Icon(Icons.local_shipping),
              label: 'Supply'
          ),
        ],
      ),
    );
  }
}

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
  List<StockLocation>? locationDropdown;

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

    InventoryAction.of(context).fetchLocations().then((response) {
      if (response is ErrorResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message))
        );

        return;
      }

      setState(() {
        locationDropdown = (response['data'] as List).map((item) => StockLocation.fromMap(item)).toList();
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

  void onSubmit({name, upc, sku, brand, category, price, location}) {
    InventoryAction.of(context).editItem(
        id: widget.itemMeta.id, name: name, upc: upc, sku: sku, brand: brand,
        category: category, price: price, location: location
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
      ) : ItemDetailForm(itemMeta: widget.itemMeta, brandDropdown: brandDropdown!, categoryDropdown: categoryDropdown!, locationDropdown: locationDropdown!, onCancelClick: onCancelClick, onSubmit: onSubmit),
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
  final List<StockLocation> locationDropdown;
  final Function onCancelClick;
  final Function onSubmit;

  const ItemDetailForm({
    super.key, required this.itemMeta, required this.brandDropdown,
    required this.categoryDropdown, required this.onCancelClick,
    required this.onSubmit, required this.locationDropdown
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
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
              child: Text('Sales Information'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: FormBuilderTextField(
                inputFormatters: [CurrencyTextInputFormatter.currency(symbol: '\$')],
                  decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Unit Price'
                ),
                initialValue: '\$ ${widget.itemMeta.saleData!.price.toStringAsFixed(2)}',
                name: 'unit_price'
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: FormBuilderDropdown(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Default Receive Location',
                ),
                name: 'stock_receive_location',
                initialValue: widget.itemMeta.receive,
                items: widget.locationDropdown.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
              ),
            ),
            FormBuilderDropdown(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Default Stock Out Location',
              ),
              name: 'stock_out_location',
              initialValue: widget.itemMeta.saleData!.defaultStockOutLocation?.id,
              items: widget.locationDropdown.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
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
              final price = double.parse(_formKey.currentState!.value['unit_price'].toString().split('\$')[1]);
              final location = _formKey.currentState?.value['stock_out_location'];

              widget.onSubmit(name: name, upc: upc, sku: sku, brand: brand, category: category, price: price, location: location);
            },
            child: const Text('Create')
        ),
      ],
    );
  }
}

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
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${widget.itemMeta.name}'),
                      Text('Selling Price: ${Helper.getCurrencyString(widget.itemMeta.saleData!.price)}'),
                      Text('Stock Out Location: ${widget.itemMeta.saleData!.defaultStockOutLocation?.data!.name ?? '-'}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(indent: 8, endIndent: 8),
        Expanded(
          child: ListView(
            children: widget.itemMeta.saleData!.checkoutItems!.map((e) => ListTile(
              title: Text(e.checkout.data!.referenceCode),
              subtitle: Text('${Helper.getCurrencyString(e.itemSaleData.data!.price)} per unit'),
              trailing: Text(e.quantity.toString()),
            )).toList(),
          )
        )
      ],
    );
  }
}

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
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${widget.itemMeta.name}'),
                      Text("Category: ${widget.itemMeta.category?.data?.name ?? '-'}"),
                      Text("Brand/Origin: ${widget.itemMeta.brand?.data?.name ?? '-'}"),
                    ],
                  ),
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

class ItemSupplyPanel extends StatefulWidget {
  final ItemMeta itemMeta;
  const ItemSupplyPanel({super.key, required this.itemMeta});

  @override
  State<ItemSupplyPanel> createState() => _ItemSupplyPanelState();
}

class _ItemSupplyPanelState extends State<ItemSupplyPanel> {
  final formKey = GlobalKey<FormBuilderState>();

  void onSourceClick(ItemSource source) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set as supply'),
          actions: <Widget>[
            TextButton(
              child: const Text('No', style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context)..pop()..push(
                  MaterialPageRoute(builder: (context) => CreateSupplyPage(itemMeta: widget.itemMeta, itemSource: source))
                );
              },
            ),
          ],
        );
      },
    );
  }

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
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${widget.itemMeta.name}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(indent: 8, endIndent: 8),
        Expanded(
          child: FormBuilder(
            key: formKey,
            child: ListView(
              children: widget.itemMeta.sources!.map((e) {
                final isSelected = widget.itemMeta.supply != null && widget.itemMeta.supply!.data!.itemSource.id == e.id;

                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(1.0),
                    child: isSelected ? const Icon(
                      Icons.radio_button_checked,
                      size: 18.0,
                      color: Colors.blue,
                    ) : const Icon(
                      Icons.radio_button_unchecked,
                      size: 18.0,
                      color: Colors.grey,
                    ),
                  ),
                  title: Text(e.supplier.data!.name),
                  subtitle: Text('${Helper.getCurrencyString(e.unitPrice)} per unit, ${e.minOrderQuantity} minimum'),
                  trailing: Text('${e.estimatedLeadTime} day(s)'),
                  onTap: () => onSourceClick(e),
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }
}