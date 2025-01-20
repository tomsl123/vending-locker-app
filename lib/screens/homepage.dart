import 'package:flutter/material.dart';
import 'package:vending_locker_app/components/product_preview_card.dart';

import '../entities/product/model.dart';
import '../entities/product/service.dart';
import 'cart_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String user = 'David';

  final ProductService _productService = ProductService();
  late Future<List<Product>> _productsFuture = _productService.list();

  Future<void> _refreshProducts() async {
    setState(() {
      _productsFuture = _productService.list();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                );
              },
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          color: Color.fromRGBO(49, 47, 47, 1)),
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
                            padding:
                                EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: FutureBuilder<List<Product>>(
                              future: _productsFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF5271FF),
                                    ),
                                  );
                                }

                                if (snapshot.hasError || !snapshot.hasData) {
                                  return Center(
                                    child: Text(
                                      'Error loading products: ${snapshot.error}',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
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
                                    final product =
                                        snapshot.data![index]; // Access the product
                                    return ProductPreviewCard(
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
        ));
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
