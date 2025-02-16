import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vending_locker_app/screens/order_pickup_page.dart';
import 'package:vending_locker_app/constants.dart';

class QRScannerPage extends StatefulWidget {
  final String orderId;

  const QRScannerPage({
    super.key,
    required this.orderId,
  });

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  late MobileScannerController controller;
  bool _isNavigated = false; // Flag is no longer strictly necessary, but useful for debugging

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController();
    _isNavigated = false;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (_isNavigated) return; // Still useful to prevent re-entry

              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  debugPrint('QR Code found! ${barcode.rawValue}');
                  _isNavigated = true; // Keep this for debugging if needed
                  controller.stop(); // Stop the scanner immediately

                  // Navigate to the OrderPickupPage with the actual orderId
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderPickupPage(
                        orderId: widget.orderId,
                      ),
                    ),
                  ).then((_) {
                    // Restart the scanner when returning from OrderPickupPage
                    controller.start();
                    _isNavigated = false; // Reset the flag
                  });
                  return; // Exit the loop after the first valid barcode
                }
              }
            },
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Please scan the QR code on the locker",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),
                Center(
                  child: SizedBox(
                    width: 280,
                    height: 280,
                    child: Stack(
                      children: [
                        _buildCorner(Alignment.topLeft, -1, -1),
                        _buildCorner(Alignment.topRight, 1, -1),
                        _buildCorner(Alignment.bottomLeft, -1, 1),
                        _buildCorner(Alignment.bottomRight, 1, 1),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: IconButton(
                    icon: const Icon(
                      Icons.flash_off,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: () => controller.toggleTorch(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(Alignment alignment, double x, double y) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(alignment == Alignment.topLeft ? 8 : 0),
            topRight: Radius.circular(alignment == Alignment.topRight ? 8 : 0),
            bottomLeft: Radius.circular(alignment == Alignment.bottomLeft ? 8 : 0),
            bottomRight: Radius.circular(alignment == Alignment.bottomRight ? 8 : 0),
          ),
        ),
        child: CustomPaint(
          painter: CornerPainter(x, y),
        ),
      ),
    );
  }
}

class CornerPainter extends CustomPainter {
  final double x;
  final double y;

  CornerPainter(this.x, this.y);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (x < 0) {
      path.moveTo(size.width, y < 0 ? 0 : size.height);
      path.lineTo(0, y < 0 ? 0 : size.height);
      path.lineTo(0, y < 0 ? size.height * 0.6 : size.height * 0.4);
    } else {
      path.moveTo(0, y < 0 ? 0 : size.height);
      path.lineTo(size.width, y < 0 ? 0 : size.height);
      path.lineTo(size.width, y < 0 ? size.height * 0.6 : size.height * 0.4);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 