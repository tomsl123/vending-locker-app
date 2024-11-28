import 'package:flutter/material.dart';

import 'cart_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String user = 'David';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Hello $user!',
          style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              letterSpacing: 0.4),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
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
                      MaterialPageRoute(builder: (context) => const CartPage()),
                    );
                  },
                ),
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
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(
                    248, 248, 248, 1), // Background color of the search bar
                borderRadius: BorderRadius.circular(23.0), // Rounded corners
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
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Category',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black // TODO: Gradient
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
            const SizedBox(height: 15),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
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
            )
          ],
        ),
      ),
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
