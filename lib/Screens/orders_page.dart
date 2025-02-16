import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vending_locker_app/constants.dart';
import 'package:vending_locker_app/entities/order/service.dart';

import '../entities/order/model.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _isOngoingSelected = true;

  final OrderService _orderService = OrderService();
  late Future<List<Order>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _orderService.listByStatuses(['pending']);
  }

  void _reloadOrders(bool ongoingSelected) {
    setState(() {
      _isOngoingSelected = ongoingSelected;
      _ordersFuture = _orderService.listByStatuses(
          ongoingSelected ? ['pending'] : ['completed', 'canceled']
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The app bar has a back icon button and a title.
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Go back when tapped.
            Navigator.pop(context);
          },
        ),
        title: Text(
          'My Orders',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
            color: Color(0xFF111111),
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      // The default horizontal padding is 20.
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            _buildSegmentedControl(),
            SizedBox(height: 28),
            Expanded(
              child: FutureBuilder<List<Order>>(
                future: _ordersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loader while waiting.
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(child: Text('Error loading orders'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No orders found'));
                  } else {
                    final orders = snapshot.data!;
                    // The list of orders is separated by 15px.
                    return ListView.separated(
                      itemCount: orders.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 15),
                      itemBuilder: (context, index) {
                        return _buildOrderItem(orders[index], _isOngoingSelected);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the segmented control.
  Widget _buildSegmentedControl() {
    return Container(
      height: 43,
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F4),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          // "Ongoing orders" segment.
          Expanded(
            child: GestureDetector(
              onTap: () => _reloadOrders(true),
              child: Container(
                decoration: _isOngoingSelected
                    ? BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF4C91FF),
                      Color(0xFFFF404E),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                )
                    : null,
                alignment: Alignment.center,
                child: Text(
                  'Ongoing orders',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                    color: _isOngoingSelected
                        ? Colors.white
                        : Color(0xFF4C91FF),
                  ),
                ),
              ),
            ),
          ),
          // "Past orders" segment.
          Expanded(
            child: GestureDetector(
              onTap: () => _reloadOrders(false),
              child: Container(
                decoration: !_isOngoingSelected
                    ? BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF4C91FF),
                      Color(0xFFFF404E),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                )
                    : null,
                alignment: Alignment.center,
                child: Text(
                  'Past orders',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                    color: !_isOngoingSelected
                        ? Colors.white
                        : Color(0xFF4C91FF),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build a single order item.
  Widget _buildOrderItem(Order order, bool active) {
    final remainingTime = Duration(hours: 24) - DateTime.now().difference(order.createdAt);
    final formattedRemainingTime = "${remainingTime.inHours.toString().padLeft(2, '0')}:${(remainingTime.inMinutes % 60).toString().padLeft(2, '0')}";

    return Container(
      height: active ? 320 : 215,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(23, 11, 11, 11),
      decoration: BoxDecoration(
        color: active ? Color(0xFFECF3FF) : Color(0xFFF0F3FA), // Adjust background color
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top row: date text and scan button (only in active state).
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Date text with extra top padding.
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    DateFormat('dd.MM.yyyy').format(order.createdAt),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                      color: Color(0xFF312F2F),
                    ),
                  ),
                ),
                if (active) ...[
                  SizedBox(width: 13),
                  // Square scan button.
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.qr_code_scanner,
                        color: Color(0xFF4C91FF),
                      ),
                      onPressed: () {
                        // Handle scan action here.
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Row with the status dot (only if active), status text, small dot, and items count.
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (active) ...[
                  // 10x10 circular dot.
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Color(0xFF4C91FF),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 5),
                ],
                Text(
                  Constants.statuses[order.status]!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                    color: active ? Color(0xFF4C91FF) : Colors.black, // Adjust status color
                  ),
                ),
                SizedBox(width: 10),
                // 3x3 dot (always present).
                Container(
                  width: 3,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Color(0xFF2C2C2C),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.4,
                    color: Color(0xFF312F2F),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Row with order images.
          _buildImagesRow(order.items
              .map((item) => item.thumbnail ?? 'default') // TODO: placeholder when no image
              .toList()),
          SizedBox(height: 16),
          // Pickup time remaining text (only if active).
          if (active)
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Pickup time remaining: $formattedRemainingTime',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4,
                  color: Color(0xFF4C91FF),
                ),
              ),
            ),
          if (active) SizedBox(height: 15),
          // "Cancel order" button (only if active).
          if (active)
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 145,
                height: 39,
                child: ElevatedButton(
                  onPressed: () async {
                    await _orderService.cancelOrder(order.id);
                    setState(() {
                      _ordersFuture = _orderService.listByStatuses(['pending']);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4C91FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Cancel order',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.4,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }


  // Build the row of images.
  Widget _buildImagesRow(List<String> images) {
    List<Widget> imageWidgets = [];
    int count = images.length;
    // If more than 4 images, show first 3 and then a placeholder.
    if (count > 4) {
      for (int i = 0; i < 3; i++) {
        imageWidgets.add(_buildImageItem(images[i]));
        imageWidgets.add(SizedBox(width: 10));
      }
      // The placeholder shows the extra count.
      imageWidgets.add(_buildPlaceholderImage('+${count - 3}'));
    } else {
      for (int i = 0; i < count; i++) {
        imageWidgets.add(_buildImageItem(images[i]));
        if (i != count - 1) {
          imageWidgets.add(SizedBox(width: 10));
        }
      }
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: imageWidgets),
    );
  }

  // Build a single image container.
  Widget _buildImageItem(String imageUrl) {
    return Container(
      width: 79,
      height: 112,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  // Build the placeholder for extra images.
  Widget _buildPlaceholderImage(String text) {
    return Container(
      width: 79,
      height: 112,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
            color: Color(0xFF5A5858),
          ),
        ),
      ),
    );
  }
}
