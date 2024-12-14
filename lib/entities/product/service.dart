import 'dart:convert';
import 'model.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';

class ProductService {
  Future<List<Product>> list() async {
    final response = await http.get(
        Uri.parse(
            '${Constants.apiUrl}/store/products?region_id=reg_01JEPF0D5S5A5W36RMC70XHM2Y&fields=*categories,*variants.inventory_items.inventory.location_levels,+variants.inventory_quantity'),
        headers: {
          'x-publishable-api-key':
              Constants.apiKey
        });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> products = responseData['products'];
      // print(products[0]['variants'][0]['inventory_items'][0]['inventory']['location_levels']);
      return products.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  Future<Product> getById(int id) async {
    final response = await http.get(
        Uri.parse(
            '${Constants.apiUrl}/store/products/$id'),
        headers: {
          'x-publishable-api-key':
              Constants.apiKey
        });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final Map<String, dynamic> product = responseData['product'];
      return Product.fromJson(product);
    } else {
      throw Exception('Failed to fetch product');
    }
  }
}
