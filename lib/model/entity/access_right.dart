import 'package:MarketEase/model/model.dart';

class AccessRight extends Model {
  AccessRight({super.id, super.uuid, required this.name, required this.label});

  AccessRight.fromMap(Map<String, dynamic> data):
        name = data['name'],
        label = data['label'],
        super(id: data['id']);

  String name;
  String label;

  static List<AccessRight> all = [
    AccessRight(name: 'managerial setting', label: 'Access Company Setting'),
    AccessRight(name: 'managerial employee view', label: 'View Employee'),
    AccessRight(name: 'managerial employee edit', label: 'Edit Employee'),
    AccessRight(name: 'managerial group view', label: 'View Group'),
    AccessRight(name: 'managerial group edit', label: 'Edit Group'),
    AccessRight(name: 'managerial group managerial', label: 'Edit Managerial Access Right'),
    AccessRight(name: 'shift view', label: 'View Employee Shift Record'),
    AccessRight(name: 'shift edit', label: 'Record Shift'),
    AccessRight(name: 'inventory view', label: 'View Item Database & Inventory'),
    AccessRight(name: 'inventory item edit', label: 'Edit Item Database'),
    AccessRight(name: 'inventory in', label: 'Stock In'),
    AccessRight(name: 'inventory split', label: 'Stock Splitting'),
    AccessRight(name: 'inventory transfer', label: 'Stock Transfer'),
    AccessRight(name: 'supply supplier view', label: 'View Supplier List'),
    AccessRight(name: 'supply supplier edit', label: 'Edit Supplier List'),
    AccessRight(name: 'supply source edit', label: 'Edit Item Source List'),
    AccessRight(name: 'supply source assign', label: 'Assign Item Supply Source'),
    AccessRight(name: 'supply restock edit', label: 'Edit Auto Restock'),
    AccessRight(name: 'supply order view', label: 'View Order List'),
    AccessRight(name: 'supply order create', label: 'Create Order'),
    AccessRight(name: 'supply order update', label: 'Update Order Status'),
    AccessRight(name: 'supply order cancel', label: 'Cancel Order'),
    AccessRight(name: 'sales price view', label: 'View Item Price List'),
    AccessRight(name: 'sales price edit', label: 'Edit Item Price List'),
    AccessRight(name: 'sales modifier edit', label: 'Edit Item Price Modifier'),
    AccessRight(name: 'sales customer view', label: 'View Customer List'),
    AccessRight(name: 'sales customer edit', label: 'Edit Customer List'),
    AccessRight(name: 'sales checkout', label: 'Checkout'),
    AccessRight(name: 'report glance', label: 'View Task at a Glance'),
    AccessRight(name: 'report sales', label: 'Sales Report'),
    AccessRight(name: 'report inventory', label: 'Inventory Report'),
    AccessRight(name: 'report shift', label: 'Shift Record Report'),
    AccessRight(name: 'report supply', label: 'Supply Chain Report'),
  ];
}