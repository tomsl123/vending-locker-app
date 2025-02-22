import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vending_locker_app/Screens/thank_you_page.dart';
import 'package:vending_locker_app/entities/order/model.dart';
import 'package:vending_locker_app/entities/order/service.dart';

class OrderPickupPage extends StatefulWidget {
  final String orderId;

  const OrderPickupPage({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderPickupPage> createState() => _OrderPickupPageState();
}

class _OrderPickupPageState extends State<OrderPickupPage> {
  final _orderService = OrderService();
  bool _isLoading = true;
  Order? _order;
  String? _error;
  Timer? _timer; // will be removed later

  @override
  void initState() {
    super.initState();
    _fetchOrder();
  }

  Future<void> _fetchOrder() async {
    try {
      final order = await _orderService.getById(widget.orderId);
      setState(() {
        _order = order;
        _isLoading = false;
      });

      // start timer only after successful fetch - will be removed later
      _timer = Timer(const Duration(seconds: 10), () {
        if (mounted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ThankYouPage()),
          );
        }
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override // will be removed later
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Text(
                    'Error loading order: $_error',
                    style: const TextStyle(color: Colors.red),
                  ),
                )
                : Column (
                children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF111111),
                          size: 24,
                        ),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Time to Grab Your Items!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.4,
                          color: Color(0xFF111111),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Double-check the details below to make sure you pick up everything",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.4,
                          color: Color(0xFF312F2F),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color.fromRGBO(76, 145, 255, 1),
                              Color.fromRGBO(255, 64, 78, 1),
                            ],
                          ).createShader(bounds);
                        },
                        child: const Text(
                          "Order details",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _buildBox('SHED C1', isLocation: true),
                          const SizedBox(width: 13),
                          _buildBox("Items: ${_order?.items.length}"),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _order?.items.length ?? 0,
                        separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final item = _order!.items[index];
                          return Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Image.network(
                                      item.thumbnail ?? '',
                                      width: 84,
                                      height: 84,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                        Container(
                                          width: 84,
                                          height: 84,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                          ),
                                          child: const Icon(Icons.image_not_supported),
                                        ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: SizedBox(
                                    height: 100,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 14),
                                          child: Text(
                                            "${item.productTitle} (${item.title})",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Poppins',
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "€${item.price}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Poppins',
                                                  color: Color(0xFF312F2F),
                                                ),
                                              ),
                                              const Spacer(),
                                              // Quantity aligned right
                                              Align(
                                                alignment: Alignment.bottomRight,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF4C91FF).withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    "${item.quantity}",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'Poppins',
                                                      color: Color(0xFF4C91FF),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  Widget _buildBox(String text, {bool isLocation = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFEBF3FF),
        borderRadius: BorderRadius.circular(30),
      ),
      alignment: Alignment.center,
      child: isLocation
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, color: Color(0xFF4C91FF), size: 16),
                const SizedBox(width: 4),
                Text(
                  text,
                  style: const TextStyle(
                    color: Color(0xFF4C91FF),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            )
          : Text(
              text,
              style: const TextStyle(
                color: Color(0xFF4C91FF),
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.4,
              ),
            ),
    );
  }
}