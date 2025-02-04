import 'dart:convert';
import 'dart:developer';
import 'model.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  Future<Cart> addLineItem(String cartId, String variantId, int quantity,
      {Map<String, dynamic>? metadata}) async {
    final Map<String, dynamic> body = {
      'variant_id': variantId,
      'quantity': quantity,
      if (metadata != null) 'metadata': metadata
    };

    final response = await http.post(
        Uri.parse(
            '${Constants.medusaApiUrl}/store/carts/$cartId/line-items?fields=*items.product.categories,*items.product.options,*items.product.variants,*items.product.variants.options,*items.product.variants.inventory_items.inventory.location_levels,+items.product.variants.inventory_quantity'),
        headers: {
          'Content-Type': 'application/json',
          'x-publishable-api-key': Constants.medusaApiKey
        },
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      log(responseData.toString());
      return Cart.fromJson(responseData['cart']);
    } else {
      throw Exception('Failed to add line item to cart');
    }
  }

  Future<Cart> setLineItemQuantity(
      String cartId, String lineItemId, int quantity) async {
    final Map<String, dynamic> body = {
      'quantity': quantity,
    };

    final response = await http.post(
      Uri.parse(
          '${Constants.medusaApiUrl}/store/carts/$cartId/line-items/$lineItemId?fields=*items.product.categories,*items.product.options,*items.product.variants,*items.product.variants.options,*items.product.variants.inventory_items.inventory.location_levels,+items.product.variants.inventory_quantity'),
      headers: {
        'Content-Type': 'application/json',
        'x-publishable-api-key': Constants.medusaApiKey,
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      log(responseData['cart']['items']
          .map((e) => e['variant_title'])
          .toString());
      return Cart.fromJson(responseData['cart']);
    } else {
      throw Exception('Failed to set line item quantity');
    }
  }

  Future<void> deleteLineItem(String cartId, String lineItemId) async {
    final response = await http.delete(
      Uri.parse(
          '${Constants.medusaApiUrl}/store/carts/$cartId/line-items/$lineItemId'),
      headers: {
        'Content-Type': 'application/json',
        'x-publishable-api-key': Constants.medusaApiKey,
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete line item from cart');
    }
  }

  Future<String> getOrCreateCartId() async {
    // Try to get existing cart ID from storage
    final String? existingCartId = await asyncPrefs.getString('cart_id');
    if (existingCartId != null) {
      return existingCartId;
    }

    // Create new cart if none exists
    final cart = await create();
    await asyncPrefs.setString('cart_id', cart.id);
    return cart.id;
  }

  Future<Cart> create(
      {String? regionId,
      Map<String, dynamic>? shippingAddress,
      Map<String, dynamic>? billingAddress,
      String? email,
      String? currencyCode,
      List<Map<String, dynamic>>? items,
      Map<String, dynamic>? metadata,
      Map<String, dynamic>? additionalData}) async {
    final Map<String, dynamic> body = {
      'region_id': Constants.berlinCampusRegionId,
      'sales_channel_id': Constants.salesChannelId,
      if (shippingAddress != null) 'shipping_address': shippingAddress,
      if (billingAddress != null) 'billing_address': billingAddress,
      if (email != null) 'email': email,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (items != null) 'items': items,
      if (metadata != null) 'metadata': metadata,
      if (additionalData != null) 'additional_data': additionalData
    };

    final response =
        await http.post(Uri.parse('${Constants.medusaApiUrl}/store/carts'),
            headers: {
              'Content-Type': 'application/json',
              'x-publishable-api-key': Constants.medusaApiKey
            },
            body: jsonEncode(body));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return Cart.fromJson(responseData['cart']);
    } else {
      throw Exception('Failed to create cart');
    }
  }

  Future<Cart> getById(String id) async {
    final response = await http.get(
        Uri.parse(
            '${Constants.medusaApiUrl}/store/carts/$id?fields=*items.product.categories,*items.product.options,*items.product.variants,*items.product.variants.options,*items.product.variants.inventory_items.inventory.location_levels,+items.product.variants.inventory_quantity'),
        headers: {'x-publishable-api-key': Constants.medusaApiKey});

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return Cart.fromJson(responseData['cart']);
    } else {
      throw Exception('Failed to fetch cart');
    }
  }

  CartLineItem? getCartLineItemByVariantId(List<CartLineItem> items, String? variantId) {
    var matchingItems = items.where((item) => item.variantId == variantId);
    return matchingItems.isNotEmpty ? matchingItems.first : null;
  }
}
