import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: const CartPage(),
    );
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String selectedLocation = 'SHED';
  String selectedSection = 'A';
  String selectedFloor = '1';

  List<CartItem> items = [
    CartItem(
      name: 'Gel Ink Ballpoint Pen (Black)',
      price: 4.00,
      image: 'assets/pen.png',
      quantity: 1,
    ),
    CartItem(
      name: 'Notebook',
      price: 8.00,
      image: 'assets/pen.png',
      quantity: 1,
      warning: 'This item is not available at SHED A 1',
    ),
    CartItem(
      name: 'Notebook',
      price: 8.00,
      image: 'assets/pen.png',
      quantity: 1,
      warning: 'This item is not available at SHED A 1',
    ),
    CartItem(
      name: 'Notebook',
      price: 8.00,
      image: 'assets/pen.png',
      quantity: 1,
      warning: 'This item is not available at SHED A 1',
    ),
    CartItem(
      name: 'Notebook',
      price: 8.00,
      image: 'assets/pen.png',
      quantity: 1,
      warning: 'This item is not available at SHED A 1',
    ),
  ];

  double get total =>
      items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cart',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            height: 16 / 28,
            letterSpacing: 0.4,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Color(0xFF312F2F),
                        size: 25,
                      ),
                      onPressed: () {},
                    ),
                    Positioned(
                      right: 3,
                      top: 6,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFEBD59),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '2',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              height: 16 / 10,
                              letterSpacing: 0.4,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 35),
                  const Text(
                    'Please select a location for pickup',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 16 / 15,
                      letterSpacing: 1.0,
                      color: Color(0xFF312F2F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Building',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 16 / 12,
                      letterSpacing: 1.0,
                      color: Color(0xFF312F2F),
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomSegmentedButton(
                    options: const ['SHED', 'Hall', 'Cube'],
                    selectedOption: selectedLocation,
                    onOptionSelected: (value) {
                      setState(() {
                        selectedLocation = value;
                      });
                    },
                    size: SegmentSize.md,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Section',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 16 / 12,
                                letterSpacing: 1.0,
                                color: Color(0xFF312F2F),
                              ),
                            ),
                            const SizedBox(height: 4),
                            CustomSegmentedButton(
                              options: const ['A', 'B', 'C', 'D'],
                              selectedOption: selectedSection,
                              onOptionSelected: (value) {
                                setState(() {
                                  selectedSection = value;
                                });
                              },
                              size: SegmentSize.sm,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Floor',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 16 / 12,
                                letterSpacing: 1.0,
                                color: Color(0xFF312F2F),
                              ),
                            ),
                            const SizedBox(height: 4),
                            CustomSegmentedButton(
                              options: const ['1', '2', '3', '4', '5'],
                              selectedOption: selectedFloor,
                              onOptionSelected: (value) {
                                setState(() {
                                  selectedFloor = value;
                                });
                              },
                              size: SegmentSize.sm,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          items.removeAt(index);
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
                        child: const Icon(Icons.delete,
                            color: Colors.white, size: 25),
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
                            Image.asset(
                              items[index].image,
                              width: 100,
                              height: 100,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 162,
                                      child: Text(
                                        items[index].name,
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
                                    Text(
                                      '€${items[index].price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        height: 14 / 13,
                                        letterSpacing: 0.4,
                                        color: Color(0xFF312F2F),
                                      ),
                                    ),
                                    if (items[index].warning != null) ...[
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
                                                items[index].warning!,
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
                                        items[index].quantity++;
                                      });
                                    },
                                  ),
                                ),
                                Text(
                                  '${items[index].quantity}',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    height: 22 / 15,
                                    letterSpacing: 0.4,
                                    color: Color(0xFF312F2F),
                                  ),
                                ),
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
                                      if (items[index].quantity > 1) {
                                        setState(() {
                                          items[index].quantity--;
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
                      image: const DecorationImage(
                        image: AssetImage('assets/mesh-gradient.png'),
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
                                Text(
                                  'in total ${total.toStringAsFixed(2)}€',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    height: 22 / 12,
                                    letterSpacing: 0.4,
                                    color: Colors.white,
                                  ),
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

enum SegmentSize { sm, md }

class CustomSegmentedButton extends StatelessWidget {
  final List<String> options;
  final String selectedOption;
  final Function(String) onOptionSelected;
  final SegmentSize size;

  const CustomSegmentedButton({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
    this.size = SegmentSize.md,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F4),
        borderRadius: size == SegmentSize.md
            ? BorderRadius.circular(15)
            : BorderRadius.circular(10),
      ),
      child: Row(
        children: options.asMap().entries.map((entry) {
          final option = entry.value;
          final isSelected = option == selectedOption;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: entry.key == 0 ? 0 : 2,
                right: entry.key == options.length - 1 ? 0 : 2,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onOptionSelected(option),
                  borderRadius: size == SegmentSize.md
                      ? BorderRadius.circular(15)
                      : BorderRadius.circular(10),
                  child: Container(
                    height: size == SegmentSize.md ? 43 : 35,
                    decoration: isSelected
                        ? BoxDecoration(
                            borderRadius: size == SegmentSize.md
                                ? BorderRadius.circular(15)
                                : BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              begin: Alignment(-0.7914, 0),
                              end: Alignment(1.2966, 0),
                              colors: [Color(0xFFFFBD59), Color(0xFFFFE1B3)],
                            ),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(2, 2),
                                blurRadius: 10,
                                color: Color(0x0D000000),
                              ),
                            ],
                          )
                        : null,
                    child: Center(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: size == SegmentSize.md ? 16 : 11,
                          fontWeight: FontWeight.w600,
                          height: size == SegmentSize.md ? 1 : 14 / 11,
                          letterSpacing: size == SegmentSize.md ? 1 : 0.4,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
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
