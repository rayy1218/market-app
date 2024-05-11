import 'package:dio/dio.dart';
import 'package:supermarket_management/api/general_response.dart';
import 'package:supermarket_management/api/master_service.dart';

class InventoryService {
  late Dio dio;

  InventoryService.of(String token):
    dio = MasterService.init(token: token);

  Future<GeneralResponse> fetchBrandsDropdown() async {
    return await dio.get('/inventory/brands')
        .then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> fetchCategoriesDropdown() async {
    return await dio.get('/inventory/categories')
        .then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> createBrand({name}) async {
    return await dio.post('/inventory/brand',
        data: {
          'name': name
        }
    ).then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> createCategory({name}) async {
    return await dio.post('/inventory/category',
        data: {
          'name': name
        }
    ).then((response) => GeneralResponse(response));

  }

  Future<GeneralResponse> createItem({name, sku, upc, brand, category, price}) async {
    return await dio.post('/inventory/item',
      data: {
        'name': name,
        'sku': sku,
        'upc': upc,
        'brand': brand,
        'category': category,
        'price': price,
      }
    ).then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> fetchItems() async {
    return await dio.get('/inventory/items')
      .then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> createLocation({name, parent}) async {
    return await dio.post('/inventory/location',
      data: {
        'name': name,
        'parent': parent,
      }
    ).then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> fetchLocations() async {
    return await dio.get('/inventory/locations')
        .then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> fetchInventory() async {
    return await dio.get('/inventory')
        .then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> stockIn({product, quantity, location}) async {
    return await dio.post('/inventory/stock-in',
      data: {
        'product': product,
        'quantity': quantity,
        'location': location,
      }
    ).then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> fetchItemsOnLocation({locationId}) async {
    return await dio.get('/inventory/location/$locationId/items')
        .then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> stockTransfer({itemStockData, quantity, location}) async {
    return await dio.post('/inventory/stock-transfer',
        data: {
          'item_stock_data': itemStockData,
          'quantity': quantity,
          'new_location': location,
        }
    ).then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> fetchItem({id}) async {
    return await dio.get('/inventory/item/$id')
        .then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> editItem({id, name, upc, sku, brand, category}) async {
    return await dio.put('/inventory/item/$id',
      data: {
        'name': name,
        'upc': upc,
        'sku': sku,
        'brand': brand,
        'category': category,
      }
    ).then((response) => GeneralResponse(response));
  }

  Future<GeneralResponse> stockSplit({itemStockData, quantity, outputLocation, outputItem, outputQuantity}) async {
    return await dio.post('/inventory/stock-split',
        data: {
          'item_stock_data': itemStockData,
          'quantity': quantity,
          'output_location': outputLocation,
          'output_item': outputItem,
          'output_quantity': outputQuantity,
        }
    ).then((response) => GeneralResponse(response));
  }
}