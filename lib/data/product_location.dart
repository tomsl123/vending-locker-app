import 'location.dart';

class ProductLocation {
  final Location location;
  final int quantity;

  ProductLocation({
    required this.location,
    required this.quantity,
  });

  factory ProductLocation.fromJson(Map<String, dynamic> json) {
    return ProductLocation(
      location: Location.fromJson(json['location']),
      quantity: json['quantity'],
    );
  }
}
