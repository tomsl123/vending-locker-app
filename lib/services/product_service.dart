import 'dart:convert';
import '../data/product.dart';


class ProductService {
  // Mocked JSON data
  final String mockData = '''
[
  {
    "id": 1,
    "name": "Notebook - A4",
    "price": 4.99,
    "description": "A standard A4 notebook for taking notes or journaling.",
    "images": [
      "https://example.com/images/notebook_a4_1.jpg",
      "https://example.com/images/notebook_a4_2.jpg"
    ],
    "categories": ["Stationery", "Notebooks", "University Supplies"],
    "productLocations": [
      {
        "location": {
          "id": 101,
          "building": "HALL",
          "section": "A",
          "floor": 1
        },
        "quantity": 100
      },
      {
        "location": {
          "id": 102,
          "building": "SHED",
          "section": "C",
          "floor": 2
        },
        "quantity": 50
      }
    ]
  },
  {
    "id": 2,
    "name": "Ballpoint Pen - Pack of 10",
    "price": 3.49,
    "description": "A pack of 10 blue ballpoint pens, ideal for everyday use.",
    "images": [
      "https://example.com/images/ballpoint_pen_1.jpg",
      "https://example.com/images/ballpoint_pen_2.jpg"
    ],
    "categories": ["Stationery", "Writing Instruments"],
    "productLocations": [
      {
        "location": {
          "id": 103,
          "building": "CUBE",
          "section": "B",
          "floor": 3
        },
        "quantity": 200
      }
    ]
  },
  {
    "id": 3,
    "name": "Laptop Stand",
    "price": 29.99,
    "description": "An adjustable laptop stand for comfortable working positions.",
    "images": [
      "https://example.com/images/laptop_stand_1.jpg",
      "https://example.com/images/laptop_stand_2.jpg"
    ],
    "categories": ["Office Supplies", "Ergonomics"],
    "productLocations": [
      {
        "location": {
          "id": 104,
          "building": "HALL",
          "section": "D",
          "floor": 4
        },
        "quantity": 30
      },
      {
        "location": {
          "id": 105,
          "building": "CUBE",
          "section": "A",
          "floor": 2
        },
        "quantity": 20
      }
    ]
  },
  {
    "id": 4,
    "name": "Whiteboard Markers - Pack of 4",
    "price": 6.99,
    "description": "A pack of 4 whiteboard markers in assorted colors.",
    "images": [
      "https://example.com/images/whiteboard_markers_1.jpg",
      "https://example.com/images/whiteboard_markers_2.jpg"
    ],
    "categories": ["Stationery", "Teaching Supplies", "Markers"],
    "productLocations": [
      {
        "location": {
          "id": 106,
          "building": "SHED",
          "section": "B",
          "floor": 1
        },
        "quantity": 150
      }
    ]
  },
  {
    "id": 5,
    "name": "Desk Organizer",
    "price": 12.49,
    "description": "A multi-compartment desk organizer to keep your workspace tidy.",
    "images": [
      "https://example.com/images/desk_organizer_1.jpg",
      "https://example.com/images/desk_organizer_2.jpg"
    ],
    "categories": ["Office Supplies", "Organization"],
    "productLocations": [
      {
        "location": {
          "id": 107,
          "building": "CUBE",
          "section": "D",
          "floor": 5
        },
        "quantity": 40
      },
      {
        "location": {
          "id": 108,
          "building": "HALL",
          "section": "C",
          "floor": 2
        },
        "quantity": 35
      }
    ]
  }
]
''';

  Future<List<Product>> fetchProducts() async {
    // TODO: Simulate a delay to mimic network latency, REMOVE!!!
    // await Future.delayed(Duration(seconds: 1));

    List<dynamic> data = jsonDecode(mockData);
    return data.map((json) => Product.fromJson(json)).toList();
  }

  Future<Product> fetchProductById(int id) async {
    // TODO: Simulate a delay to mimic network latency, REMOVE!!!
    // await Future.delayed(Duration(seconds: 1));

    //TODO: Do this properly!!!
    List<dynamic> data = jsonDecode(mockData);
    return data.map((json) => Product.fromJson(json)).toList()[id];
  }
}
