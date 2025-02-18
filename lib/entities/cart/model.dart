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
  final String variantId;
  final String? variantSku;
  final String? variantBarcode;
  final String? variantTitle;
  final Map<String, String>? variantOptionValues;
  final bool requiresShipping;
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
  final DateTime createdAt;

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
    required this.variantId,
    this.variantSku,
    this.variantBarcode,
    this.variantTitle,
    this.variantOptionValues,
    required this.requiresShipping,
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
    required this.createdAt,
  });

  factory CartLineItem.fromJson(Map<String, dynamic> json) {
    return CartLineItem(
        id: json['id'],
        title: json['title'],
        subtitle: json['subtitle'],
        thumbnail: json['thumbnail'],
        quantity: json['quantity'],
        product: Product.fromJson({
          ...json['product'],
          'title': json['product_title'],
          'thumbnail': json['thumbnail'],
          'images': [],
        }),
        productId: json['product_id'],
        productTitle: json['product_title'],
        productDescription: json['product_description'],
        productSubtitle: json['product_subtitle'],
        productType: json['product_type'],
        productCollection: json['product_collection'],
        productHandle: json['product_handle'],
        variantId: json['variant_id'],
        variantSku: json['variant_sku'],
        variantBarcode: json['variant_barcode'],
        variantTitle: json['variant_title'],
        variantOptionValues: json['variant_option_values'] != null
            ? Map<String, String>.from(json['variant_option_values'])
            : null,
        requiresShipping: json['requires_shipping'],
        isTaxInclusive: json['is_tax_inclusive'],
        compareAtUnitPrice: json['compare_at_unit_price']?.toDouble(),
        unitPrice: json['unit_price']?.toDouble() ?? 0,
        originalTotal: json['original_total']?.toDouble() ?? 0,
        originalSubtotal: json['original_subtotal']?.toDouble() ?? 0,
        originalTaxTotal: json['original_tax_total']?.toDouble() ?? 0,
        itemTotal: json['item_total']?.toDouble() ?? 0,
        itemSubtotal: json['item_subtotal']?.toDouble() ?? 0,
        itemTaxTotal: json['item_tax_total']?.toDouble() ?? 0,
        total: json['total']?.toDouble() ?? 0,
        subtotal: json['subtotal']?.toDouble() ?? 0,
        taxTotal: json['tax_total']?.toDouble() ?? 0,
        discountTotal: json['discount_total']?.toDouble() ?? 0,
        discountTaxTotal: json['discount_tax_total']?.toDouble() ?? 0,
        createdAt: DateTime.parse(json['created_at']));
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
  final PaymentCollection? paymentCollection;

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
    this.paymentCollection,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      currencyCode: json['currency_code'],
      originalItemTotal: (json['original_item_total'] ?? 0).toDouble(),
      originalItemSubtotal: (json['original_item_subtotal'] ?? 0).toDouble(),
      originalItemTaxTotal: (json['original_item_tax_total'] ?? 0).toDouble(),
      itemTotal: (json['item_total'] ?? 0).toDouble(),
      itemSubtotal: (json['item_subtotal'] ?? 0).toDouble(),
      itemTaxTotal: (json['item_tax_total'] ?? 0).toDouble(),
      originalTotal: (json['original_total'] ?? 0).toDouble(),
      originalSubtotal: (json['original_subtotal'] ?? 0).toDouble(),
      originalTaxTotal: (json['original_tax_total'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      taxTotal: (json['tax_total'] ?? 0).toDouble(),
      discountTotal: (json['discount_total'] ?? 0).toDouble(),
      discountTaxTotal: (json['discount_tax_total'] ?? 0).toDouble(),
      giftCardTotal: (json['gift_card_total'] ?? 0).toDouble(),
      giftCardTaxTotal: (json['gift_card_tax_total'] ?? 0).toDouble(),
      shippingTotal: (json['shipping_total'] ?? 0).toDouble(),
      shippingSubtotal: (json['shipping_subtotal'] ?? 0).toDouble(),
      shippingTaxTotal: (json['shipping_tax_total'] ?? 0).toDouble(),
      originalShippingTotal: (json['original_shipping_total'] ?? 0).toDouble(),
      originalShippingSubtotal:
          (json['original_shipping_subtotal'] ?? 0).toDouble(),
      originalShippingTaxTotal:
          (json['original_shipping_tax_total'] ?? 0).toDouble(),
      regionId: json['region_id'],
      customerId: json['customer_id'],
      salesChannelId: json['sales_channel_id'],
      email: json['email'],
      items: ((json['items'] as List<dynamic>?)
              ?.map((item) => CartLineItem.fromJson(item))
              .toList()
            ?..sort((a, b) => a.createdAt.compareTo(b.createdAt))) ??
          [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      paymentCollection: json['payment_collection'] != null
          ? PaymentCollection.fromJson(json['payment_collection'])
          : null,
    );
  }
}

// Payment Collection related classes

class PaymentCollection {
  final String id;
  final String? currencyCode;
  final double amount;
  final String? status;
  final List<PaymentProvider>? paymentProviders;
  final List<PaymentSession>? paymentSessions;
  final List<Payment>? payments;

  PaymentCollection({
    required this.id,
    this.currencyCode,
    required this.amount,
    this.status,
    this.paymentProviders,
    this.paymentSessions,
    this.payments,
  });

  factory PaymentCollection.fromJson(Map<String, dynamic> json) {
    return PaymentCollection(
      id: json['id'],
      currencyCode: json['currency_code'],
      amount: (json['amount'] as num).toDouble(),
      status: json['status'],
      paymentProviders: json['payment_providers'] != null ? (json['payment_providers'] as List<dynamic>)
          .map((e) => PaymentProvider.fromJson(e))
          .toList() : null,
      paymentSessions: json['payment_sessions'] != null
          ? (json['payment_sessions'] as List<dynamic>)
              .map((e) => PaymentSession.fromJson(e))
              .toList()
          : null,
      payments: json['payments'] != null
          ? (json['payments'] as List<dynamic>)
              .map((e) => Payment.fromJson(e))
              .toList()
          : null,
    );
  }
}

class PaymentProvider {
  final String id;
  final double? authorizedAmount;
  final double? capturedAmount;
  final double? refundedAmount;
  final DateTime? completedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;

  PaymentProvider({
    required this.id,
    this.authorizedAmount,
    this.capturedAmount,
    this.refundedAmount,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
    this.metadata,
  });

  factory PaymentProvider.fromJson(Map<String, dynamic> json) {
    return PaymentProvider(
      id: json['id'],
      authorizedAmount: json['authorized_amount'] != null
          ? (json['authorized_amount'] as num).toDouble()
          : null,
      capturedAmount: json['captured_amount'] != null
          ? (json['captured_amount'] as num).toDouble()
          : null,
      refundedAmount: json['refunded_amount'] != null
          ? (json['refunded_amount'] as num).toDouble()
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
    );
  }
}

class PaymentSession {
  final String id;
  final double amount;
  final String currencyCode;
  final String providerId;
  final Map<String, dynamic> data;
  final String status;
  final Map<String, dynamic>? context;
  final DateTime? authorizedAt;
  final Payment? payment;

  PaymentSession({
    required this.id,
    required this.amount,
    required this.currencyCode,
    required this.providerId,
    required this.data,
    required this.status,
    this.context,
    this.authorizedAt,
    this.payment,
  });

  factory PaymentSession.fromJson(Map<String, dynamic> json) {
    return PaymentSession(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      currencyCode: json['currency_code'],
      providerId: json['provider_id'],
      data: json['data'] != null
          ? Map<String, dynamic>.from(json['data'])
          : {},
      status: json['status'],
      context: json['context'] != null
          ? Map<String, dynamic>.from(json['context'])
          : null,
      authorizedAt: json['authorized_at'] != null
          ? DateTime.parse(json['authorized_at'])
          : null,
      payment:
          json['payment'] != null ? Payment.fromJson(json['payment']) : null,
    );
  }
}

class Payment {
  final String id;
  final double amount;
  final String currencyCode;
  final String providerId;
  final double? authorizedAmount;
  final Map<String, dynamic>? data;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? capturedAt;
  final DateTime? canceledAt;
  final double? capturedAmount;
  final double? refundedAmount;
  final List<PaymentCapture>? captures;
  final List<PaymentRefund>? refunds;

  Payment({
    required this.id,
    required this.amount,
    required this.currencyCode,
    required this.providerId,
    this.authorizedAmount,
    this.data,
    this.createdAt,
    this.updatedAt,
    this.capturedAt,
    this.canceledAt,
    this.capturedAmount,
    this.refundedAmount,
    this.captures,
    this.refunds,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      currencyCode: json['currency_code'],
      providerId: json['provider_id'],
      authorizedAmount: json['authorized_amount'] != null
          ? (json['authorized_amount'] as num).toDouble()
          : null,
      data:
          json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      capturedAt: json['captured_at'] != null
          ? DateTime.parse(json['captured_at'])
          : null,
      canceledAt: json['canceled_at'] != null
          ? DateTime.parse(json['canceled_at'])
          : null,
      capturedAmount: json['captured_amount'] != null
          ? (json['captured_amount'] as num).toDouble()
          : null,
      refundedAmount: json['refunded_amount'] != null
          ? (json['refunded_amount'] as num).toDouble()
          : null,
      captures: json['captures'] != null
          ? (json['captures'] as List<dynamic>)
              .map((e) => PaymentCapture.fromJson(e))
              .toList()
          : null,
      refunds: json['refunds'] != null
          ? (json['refunds'] as List<dynamic>)
              .map((e) => PaymentRefund.fromJson(e))
              .toList()
          : null,
    );
  }
}

class PaymentCapture {
  final String id;
  final double amount;
  final DateTime createdAt;
  final String? createdBy;

  PaymentCapture({
    required this.id,
    required this.amount,
    required this.createdAt,
    this.createdBy,
  });

  factory PaymentCapture.fromJson(Map<String, dynamic> json) {
    return PaymentCapture(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      createdBy: json['payment'] != null ? json['payment']['created_by'] : null,
    );
  }
}

class PaymentRefund {
  final String id;
  final double amount;
  final DateTime createdAt;
  final PaymentRefundData? payment;
  final PaymentRefundReason? refundReason;

  PaymentRefund({
    required this.id,
    required this.amount,
    required this.createdAt,
    this.payment,
    this.refundReason,
  });

  factory PaymentRefund.fromJson(Map<String, dynamic> json) {
    return PaymentRefund(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      payment: json['payment'] != null
          ? PaymentRefundData.fromJson(json['payment'])
          : null,
      refundReason: json['refund_reason'] != null
          ? PaymentRefundReason.fromJson(json['refund_reason'])
          : null,
    );
  }
}

class PaymentRefundData {
  final String? refundReasonId;
  final String? note;
  final String? createdBy;

  PaymentRefundData({
    this.refundReasonId,
    this.note,
    this.createdBy,
  });

  factory PaymentRefundData.fromJson(Map<String, dynamic> json) {
    return PaymentRefundData(
      refundReasonId: json['refund_reason_id'],
      note: json['note'],
      createdBy: json['created_by'],
    );
  }
}

class PaymentRefundReason {
  final String id;
  final String label;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? description;

  PaymentRefundReason({
    required this.id,
    required this.label,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.description,
  });

  factory PaymentRefundReason.fromJson(Map<String, dynamic> json) {
    return PaymentRefundReason(
      id: json['id'],
      label: json['label'],
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : {},
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      description: json['description'],
    );
  }
}
