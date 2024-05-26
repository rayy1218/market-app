import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket_management/api/error_response.dart';
import 'package:supermarket_management/api/general_response.dart';
import 'package:supermarket_management/api/service/inventory_service.dart';
import 'package:supermarket_management/api/service/supply_service.dart';
import 'package:supermarket_management/main.dart';
import 'package:supermarket_management/module/auth/ui/login_page.dart';

class InventoryAction {
  late String token;
  BuildContext context;

  InventoryAction.of(this.context) {
    final bloc = BlocProvider.of<AuthenticationBloc>(context);
    if (bloc is LogoutState) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const LoginPage())
      );
    }
    else {
      token = (bloc.state as LogonState).token;
    }
  }

  Future fetchBrandDropdown() async {
    return InventoryService.of(token).fetchBrandsDropdown().then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return ErrorResponse(message: response.data['message']);

        case ResponseStatus.error:
          return ErrorResponse(message: 'FAILED_SERVER');
      }
    });
  }

  Future createBrand({name}) async {
    return InventoryService.of(token).createBrand(name: name).then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return ErrorResponse(message: response.data['message']);

        case ResponseStatus.error:
          return ErrorResponse(message: 'FAILED_SERVER');
      }
    });
  }

  Future createCategory({name}) async {
    return InventoryService.of(token).createCategory(name: name).then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return ErrorResponse(message: response.data['message']);

        case ResponseStatus.error:
          return ErrorResponse(message: 'FAILED_SERVER');
      }
    });
  }

  Future fetchCategoriesDropdown() async {
    return InventoryService.of(token).fetchCategoriesDropdown().then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return ErrorResponse(message: response.data['message']);

        case ResponseStatus.error:
          return ErrorResponse(message: 'FAILED_SERVER');
      }
    });
  }

  Future createItem({name, upc, sku, brand, category, price}) async {
    return InventoryService.of(token).createItem(name: name, upc: upc, sku: sku, brand: brand, category: category, price: price).then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return ErrorResponse(message: response.data['message']);

        case ResponseStatus.error:
          return ErrorResponse(message: 'FAILED_SERVER');
      }
    });
  }

  Future fetchItems() async {
    return InventoryService.of(token).fetchItems().then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return ErrorResponse(message: response.data['message']);

        case ResponseStatus.error:
          return ErrorResponse(message: 'FAILED_SERVER');
      }
    });
  }

  Future createLocation({name, parent}) async {
    return InventoryService.of(token).createLocation(name: name, parent: parent).then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return ErrorResponse(message: response.data['message']);

        case ResponseStatus.error:
          return ErrorResponse(message: 'FAILED_SERVER');
      }
    });
  }

  Future fetchLocations() async {
    return InventoryService.of(token).fetchLocations().then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return ErrorResponse(message: response.data['message']);

        case ResponseStatus.error:
          return ErrorResponse(message: 'FAILED_SERVER');
      }
    });
  }

  Future fetchInventory() async {
    return InventoryService.of(token).fetchInventory().then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return ErrorResponse(message: response.data['message']);

        case ResponseStatus.error:
          return ErrorResponse(message: 'FAILED_SERVER');
      }
    });
  }

  Future stockIn({product, quantity, location}) async {
    return InventoryService.of(token).stockIn(product: product, quantity: quantity, location: location).then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return ErrorResponse(message: response.data['message']);

        case ResponseStatus.error:
          return ErrorResponse(message: 'FAILED_SERVER');
      }
    });
  }

  Future fetchItemsOnLocation({locationId}) async {
    return InventoryService.of(token).fetchItemsOnLocation(locationId: locationId).then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return ErrorResponse(message: response.data['message']);

        case ResponseStatus.error:
          return ErrorResponse(message: 'FAILED_SERVER');
      }
    });
  }

  Future stockTransfer({itemStockData, quantity, location}) async {
    return InventoryService.of(token).stockTransfer(itemStockData: itemStockData, quantity: quantity, location: location).then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return ErrorResponse(message: response.data['message']);

        case ResponseStatus.error:
          return ErrorResponse(message: 'FAILED_SERVER');
      }
    });
  }

  Future fetchItem({id}) async {
    return InventoryService.of(token).fetchItem(id: id).then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return ErrorResponse(message: response.data['message']);

        case ResponseStatus.error:
          return ErrorResponse(message: 'FAILED_SERVER');
      }
    });
  }

  Future editItem({id, name, upc, sku, brand, category}) async {
    return InventoryService.of(token).editItem(
        id: id, name: name, upc: upc, sku: sku, brand: brand, category: category
    ).then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return ErrorResponse(message: response.data['message']);

        case ResponseStatus.error:
          return ErrorResponse(message: 'FAILED_SERVER');
      }
    });
  }

  Future stockSplit({itemStockData, quantity, outputLocation, outputItem, outputQuantity}) async {
    return InventoryService.of(token).stockSplit(
        itemStockData: itemStockData, quantity: quantity,
        outputLocation: outputLocation, outputItem: outputItem,
        outputQuantity: outputQuantity
    ).then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return ErrorResponse(message: response.data['message']);

        case ResponseStatus.error:
          return ErrorResponse(message: 'FAILED_SERVER');
      }
    });
  }

  Future setSupply({id, sourceId, onLowStockAction, defaultRestockQuantity, restockPoint}) {
    return SupplyService.of(token).setSupply(
      id: id,
      sourceId: sourceId,
      onLowStockAction: onLowStockAction,
      defaultRestockQuantity: defaultRestockQuantity,
      restockPoint: restockPoint,
    ).then((response) {
      switch (response.status) {
        case ResponseStatus.success:
          return response.data;

        case ResponseStatus.rejected:
          return ErrorResponse(message: response.data['message']);

        case ResponseStatus.error:
          return ErrorResponse(message: 'FAILED_SERVER');
      }
    });
  }
}
