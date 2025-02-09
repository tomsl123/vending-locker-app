
class Order {
  final String id;
  final int? displayId;
  final String status;

  Order({
    required this.id,
    this.displayId,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      displayId: json['display_id'],
      status: json['status'],
    );
  }
}
