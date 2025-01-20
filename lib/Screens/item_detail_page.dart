import 'package:flutter/material.dart';
import '../entities/product/model.dart';
import '../entities/product/service.dart';
import '/components/product_preview_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage(
      {super.key, this.productId = '0'}); // Default to first product for now

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int currentImageIndex = 0;
  int quantity = 1;
  bool showMaxQuantityWarning = false;
  bool isFavorite = false;
  final ProductService _productService = ProductService();
  late Future<Product> _productFuture; // for the main item of the page
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  @override
  void initState() {
    super.initState();
    _productFuture = _productService.getById(widget.productId);
    _loadFavoriteStatus();
    print('Product ID: ${widget.productId}');
  }

  Future<void> _loadFavoriteStatus() async {
    final bool? savedFavorite = await asyncPrefs.getBool('favorite_${widget.productId}');
    if (savedFavorite != null) {
      setState(() {
        isFavorite = savedFavorite;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
    });
    await asyncPrefs.setBool('favorite_${widget.productId}', isFavorite);
  }

  void updateQuantity(bool increase, int totalQuantity) {
    setState(() {
      if (increase) {
        if (quantity < totalQuantity) {
          quantity++;
          showMaxQuantityWarning = false;
        } else {
          showMaxQuantityWarning = true;
        }
      } else {
        if (quantity > 1) {
          quantity--;
          showMaxQuantityWarning = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Color(0xFFF32357),
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: FutureBuilder<Product>(
          future: _productFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF5271FF),
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: TextStyle(
                    color: Color(0xFFF32357),
                    fontSize: 14,
                  ),
                ),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: Text(
                  'Product not found',
                  style: TextStyle(
                    color: Color(0xFFF32357),
                    fontSize: 14,
                  ),
                ),
              );
            }
            final product = snapshot.data!;
            return Stack(
              children: [
                SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // main product images
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFF5F5F5),
                                      Color(0xFFF1F3FD),
                                      Color(0xFFF5F5F5),
                                    ], // Children
                                  ),
                                  
                                ),
                                child: Stack(
                                  alignment: Alignment.topLeft,
                                  children: [
                                    SizedBox(
                                      height: 380,
                                      child: PageView.builder(
                                        onPageChanged: (index) {
                                          setState(() {
                                            currentImageIndex = index;
                                          });
                                        },
                                        itemCount: product.images.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Image.network(
                                              product.images[index].url,
                                              fit: BoxFit.contain,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ], // Children
                                ),
                              ),
                              // Dots indicator
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    product.images.length,
                                        (index) => Container(
                                      margin: EdgeInsets.symmetric(horizontal: 4),
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: currentImageIndex == index
                                            ? Color(0xFF312F2F)
                                            : Color(0xFF312F2F).withOpacity(0.28),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Product details
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            product.title,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(35),
                                          ),
                                          child: Row(
                                            children: [
                                              _buildQuantityButton(
                                                  icon: Icons.remove,
                                                  onPressed: () => updateQuantity(
                                                      false,
                                                      1)),
                                              SizedBox(width: 10),
                                              Text(
                                                '$quantity',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              _buildQuantityButton(
                                                  icon: Icons.add,
                                                  onPressed: () => updateQuantity(
                                                      true, 1)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (showMaxQuantityWarning)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'Maximum quantity available in stock reached',
                                          style: TextStyle(
                                            color: Color(0xFFF32357),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    SizedBox(height: 6),
                                    Text(
                                      '€${product.variants.first.calculatedPrice.calculatedAmount}',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Padding(
                                      padding: EdgeInsets.only(left: 4),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFF5271FF),
                                            ),
                                          ),
                                          SizedBox(width: 3),
                                          Text(
                                            'In stock: 1',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF5271FF),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on_outlined,
                                            size: 20, color: Color(0xFF312F2F)),
                                        SizedBox(width: 4),
                                        Text(
                                          '1',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF312F2F),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: product.categories
                                          .map(
                                            (category) => Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFE7ECFF),
                                            borderRadius:
                                            BorderRadius.circular(16),
                                          ),
                                          child: Text(
                                            category.name,
                                            style: TextStyle(
                                              color: Color(0xFF5271FF),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      )
                                          .toList(),
                                    ),
                                    SizedBox(height: 14),
                                    _ShowProductInfo(
                                        description: product.title),
                                    SizedBox(height: 35),
                                    SimilarItemsWidget(),
                                    SizedBox(height: 24),
                                  ], // Children
                                ),
                              ),
                            ], // Children
                          ),
                        ),
                      ], // Children
                    )),
                Positioned(
                  // add to cart button fixed position
                  left: 0,
                  right: 0,
                  bottom: 46,
                  child: AddToCartButton(
                    onPressed: () {
                      // Add the product to the cart here
                    },
                  ),
                ),
              ], //
            );
          },
        ),
      ),
    );
  }

  // A reusable UI pattern for creating styled add and minus buttons with an icon and action
  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 37, // Keep the reduced size of the container
      height: 37, // Keep the reduced size of the container
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFBD59),
            Color(0xFFFFCB7C),
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: IconButton(
          icon: Icon(
            icon,
            weight: 900,
            size: 22,
          ),
          onPressed: onPressed,
          color: Colors.white,
        ),
      ),
    );
  }
}

// Show product information
class _ShowProductInfo extends StatefulWidget {
  final String description;

  const _ShowProductInfo({required this.description});

  @override
  _ShowProductInfoState createState() => _ShowProductInfoState();
}

class _ShowProductInfoState extends State<_ShowProductInfo> {
  bool _showProductInfo = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width:
          MediaQuery.of(context).size.width, // Makes container full width
          child: TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFFF5F5F4),
              // padding: EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.centerLeft, // Aligns content to the left
            ),
            onPressed: () {
              setState(() {
                _showProductInfo = !_showProductInfo;
              });
            },
            label: Text(
              'Product Information',
              style: TextStyle(
                color: Color(0xFF312F2F),
                fontSize: 16,
              ),
            ),
            icon: Icon(
              _showProductInfo ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: Color(0xFF312F2F),
            ),
          ),
        ),
        if (_showProductInfo)
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              widget.description,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF312F2F),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  } // build
} // _ShowProductInfoState

// Add to cart button
class AddToCartButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddToCartButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Add the product to the cart here
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          fixedSize: Size(242, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            image: const DecorationImage(
              image: AssetImage('assets/images/mesh-gradient.png'),
              fit: BoxFit.fill,
            ),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 4,
                color: Color.fromRGBO(0, 0, 0, 0.15),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'Add to Cart',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SimilarItemsWidget extends StatefulWidget {
  const SimilarItemsWidget({super.key});

  @override
  SimilarItemsWidgetState createState() => SimilarItemsWidgetState();
}

class SimilarItemsWidgetState extends State<SimilarItemsWidget> {
  final ProductService _productService = ProductService();
  late Future<List<Product>> _productsFuture; // Future for fetching products

  @override
  void initState() {
    super.initState();
    _productsFuture = _productService.list(); // Fetch products
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ShaderMask(
              // Adds gradient to text
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(49, 47, 47, 1),
                    Color.fromRGBO(75, 99, 211, 1),
                  ],
                ).createShader(bounds);
              },
              child: Text(
                'Similar Items',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors
                      .white, // The text color needs to be white for the gradient to show
                ),
              ),
            ),
          ),
          // Similar items list
          SizedBox(
            height: 290,
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF5271FF),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading products',
                      style: TextStyle(
                        color: Color(0xFFF32357),
                        fontSize: 14,
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No similar items found',
                      style: TextStyle(
                        color: Color(0xFF312F2F),
                        fontSize: 14,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final product = snapshot.data![index];
                    return ProductPreviewCard(
                      product: product,
                      isFavorite: false,
                    );
                  },
                );
              },
            ),
          ),
        ] // Children
    );
  } // build
}
