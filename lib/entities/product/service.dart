import 'dart:convert';
import 'model.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import 'dart:developer';

class ProductService {
  Future<List<Product>> list() async {
    final response = await http.get(
        Uri.parse(
            '${Constants.medusaApiUrl}/store/products?region_id=${Constants.berlinCampusRegionId}&fields=*categories,*variants.inventory_items.inventory.location_levels,+variants.inventory_quantity'),
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

  Future<List<Product>> searchProducts(String query, String locationId) async {
    try {
      // Fetch products from Medusa with title search and location filtering
      final response = await http.get(
        Uri.parse(
          '${Constants.medusaApiUrl}/store/products?'
              'region_id=${Constants.berlinCampusRegionId}'
              '&q=${Uri.encodeQueryComponent(query)}'
              '&fields=*categories,*variants.inventory_items.inventory.location_levels,+variants.inventory_quantity',
        ),
        headers: {'x-publishable-api-key': Constants.medusaApiKey},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> products = responseData['products'];
        final allProducts = products.map((p) => Product.fromJson(p)).toList();

        // Filter by location locally (as your backend might not support it)
        return allProducts.where((product) {
          return product.variants.any((variant) {
            final quantities = variant.getQuantitiesByLocation();
            return quantities.containsKey(locationId) && quantities[locationId]! > 0;
          });
        }).toList();
      } else {
        throw Exception('Failed to fetch search results');
      }
    } catch (e) {
      log('Search error: $e');
      throw Exception('Search failed');
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
            '${Constants.medusaApiUrl}/store/products/$id?region_id=${Constants.berlinCampusRegionId}&fields=*categories,*variants.inventory_items.inventory.location_levels,+variants.inventory_quantity'),
        headers: {
          'x-publishable-api-key':
              Constants.medusaApiKey
        });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final Map<String, dynamic> product = responseData['product'];
      return Product.fromJson(product);
    } else {
      throw Exception('Failed to fetch product');
    }
  }

  ProductVariant? getProductVariantFromProductByVariantId(Product product, String variantId) {
    var matchingVariants = product.variants.where((variant) => variant.id == variantId);
    return matchingVariants.isNotEmpty ? matchingVariants.first : null;
  }

}
