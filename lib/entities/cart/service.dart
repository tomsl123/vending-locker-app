import 'dart:convert';
import 'model.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';

class CartService {
  Future<Cart> create({
    String? regionId,
    Map<String, dynamic>? shippingAddress,
    Map<String, dynamic>? billingAddress, 
    String? email,
    String? currencyCode,
    List<Map<String, dynamic>>? items,
    String? salesChannelId,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? additionalData
  }) async {
    final Map<String, dynamic> body = {
      if (regionId != null) 'region_id': regionId,
      if (shippingAddress != null) 'shipping_address': shippingAddress,
      if (billingAddress != null) 'billing_address': billingAddress,
      if (email != null) 'email': email,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (items != null) 'items': items,
      if (salesChannelId != null) 'sales_channel_id': salesChannelId,
      if (metadata != null) 'metadata': metadata,
      if (additionalData != null) 'additional_data': additionalData
    };

    final response = await http.post(
      Uri.parse('${Constants.medusaApiUrl}/store/carts'),
      headers: {
        'Content-Type': 'application/json',
        'x-publishable-api-key': Constants.medusaApiKey
      },
      body: jsonEncode(body)
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return Cart.fromJson(responseData['cart']);
    } else {
      throw Exception('Failed to create cart');
    }
  }

  Future<Cart> getById(String id) async {
    final response = await http.get(
      Uri.parse('${Constants.medusaApiUrl}/store/carts/$id'),
      headers: {
        'x-publishable-api-key': Constants.medusaApiKey
      }
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return Cart.fromJson(responseData['cart']);
    } else {
      throw Exception('Failed to fetch cart');
    }
  }
}
