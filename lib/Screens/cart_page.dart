import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/cart/model.dart';
import '../entities/cart/service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String selectedLocation = 'SHED';
  String selectedSection = 'A';
  String selectedFloor = '1';

  final CartService _cartService = CartService();
  late Future<String> _pickupLocationFuture;
  late Future<Cart?> _cartFuture;

  @override
  void initState() {
    super.initState();
    _cartFuture = Future.value(null);
    _pickupLocationFuture = _loadSavedLocation();
    _loadCart();
  }

  Future<void> _loadCart() async {
    String cartId = await _cartService.getOrCreateCartId();
    print(cartId);
    setState(() {
      _cartFuture = _cartService.getById(cartId);
    });
  }

  Future<void> _updateLineItemQuantity(String cartId, String lineItemId, int quantity) async {
    setState(() {

      _cartFuture = _cartService.setLineItemQuantity(cartId, lineItemId, quantity);
    });
  }

  Future<String> _loadSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    selectedLocation = prefs.getString('selectedLocation') ?? 'SHED';
    selectedSection = prefs.getString('selectedSection') ?? 'A';
    selectedFloor = prefs.getString('selectedFloor') ?? '1';
    return '$selectedLocation $selectedSection$selectedFloor';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'My Cart',
            style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                letterSpacing: 0.4),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: Color(0xFF312F2F),
              size: 25,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            FutureBuilder<Cart?>(
              future: _cartFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final cart = snapshot.data!;
                  final items = cart.items;

                  if (items.isEmpty) {
                    return const Center(child: Text('Your cart is empty.'));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Column(
                        children: [
                          Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              setState(() {

                              });
                            },
                            background: Container(
                              width: 79,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF4070),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 27),
                              child: const Icon(Icons.delete, color: Colors.white, size: 25),
                            ),
                            child: Container(
                              height: 125,
                              padding: const EdgeInsets.only(
                                  left: 12, right: 18, top: 14, bottom: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  // Thumbnail or placeholder if null
                                  item.thumbnail != null
                                      ? Image.network(
                                    item.thumbnail!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                      : Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image_not_supported),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Product title, with variant
                                          SizedBox(
                                            width: 162,
                                            child: Text(
                                              '${item.productTitle} (${item.variantTitle})',
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                height: 14 / 13,
                                                letterSpacing: 0.4,
                                                color: Color(0xFF312F2F),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          // Unit price
                                          Text(
                                            '€${item.unitPrice.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              height: 14 / 13,
                                              letterSpacing: 0.4,
                                              color: Color(0xFF312F2F),
                                            ),
                                          ),
                                          // Warning message. TODO: Either use for something or remove
                                          if (false) ...[
                                            const SizedBox(height: 7),
                                            SizedBox(
                                              width: 144,
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  const Icon(
                                                    Icons.error_outline,
                                                    size: 14,
                                                    color: Color(0xFFF32357),
                                                  ),
                                                  const SizedBox(width: 3),
                                                  Expanded(
                                                    child: Text(
                                                      item.productDescription!,
                                                      style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w400,
                                                        height: 14 / 11,
                                                        letterSpacing: 0.4,
                                                        color: Color(0xFFF32357),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Increment quantity button
                                      SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: IconButton(
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            padding: EdgeInsets.zero,
                                          ),
                                          icon: const Icon(
                                            Icons.add,
                                            size: 16,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _updateLineItemQuantity(cart.id, item.id, item.quantity+1);
                                            });
                                          },
                                        ),
                                      ),
                                      // Quantity display
                                      Text(
                                        '${item.quantity}',
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          height: 22 / 15,
                                          letterSpacing: 0.4,
                                          color: Color(0xFF312F2F),
                                        ),
                                      ),
                                      // Decrement quantity button
                                      SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: IconButton(
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            padding: EdgeInsets.zero,
                                          ),
                                          icon: const Icon(
                                            Icons.remove,
                                            size: 16,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            if (item.quantity > 1) {
                                              setState(() {
                                                _updateLineItemQuantity(cart.id, item.id, item.quantity-1);
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (index < items.length - 1) const SizedBox(height: 15),
                        ],
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No data found.'));
                }
              },
            ),

            const SizedBox(height: 150), // Add padding at bottom for button
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              Colors.white.withOpacity(0),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Container(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color(0xFF111111),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 4,
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(30),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(76, 11, 76, 5),
                          child: SizedBox(
                            height: 60,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Pay Now',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    height: 22 / 20,
                                    letterSpacing: 0.4,
                                    color: Colors.white,
                                  ),
                                ),
                                FutureBuilder<Cart?>(
                                  future: _cartFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(child: Text('Error: ${snapshot.error}'));
                                    } else if (snapshot.hasData) {
                                      final cart = snapshot.data!;
                                      final items = cart.items;

                                      if (items.isEmpty) {
                                        return const Center(child: Text('Your cart is empty.'));
                                      }

                                      return Text(
                                        'in total ${cart.total}€',
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          height: 22 / 12,
                                          letterSpacing: 0.4,
                                          color: Colors.white,
                                        ),
                                      );
                                    } else {
                                      return const Center(child: Text('No data found.'));
                                    }
                                  },
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CartItem {
  final String name;
  final double price;
  final String image;
  int quantity;
  final String? warning;

  CartItem({
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
    this.warning,
  });
}
