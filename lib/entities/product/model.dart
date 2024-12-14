import '../location/model.dart';

class ProductImage {
  final String url;

  ProductImage({
    required this.url,
  });
}

class ProductOptionValue {
  final String value;

  ProductOptionValue({
    required this.value,
  });

  factory ProductOptionValue.fromJson(Map<String, dynamic> json) {
    return ProductOptionValue(
      value: json['value'],
    );
  }
}

class ProductOption {
  final String title;
  final List<ProductOptionValue> values;

  ProductOption({
    required this.title,
    required this.values,
  });

  factory ProductOption.fromJson(Map<String, dynamic> json) {
    return ProductOption(
      title: json['title'],
      values: json['values'].map((value) => ProductOptionValue.fromJson(value)).toList(),
    );
  }
}

class ProductVariantOption {
  final String value;
  final ProductOption option;

  ProductVariantOption({
    required this.value,
    required this.option,
  });

  factory ProductVariantOption.fromJson(Map<String, dynamic> json) {
    return ProductVariantOption(
      value: json['value'],
      option: ProductOption.fromJson(json['option']),
    );
  }
}

class ProductVariantCalculatedPrice {
  final double calculatedAmount;
  final String currencyCode;

  ProductVariantCalculatedPrice({
    required this.calculatedAmount,
    required this.currencyCode,
  });

  factory ProductVariantCalculatedPrice.fromJson(Map<String, dynamic> json) {
    return ProductVariantCalculatedPrice(
      calculatedAmount: json['calculated_amount'],
      currencyCode: json['currency_code'],
    );
  }
}

class ProductCategory {
  final String name;

  ProductCategory({
    required this.name,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      name: json['name'],
    );
  }
}

class ProductVariant {
  final String title;
  final List<ProductOptionValue> options;
  final ProductVariantCalculatedPrice calculatedPrice;


  ProductVariant({
    required this.title,
    required this.options,
    required this.calculatedPrice,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      title: json['title'],
      options: (json['options'] as List<dynamic>).map((option) => ProductOptionValue.fromJson(option)).toList(),
      calculatedPrice: ProductVariantCalculatedPrice.fromJson(json['calculated_price']),
    );
  }
}

class Product {
  final String id;
  final String title;
  final String thumbnail;
  final List<ProductImage> images;
  final List<ProductVariant> variants;
  final List<ProductCategory> categories;

  Product({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.images,
    required this.variants,
    required this.categories,
  });

factory Product.fromJson(Map<String, dynamic> json) {
  print(json);
    return Product(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      images: (json['images'] as List<dynamic>)
          .map((image) => ProductImage(url: image['url']))
          .toList(),
      variants: (json['variants'] as List<dynamic>)
          .map((variant) => ProductVariant.fromJson(variant))
          .toList(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((category) => ProductCategory.fromJson(category))
          .toList() ?? [],
    );
  }
}

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
