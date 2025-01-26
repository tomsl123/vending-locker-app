import '../product/model.dart';

class CartLineItem {
  final String id;
  final String title;
  final String? subtitle;
  final String? thumbnail;
  final int quantity;
  final Product product;
  final String productId;
  final String productTitle;
  final String? productDescription;
  final String? productSubtitle;
  final String? productType;
  final String? productCollection;
  final String? productHandle;
  final ProductVariant variant;
  final String variantId;
  final String? variantSku;
  final String? variantBarcode;
  final String? variantTitle;
  final Map<String, String>? variantOptionValues;
  final bool requiresShipping;
  final bool isDiscountable;
  final bool isTaxInclusive;
  final double? compareAtUnitPrice;
  final double unitPrice;
  final double originalTotal;
  final double originalSubtotal;
  final double originalTaxTotal;
  final double itemTotal;
  final double itemSubtotal;
  final double itemTaxTotal;
  final double total;
  final double subtotal;
  final double taxTotal;
  final double discountTotal;
  final double discountTaxTotal;

  CartLineItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.thumbnail,
    required this.quantity,
    required this.product,
    required this.productId,
    required this.productTitle,
    this.productDescription,
    this.productSubtitle,
    this.productType,
    this.productCollection,
    this.productHandle,
    required this.variant,
    required this.variantId,
    this.variantSku,
    this.variantBarcode,
    this.variantTitle,
    this.variantOptionValues,
    required this.requiresShipping,
    required this.isDiscountable,
    required this.isTaxInclusive,
    this.compareAtUnitPrice,
    required this.unitPrice,
    required this.originalTotal,
    required this.originalSubtotal,
    required this.originalTaxTotal,
    required this.itemTotal,
    required this.itemSubtotal,
    required this.itemTaxTotal,
    required this.total,
    required this.subtotal,
    required this.taxTotal,
    required this.discountTotal,
    required this.discountTaxTotal,
  });

  factory CartLineItem.fromJson(Map<String, dynamic> json) {
    return CartLineItem(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      thumbnail: json['thumbnail'],
      quantity: json['quantity'],
      product: Product.fromJson(json['product']),
      productId: json['product_id'],
      productTitle: json['product_title'],
      productDescription: json['product_description'],
      productSubtitle: json['product_subtitle'],
      productType: json['product_type'],
      productCollection: json['product_collection'],
      productHandle: json['product_handle'],
      variant: ProductVariant.fromJson(json['variant']),
      variantId: json['variant_id'],
      variantSku: json['variant_sku'],
      variantBarcode: json['variant_barcode'],
      variantTitle: json['variant_title'],
      variantOptionValues: json['variant_option_values'] != null 
        ? Map<String, String>.from(json['variant_option_values'])
        : null,
      requiresShipping: json['requires_shipping'],
      isDiscountable: json['is_discountable'],
      isTaxInclusive: json['is_tax_inclusive'],
      compareAtUnitPrice: json['compare_at_unit_price']?.toDouble(),
      unitPrice: json['unit_price'].toDouble(),
      originalTotal: json['original_total'].toDouble(),
      originalSubtotal: json['original_subtotal'].toDouble(),
      originalTaxTotal: json['original_tax_total'].toDouble(),
      itemTotal: json['item_total'].toDouble(),
      itemSubtotal: json['item_subtotal'].toDouble(),
      itemTaxTotal: json['item_tax_total'].toDouble(),
      total: json['total'].toDouble(),
      subtotal: json['subtotal'].toDouble(),
      taxTotal: json['tax_total'].toDouble(),
      discountTotal: json['discount_total'].toDouble(),
      discountTaxTotal: json['discount_tax_total'].toDouble(),
    );
  }
}

class Cart {
  final String id;
  final String currencyCode;
  final double originalItemTotal;
  final double originalItemSubtotal; 
  final double originalItemTaxTotal;
  final double itemTotal;
  final double itemSubtotal;
  final double itemTaxTotal;
  final double originalTotal;
  final double originalSubtotal;
  final double originalTaxTotal;
  final double total;
  final double subtotal;
  final double taxTotal;
  final double discountTotal;
  final double discountTaxTotal;
  final double giftCardTotal;
  final double giftCardTaxTotal;
  final double shippingTotal;
  final double shippingSubtotal;
  final double shippingTaxTotal;
  final double originalShippingTotal;
  final double originalShippingSubtotal;
  final double originalShippingTaxTotal;
  final String? regionId;
  final String? customerId;
  final String? salesChannelId;
  final String? email;
  final List<CartLineItem> items;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Cart({
    required this.id,
    required this.currencyCode,
    required this.originalItemTotal,
    required this.originalItemSubtotal,
    required this.originalItemTaxTotal,
    required this.itemTotal,
    required this.itemSubtotal,
    required this.itemTaxTotal,
    required this.originalTotal,
    required this.originalSubtotal,
    required this.originalTaxTotal,
    required this.total,
    required this.subtotal,
    required this.taxTotal,
    required this.discountTotal,
    required this.discountTaxTotal,
    required this.giftCardTotal,
    required this.giftCardTaxTotal,
    required this.shippingTotal,
    required this.shippingSubtotal,
    required this.shippingTaxTotal,
    required this.originalShippingTotal,
    required this.originalShippingSubtotal,
    required this.originalShippingTaxTotal,
    this.regionId,
    this.customerId,
    this.salesChannelId,
    this.email,
    required this.items,
    this.createdAt,
    this.updatedAt,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      currencyCode: json['currency_code'],
      originalItemTotal: json['original_item_total'].toDouble(),
      originalItemSubtotal: json['original_item_subtotal'].toDouble(),
      originalItemTaxTotal: json['original_item_tax_total'].toDouble(),
      itemTotal: json['item_total'].toDouble(),
      itemSubtotal: json['item_subtotal'].toDouble(),
      itemTaxTotal: json['item_tax_total'].toDouble(),
      originalTotal: json['original_total'].toDouble(),
      originalSubtotal: json['original_subtotal'].toDouble(),
      originalTaxTotal: json['original_tax_total'].toDouble(),
      total: json['total'].toDouble(),
      subtotal: json['subtotal'].toDouble(),
      taxTotal: json['tax_total'].toDouble(),
      discountTotal: json['discount_total'].toDouble(),
      discountTaxTotal: json['discount_tax_total'].toDouble(),
      giftCardTotal: json['gift_card_total'].toDouble(),
      giftCardTaxTotal: json['gift_card_tax_total'].toDouble(),
      shippingTotal: json['shipping_total'].toDouble(),
      shippingSubtotal: json['shipping_subtotal'].toDouble(),
      shippingTaxTotal: json['shipping_tax_total'].toDouble(),
      originalShippingTotal: json['original_shipping_total'].toDouble(),
      originalShippingSubtotal: json['original_shipping_subtotal'].toDouble(),
      originalShippingTaxTotal: json['original_shipping_tax_total'].toDouble(),
      regionId: json['region_id'],
      customerId: json['customer_id'],
      salesChannelId: json['sales_channel_id'],
      email: json['email'],
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => CartLineItem.fromJson(item))
          .toList() ?? [],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}

