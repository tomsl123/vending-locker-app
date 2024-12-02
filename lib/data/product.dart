import 'product_location.dart';

class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final List<String> images;
  final List<String> categories;
  final List<ProductLocation> productLocations;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.images,
    required this.categories,
    required this.productLocations,
  });

  // Getter for total quantity
  int get totalQuantity {
    return productLocations.fold(
      0,
          (sum, productLocation) => sum + productLocation.quantity,
    );
  }

  String get allLocationsString {
    // Filter locations with quantity > 0
    final filteredLocations = productLocations.where((pl) => pl.quantity > 0);

    // Group locations by building
    final groupedByBuilding = <String, Set<String>>{};
    for (var productLocation in filteredLocations) {
      final location = productLocation.location;
      groupedByBuilding.putIfAbsent(location.building, () => {}).add(location.section);
    }

    // Create the formatted string
    final formattedString = groupedByBuilding.entries.map((entry) {
      final sections = entry.value.join(", ");
      return "${entry.key}: $sections";
    }).join("; ");

    return formattedString;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      description: json['description'],
      images: List<String>.from(json['images']),
      categories: List<String>.from(json['categories']),
      productLocations: (json['productLocations'] as List)
          .map((pl) => ProductLocation.fromJson(pl))
          .toList(),
    );
  }
}
