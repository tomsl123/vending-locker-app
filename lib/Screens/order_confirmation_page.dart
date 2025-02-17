import 'package:flutter/material.dart';
import 'package:vending_locker_app/Screens/orders_page.dart';
import 'package:vending_locker_app/screens/qr_scanner_page.dart';

class OrderConfirmationPage extends StatefulWidget {
  final String orderId;
  final String? displayId;
  final String status;
  final String location;

  const OrderConfirmationPage({
    super.key,
    required this.orderId,
    this.displayId,
    required this.status,
    required this.location
  });

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
            child: SafeArea(
              bottom: false, // Disable default SafeArea bottom padding
              minimum: const EdgeInsets.only(bottom: 46), // Custom bottom spacing
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4C91FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.check, size: 30, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Order Confirmed!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      letterSpacing: 0.4,
                      color: Color(0xFF111111),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Order number #${widget.displayId ?? widget.orderId}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      color: Color(0xFF312F2F),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 85,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBF3FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.only(left: 19, top: 15, bottom: 15, right: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Pickup location: ",
                              style: _commonTextStyle,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.location,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF111111),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text(
                              "Order Status: ",
                              style: _commonTextStyle,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              widget.status == "pending" ? "Awaiting pickup" : widget.status,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                color: Color(0xFF4C91FF),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShaderMask(shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFF4C91FF),
                              Color(0xFFFF404E),
                            ],
                          ).createShader(bounds);
                        },
                          child: const Text(
                            "Next steps",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              letterSpacing: 0.4,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _buildStepRow(Icons.location_on, "Go to the location indicated above"),
                        const SizedBox(height: 12),
                        _buildStepRow(Icons.touch_app, "Click 'Scan QR Code' Button below"),
                        const SizedBox(height: 12),
                        _buildStepRow(Icons.qr_code_scanner, "Scan the QR code on the locker"),
                        const SizedBox(height: 12),
                        _buildStepRow(Icons.inventory_rounded, "Collect your order and enjoy!"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Please pick up your order within 24 hours.",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            color: Color(0xFF111111),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Unclaimed orders will be automatically canceled.",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            height: 0.8,
                            color: Color(0xFF312F2F),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildButton(
                    "Pick up later",
                    Color(0xFFF0F0F0),
                    const Color(0xFF111111),
                    OrdersPage(),
                    context,
                    elevation: 0,),
                  const SizedBox(height: 16),
                  _buildButton(
                    "Scan QR Code",
                    const Color(0xFF111111), // bgColor is ignored due to decoration
                    Colors.white,
                    QRScannerPage(orderId: widget.orderId),
                    context,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/mesh-gradient.png'),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 4,
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            )
        ),
      ),
    );
  }
}

  Widget _buildStepRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: const Color(0xFF312F2F),
        ),
        const SizedBox(width: 15),
        Expanded(child:
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              color: Color(0xFF242424),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
      String text,
      Color bgColor,
      Color textColor,
      Widget destination,
      BuildContext context, {
        BoxDecoration? decoration,
        double elevation = 0,
      })
  {
    return SizedBox(
      width: 242,
      height: 60,
      child: Material(
        elevation: elevation,
        color: decoration == null ? bgColor : null,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => destination),
            );
          },
          child: decoration != null
              ? Container(
            decoration: decoration,
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  letterSpacing: 0.4,
                  color: textColor,
                ),
              ),
            ),
          )
              : Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                letterSpacing: 0.4,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  const _commonTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
    color: Color(0xFF111111),
  );
