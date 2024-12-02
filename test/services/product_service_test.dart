import 'package:flutter_test/flutter_test.dart';
import 'package:vending_locker_app/data/location.dart';
import 'package:vending_locker_app/data/product.dart';
import 'package:vending_locker_app/data/product_location.dart';
import 'package:vending_locker_app/services/product_service.dart';

void main() {
  group('ProductService Tests', () {
    late ProductService productService;

    setUp(() {
      productService = ProductService();
    });

    test('fetchProducts returns a list of Products', () async {
      final products = await productService.fetchProducts();

      expect(products, isA<List<Product>>());
      expect(products.length, greaterThan(0));
      expect(products.first.name, 'Notebook - A4'); // Verifying mock data
    });

    test('fetchProducts initializes Product data correctly', () async {
      final products = await productService.fetchProducts();
      final product = products.first;

      expect(product.id, 1);
      expect(product.name, 'Notebook - A4');
      expect(product.totalQuantity, 150); // Check totalQuantity calculation
      expect(product.productLocations.length, 2); // Number of locations
    });
  });

  group('Product Model Tests', () {
    test('Product.fromJson maps JSON correctly', () {
      final json = {
        "id": 1,
        "name": "Test Product",
        "price": 10.0,
        "description": "A test product",
        "images": ["image1.jpg", "image2.jpg"],
        "category": "Category1",
        "productLocations": [
          {
            "location": {
              "id": 101,
              "building": "Test Building",
              "section": "A",
              "floor": 1
            },
            "quantity": 50
          }
        ]
      };

      final product = Product.fromJson(json);

      expect(product.id, 1);
      expect(product.name, 'Test Product');
      expect(product.totalQuantity, 50);
      expect(product.productLocations.first.location.building, 'Test Building');
    });
  });

  group('ProductLocation and Location Model Tests', () {
    test('ProductLocation.fromJson maps JSON correctly', () {
      final json = {
        "location": {
          "id": 101,
          "building": "Test Building",
          "section": "A",
          "floor": 1
        },
        "quantity": 50
      };

      final productLocation = ProductLocation.fromJson(json);

      expect(productLocation.quantity, 50);
      expect(productLocation.location.building, 'Test Building');
    });

    test('Location.fromJson maps JSON correctly', () {
      final json = {
        "id": 101,
        "building": "Test Building",
        "section": "A",
        "floor": 1
      };

      final location = Location.fromJson(json);

      expect(location.id, 101);
      expect(location.building, 'Test Building');
      expect(location.section, 'A');
      expect(location.floor, 1);
    });
  });
}