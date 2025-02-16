import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import 'model.dart';

class OrderService {
  Future<List<Order>> listByStatuses(List<String> statuses) async {
    final String statusesQuery = statuses.join(',');

    final response = await http.get(
      Uri.parse(
        '${Constants.medusaApiUrl}/store/orders?status[]=$statusesQuery',
      ),
      headers: {
        'x-publishable-api-key': Constants.medusaApiKey,
        'Authorization': 'Bearer ${Constants.customerAuthToken}',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> orders = responseData['orders'];
      return orders.map((order) => Order.fromJson(order)).toList();
    } else {
      throw Exception('Failed to fetch orders. Status: ${response.statusCode}');
    }
  }

  Future<void> cancelOrder(String orderId) async {
    // TODO: This is not a correct path. Medusa does not allow customers to cancel orders
    final response = await http.post(
      Uri.parse('${Constants.medusaApiUrl}/store/orders/$orderId/cancel'),
      headers: {
        'x-publishable-api-key': Constants.medusaApiKey,
        'Authorization': 'Bearer ${Constants.customerAuthToken}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print("Order Canceled Successfully");
    } else {
      print(response.statusCode);
      throw Exception('Failed to cancel order. Status: ${response.statusCode}');
    }
  }
}

