class OrderItem {
  final String id;
  final String title;
  final String? subtitle;
  final String? thumbnail;
  final String variantId;

  OrderItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.thumbnail,
    required this.variantId,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      thumbnail: json['thumbnail'],
      variantId: json['variant_id'],
    );
  }
}

class Order {
  final String id;
  final int? displayId;
  final String status;
  final DateTime createdAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    this.displayId,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsJson = json['items'] as List<dynamic>? ?? [];
    var itemsList = itemsJson.map((item) => OrderItem.fromJson(item)).toList();

    return Order(
      id: json['id'],
      displayId: json['display_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      items: itemsList,
    );
  }
}
