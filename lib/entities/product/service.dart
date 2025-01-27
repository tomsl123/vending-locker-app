import 'dart:convert';
import 'model.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import 'dart:developer';

class ProductService {
  Future<List<Product>> list() async {
    final response = await http.get(
        Uri.parse(
            '${Constants.medusaApiUrl}/store/products?region_id=reg_01JEPF0D5S5A5W36RMC70XHM2Y&fields=*categories,*variants.inventory_items.inventory.location_levels,+variants.inventory_quantity'),
        headers: {
          'x-publishable-api-key':
              Constants.medusaApiKey
        });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> products = responseData['products'];
      return products.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  Future<List<Product>> listByLocation(String locationId) async {
    try {
      // Not ideal, but filtering by location id via URL param would require endpoint adjustment
      final products = await list();

      // Filter the products by the given location ID
      final filteredProducts = products.where((product) {
        for (final variant in product.variants) {
          final quantitiesByLocation = variant.getQuantitiesByLocation();
          if (quantitiesByLocation.containsKey(locationId) &&
              quantitiesByLocation[locationId]! > 0) {
            return true;
          }
        }
        return false;
      }).toList();

      return filteredProducts;
    } catch (e) {
      log('Error filtering products by location: $e');
      throw Exception('Failed to filter products by location');
    }
  }

  Future<Product> getById(String id) async {
    final response = await http.get(
        Uri.parse(
            '${Constants.medusaApiUrl}/store/products/$id?region_id=reg_01JEPF0D5S5A5W36RMC70XHM2Y&fields=*categories,*variants.inventory_items.inventory.location_levels,+variants.inventory_quantity'),
        headers: {
          'x-publishable-api-key':
              Constants.medusaApiKey
        });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final Map<String, dynamic> product = responseData['product'];
      log(product.toString());
      return Product.fromJson(product);
    } else {
      throw Exception('Failed to fetch product');
    }
  }
}
