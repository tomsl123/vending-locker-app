import 'package:flutter/material.dart';
import 'package:vending_locker_app/Screens/homepage.dart';

class OrderConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 80),
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
              const SizedBox(height: 24),
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
              const SizedBox(height: 8),
              const Text(
                "Order number #123456",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  letterSpacing: 0.4,
                  color: Color(0xFF312F2F),
                ),
              ),
              const SizedBox(height: 19),
              Container(
                width: double.infinity,
                height: 106,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Pickup location",
                          style: _commonTextStyle,
                        ),
                        const Text(
                          "SHED A1",
                          style: _commonTextStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Order Status",
                          style: _commonTextStyle,
                        ),
                        const Text(
                          "Awaiting pickup",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            letterSpacing: 0.4,
                            color: Color(0xFFFF404E),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 19),
              Container(
                width: double.infinity,
                height: 209,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Next steps",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        letterSpacing: 0.4,
                        color: Color(0xFF111111),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStepRow("1", "Go to the location indicated above"),
                    const SizedBox(height: 15),
                    _buildStepRow("2", "Click 'Scan QR Code' Button below"),
                    const SizedBox(height: 15),
                    _buildStepRow("3", "Scan the QR code on the locker"),
                    const SizedBox(height: 15),
                    _buildStepRow("4", "Collect your order and enjoy!"),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Please pick up your order within 24 hours.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  letterSpacing: 0.4,
                  color: Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Unclaimed orders will be automatically canceled.",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  letterSpacing: 0.4,
                  color: Color(0xFF312F2F),
                ),
              ),
              const SizedBox(height: 35),
              _buildButton("Pick up later", Colors.white, const Color(0xFF242424), context),
              const SizedBox(height: 17),
              _buildButton("Scan QR Code", const Color(0xFF111111), Colors.white, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepRow(String number, String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFF4C91FF).withOpacity(0.26),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                letterSpacing: 0.4,
                color: Color(0xFF4C91FF),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
            letterSpacing: 0.4,
            color: Color(0xFF242424),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String text, Color bgColor, Color textColor, context) {
    return SizedBox(
      width: 242,
      height: 60,
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Homepage()),
            );
          },
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
        ),
      ),
    );
  }

  static const _commonTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
    letterSpacing: 0.4,
    color: Color(0xFF111111),
  );

  const OrderConfirmationPage({super.key});
}