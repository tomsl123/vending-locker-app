class ProductImage {
  final String url;

  ProductImage({
    required this.url,
  });
}

class ProductOptionValue {
  final String id;
  final String value;
  final String optionId;

  ProductOptionValue({
    required this.id,
    required this.value,
    required this.optionId,
  });

  factory ProductOptionValue.fromJson(Map<String, dynamic> json) {
    return ProductOptionValue(
      id: json['id'],
      value: json['value'],
      optionId: json['option_id'],
    );
  }
}

class ProductOption {
  final String id;
  final String title;

  ProductOption({
    required this.id,
    required this.title,
  });

  factory ProductOption.fromJson(Map<String, dynamic> json) {
    return ProductOption(
      id: json['id'],
      title: json['title'],
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

class InventoryLocationLevel {
  final String id;
  final int availableQuantity;
  final int stockedQuantity;
  final int reservedQuantity;
  final int incomingQuantity;
  final String locationId;

  InventoryLocationLevel({
    required this.id,
    required this.availableQuantity,
    required this.stockedQuantity,
    required this.reservedQuantity,
    required this.incomingQuantity,
    required this.locationId,
  });

  factory InventoryLocationLevel.fromJson(Map<String, dynamic> json) {
    return InventoryLocationLevel(
      id: json['id'],
      availableQuantity: json['available_quantity'],
      stockedQuantity: json['stocked_quantity'],
      reservedQuantity: json['reserved_quantity'],
      incomingQuantity: json['incoming_quantity'],
      locationId: json['location_id'],
    );
  }
}

class Inventory {
  final String id;
  final List<InventoryLocationLevel> locationLevels;

  Inventory({
    required this.id,
    required this.locationLevels,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      id: json['id'],
      locationLevels: (json['location_levels'] as List<dynamic>)
          .map((level) => InventoryLocationLevel.fromJson(level))
          .toList(),
    );
  }
}

class InventoryItem {
  final Inventory inventory;

  InventoryItem({
    required this.inventory,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      inventory: Inventory.fromJson(json['inventory']),
    );
  }
}

class ProductVariant {
  final String id;
  final String title;
  final List<ProductOptionValue> options;
  final ProductVariantCalculatedPrice? calculatedPrice;
  final List<InventoryItem> inventoryItems;

  ProductVariant({
    required this.id,
    required this.title,
    required this.options,
    this.calculatedPrice,
    required this.inventoryItems,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'],
      title: json['title'],
      options: (json['options'] as List<dynamic>)
          .map((option) => ProductOptionValue.fromJson(option))
          .toList(),
      calculatedPrice: json['calculated_price'] != null
          ? ProductVariantCalculatedPrice.fromJson(json['calculated_price'])
          : null,
      inventoryItems: (json['inventory_items'] as List<dynamic>)
          .map((item) => InventoryItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, int> getQuantitiesByLocation() {
    final Map<String, int> locationQuantities = {};
    for (var item in inventoryItems) {
      for (var level in item.inventory.locationLevels) {
        locationQuantities[level.locationId] = level.availableQuantity;
      }
    }
    return locationQuantities;
  }
}

class Product {
  final String id;
  final String title;
  final String thumbnail;
  final List<ProductImage> images;
  final List<ProductVariant> variants;
  final List<ProductCategory> categories;
  final List<ProductOption> options;

  Product({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.images,
    required this.variants,
    required this.categories,
    required this.options,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
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
              .toList() ??
          [],
      options: (json['options'] as List<dynamic>?)
              ?.map((option) => ProductOption.fromJson(option))
              .toList() ??
          [],
    );
  }
}

