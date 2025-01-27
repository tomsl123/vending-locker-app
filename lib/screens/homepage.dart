import 'package:flutter/material.dart';
import 'package:vending_locker_app/components/product_preview_card.dart';

import '../components/custom_segmented_button.dart';
import '../constants.dart';
import '../entities/product/model.dart';
import '../entities/product/service.dart';
import '../entities/cart/service.dart';
import '../entities/cart/model.dart';
import 'cart_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'item_detail_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String user = 'David';
  bool isLocationModalVisible = false;
  String selectedLocation = 'SHED';
  String selectedSection = 'A';
  String selectedFloor = '1';
  String selectedLocationId = Constants.locationIds.entries
      .firstWhere((entry) => entry.value == 'SHED A1',
          orElse: () => MapEntry("", ""))
      .key;

  final ProductService _productService = ProductService();
  final CartService _cartService = CartService();
  late Future<List<Product>> _productsFuture;
  late Future<Cart?> _cartFuture;
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  @override
  void initState() {
    super.initState();
    // Initialize with default location first
    _productsFuture = Future.value(<Product>[]);
    _cartFuture = Future.value(null);
    _loadSavedLocation();
    _loadCart();
  }

  Future<void> _loadCart() async {
    String cartId = await _cartService.getOrCreateCartId();
    print(cartId);
    setState(() {
      _cartFuture = _cartService.getById(cartId);
    });
  }

  Future<void> _loadSavedLocation() async {
    final savedLocation = await asyncPrefs.getString('selectedLocation');
    final savedSection = await asyncPrefs.getString('selectedSection');
    final savedFloor = await asyncPrefs.getString('selectedFloor');

    setState(() {
      selectedLocation = savedLocation ?? 'SHED';
      selectedSection = savedSection ?? 'A';
      selectedFloor = savedFloor ?? '1';
      final locationString = '$selectedLocation $selectedSection$selectedFloor';
      selectedLocationId = Constants.locationIds.entries
          .firstWhere((entry) => entry.value == locationString,
              orElse: () => MapEntry("", ""))
          .key;
      _productsFuture = _productService.listByLocation(selectedLocationId);
    });
  }

  Future<void> _refreshProducts() async {
    setState(() {
      String locationString =
          '$selectedLocation $selectedSection$selectedFloor';
      selectedLocationId = Constants.locationIds.entries
          .firstWhere((entry) => entry.value == locationString,
              orElse: () => MapEntry("", ""))
          .key;
      '$selectedLocation $selectedSection$selectedFloor';
      _productsFuture = _productService.listByLocation(selectedLocationId);
    });
  }

  void toggleLocationModal() {
    setState(() {
      isLocationModalVisible = !isLocationModalVisible;
      if (!isLocationModalVisible) {
        _refreshProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hello $user!',
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    letterSpacing: 0.4),
              ),
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Color(0xFF312F2F),
                      size: 25,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CartPage()),
                      ).then((_) => _loadCart());
                    },
                  ),
                  FutureBuilder<Cart?>(
                    future: _cartFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.items.isNotEmpty) {
                        return Positioned(
                          right: 6,
                          top: 1,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Color(0xFFFF404E),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${snapshot.data!.items.map((item) => item.quantity).reduce((a, b) => a + b)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    },
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
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: toggleLocationModal,
                      child: Row(
                        children: [
                          Icon(
                            Icons.place,
                            size: 24,
                            color: Color.fromRGBO(76, 145, 255, 1),
                          ),
                          Text(
                            '$selectedLocation $selectedSection$selectedFloor',
                            style: TextStyle(
                              color: Color.fromRGBO(76, 145, 255, 1),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 3),
                          AnimatedRotation(
                            duration: Duration(milliseconds: 200),
                            turns: isLocationModalVisible ? 0.5 : 0,
                            child: Icon(
                              Icons.arrow_drop_down,
                              size: 24,
                              color: Color.fromRGBO(76, 145, 255, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(248, 248, 248,
                            1), // Background color of the search bar
                        borderRadius:
                            BorderRadius.circular(23.0), // Rounded corners
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {},
                          ),
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search items...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.tune_outlined),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshProducts,
                  color: const Color(0xFF5271FF),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height -
                            AppBar().preferredSize.height -
                            MediaQuery.of(context).padding.top -
                            100, // Approximate height of search bar and padding
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                const SizedBox(height: 22),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ShaderMask(
                                      // Adds gradient to text
                                      shaderCallback: (Rect bounds) {
                                        return LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color.fromRGBO(49, 47, 47, 1),
                                            Color.fromRGBO(82, 113, 255, 1),
                                          ],
                                        ).createShader(bounds);
                                      },
                                      child: Text(
                                        'Category',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: const Text(
                                        'See all',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Color.fromRGBO(49, 47, 47, 1)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            height: 128,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: const [
                                SizedBox(
                                  width: 20,
                                ),
                                // Element 1
                                CategoryItem(
                                  image: 'assets/images/categories/writing.png',
                                  title: 'Writing Supplies',
                                ),
                                SizedBox(width: 16), // Spacing between items

                                // Element 2
                                CategoryItem(
                                  image: 'assets/images/categories/paper.png',
                                  title: 'Paper Products',
                                ),
                                SizedBox(width: 16),

                                // Element 3
                                CategoryItem(
                                  image: 'assets/images/categories/craft.png',
                                  title: 'Art and Craft',
                                ),
                                SizedBox(width: 16),

                                // Element 4
                                CategoryItem(
                                  image: 'assets/images/categories/gear.png',
                                  title: 'Tech Gear',
                                ),
                                SizedBox(width: 16),

                                // Element 5
                                CategoryItem(
                                  image: 'assets/images/categories/store.png',
                                  title: 'Store & Sort',
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 37, 20, 0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: ShaderMask(
                                  // Adds gradient to text
                                  shaderCallback: (Rect bounds) {
                                    return LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color.fromRGBO(49, 47, 47, 1),
                                        Color.fromRGBO(82, 113, 255, 1),
                                      ],
                                    ).createShader(bounds);
                                  },
                                  child: Text(
                                    'Recommended for You',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: FutureBuilder<List<Product>>(
                                future: _productsFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(height: 50),
                                          CircularProgressIndicator(
                                            color: Color(0xFF5271FF),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  if (snapshot.hasError || !snapshot.hasData) {
                                    return Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(height: 50),
                                          Text(
                                            'Error loading products: ${snapshot.error}',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  if (snapshot.data!.isEmpty) {
                                    return Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(height: 50),
                                          Text(
                                            'There are no products for your location selection',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  return GridView.builder(
                                    itemCount: snapshot.data!.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 15.0,
                                            mainAxisSpacing: 15.0,
                                            childAspectRatio: 150 / 219),
                                    itemBuilder: (context, index) {
                                      final product = snapshot
                                          .data![index];
                                      return ProductPreviewCard(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetailPage(
                                                        productId:
                                                            product.id)),
                                          ).then((_) => _loadCart());
                                        },
                                        product: product,
                                        showCategory: true,
                                        showLocation: true,
                                      );
                                    },
                                  );
                                },
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        if (isLocationModalVisible)
          Stack(
            children: [
              GestureDetector(
                onTap: toggleLocationModal,
                child: Container(
                  color:
                      Colors.black.withOpacity(0.37), // Full-screen dim effect
                ),
              ),
              Positioned(
                top: AppBar().preferredSize.height +
                    MediaQuery.of(context).padding.top +
                    30,
                left: 0,
                right: 0,
                child: Container(
                  height: 241,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(211, 215, 222, 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 27),
                        const Text(
                          'Please select a location for pickup',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            height: 16 / 15,
                            letterSpacing: 1.0,
                            color: Color(0xFF312F2F),
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 23),
                        const Text(
                          'Building',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 16 / 12,
                            letterSpacing: 1.0,
                            color: Color(0xFF312F2F),
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 5),
                        CustomSegmentedButton(
                          options: const ['SHED', 'Hall', 'Cube'],
                          selectedOption: selectedLocation,
                          onOptionSelected: (value) {
                            setState(() => selectedLocation = value);
                            asyncPrefs.setString('selectedLocation', value);
                          },
                          size: SegmentSize.md,
                        ),
                        const SizedBox(height: 18),
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
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  CustomSegmentedButton(
                                    options: const ['A', 'B', 'C', 'D'],
                                    selectedOption: selectedSection,
                                    onOptionSelected: (value) {
                                      setState(() => selectedSection = value);
                                      asyncPrefs.setString(
                                          'selectedSection', value);
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
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  CustomSegmentedButton(
                                    options: const ['1', '2', '3', '4', '5'],
                                    selectedOption: selectedFloor,
                                    onOptionSelected: (value) {
                                      setState(() => selectedFloor = value);
                                      asyncPrefs.setString(
                                          'selectedFloor', value);
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
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String image;
  final String title;

  const CategoryItem({
    super.key,
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74,
      height: 128,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(213, 220, 250, 0.34),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Title
          Text(
            title,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(51, 51, 51, 1)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
