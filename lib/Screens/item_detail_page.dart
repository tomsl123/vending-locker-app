import 'package:flutter/material.dart';
import 'package:vending_locker_app/components/variant_selector_button.dart';
import 'package:vending_locker_app/entities/cart/service.dart';
import '../entities/cart/model.dart';
import '../entities/product/model.dart';
import '../entities/product/service.dart';
import '/components/product_preview_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'package:like_button/like_button.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, this.productId = '0'});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int currentImageIndex = 0;
  int quantity = 0;
  bool showMaxQuantityWarning = false;
  bool increaseQuantityActive = false;
  bool decreaseQuantityActive = false;

  bool isFavorite = false;
  String selectedLocation = 'SHED';
  String selectedSection = 'A';
  String selectedFloor = '1';
  String selectedLocationId = Constants.locationIds.entries
      .firstWhere((entry) => entry.value == 'SHED A1',
          orElse: () => MapEntry("", ""))
      .key;
  final ProductService _productService = ProductService();
  late Future<Product> _productFuture;
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
  final CartService _cartService = CartService();
  late Future<(Product, void)> _combinedFuture;
  ProductVariant? selectedVariant;
  Cart? cart;
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    _productFuture = _productService.getById(widget.productId);
    _combinedFuture = Future.wait([
      _productFuture,
      _loadSavedLocation(),
    ]).then((results) {
      final product = results[0] as Product;
      selectedVariant = product.variants.first;

      _loadCart().then((initializedCart) {
        setState(() {
          cart = initializedCart;
          quantity = _cartService.getCartLineItemByVariantId(initializedCart.items, selectedVariant?.id)?.quantity ?? 1;
          updateQuantityButtons();
        });
      });

      return (product, null);
    });
    _loadFavoriteStatus();
  }

  Future<Cart> _loadCart() async {
    String cartId = await _cartService.getOrCreateCartId();
    return _cartService.getById(cartId);
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
    });
  }

  Future<void> _loadFavoriteStatus() async {
    final bool? savedFavorite =
        await asyncPrefs.getBool('favorite_${widget.productId}');
    if (savedFavorite != null) {
      setState(() {
        isFavorite = savedFavorite;
      });
    }
  }

  // Future<void> _toggleFavorite() async {
  //   setState(() {
  //     isFavorite = !isFavorite;
  //   });
  //   await asyncPrefs.setBool('favorite_${widget.productId}', isFavorite);
  // }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    try {
      // Toggle the favorite status
      setState(() {
        isFavorite = !isLiked;
      });

      // Save the new favorite status to SharedPreferences
      await asyncPrefs.setBool('favorite_${widget.productId}', isFavorite);

      // Return the new liked status
      return isFavorite;
    } catch (e) {
      // If there's an error, return the original liked status
      print('Error toggling favorite: $e');
      return isLiked;
    }
  }

  void updateQuantity(bool increase) {
    setState(() {
      if (increase && increaseQuantityActive) {
        quantity++;
      }
      else if (decreaseQuantityActive) {
        quantity--;
      }
    });
    updateQuantityButtons();
  }

  void updateQuantityButtons() {
    setState(() {
      increaseQuantityActive = quantity <
          (selectedVariant?.getQuantitiesByLocation()[selectedLocationId] ?? 0);
      decreaseQuantityActive = quantity > 1;
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
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: LikeButton(
              isLiked: isFavorite,
              onTap: onLikeButtonTapped,
              size: 30,
              circleColor: CircleColor(
                start: Color(0xFFFF404E),
                end: Color(0xFFFF404E),
              ),
              bubblesColor: BubblesColor(
                dotPrimaryColor: Color(0xFF4C91FF),
                dotSecondaryColor: Color(0xFFFF404E),
              ),
              likeBuilder: (isLiked) {
                return Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: Color(0xFFFF404E),
                  size: 30,
                );
              },
            ),
          )
          // IconButton(
          //   icon: Icon(
          //     isFavorite ? Icons.favorite : Icons.favorite_border,
          //     color: Color(0xFFFF404E),
          //   ),
          //   onPressed: _toggleFavorite,
          // ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: FutureBuilder<(Product, void)>(
          future: _combinedFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF4C91FF),
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: TextStyle(
                    color: Color(0xFFFF404E),
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
                    color: Color(0xFFFF404E),
                    fontSize: 14,
                  ),
                ),
              );
            }
            final product = snapshot.data!.$1;
            final totalStock = selectedVariant
                    ?.getQuantitiesByLocation()[selectedLocationId] ??
                0;

            Map<ProductOption, List<ProductOptionValue>> options = product.variants.fold<Map<ProductOption, List<ProductOptionValue>>>({}, (map, variant) {
              for (var optionValue in variant.options) {
                final option = product.options.firstWhere((o) => o.id == optionValue.optionId);
                map.putIfAbsent(option, () => []);
                if (!map[option]!.any((v) => v.id == optionValue.id)) {
                  map[option]!.add(optionValue);
                }
              }
              return map;
            });

            Map<String, int> quantitiesByLocation =
                product.variants.fold<Map<String, int>>({}, (map, variant) {
              variant.getQuantitiesByLocation().forEach((locationId, quantity) {
                final locationName =
                    Constants.locationIds[locationId] ?? locationId;
                map[locationName] = (map[locationName] ?? 0) + quantity;
              });
              return map;
            });
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
                              ],
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
                                              onPressed: () =>
                                                  updateQuantity(false),
                                              active:  decreaseQuantityActive
                                          ),
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
                                              onPressed: () =>
                                                  updateQuantity(true),
                                              active:  increaseQuantityActive
                                          ),
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
                                        color: Color(0xFFFF404E),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 6),
                                Text(
                                  '€${selectedVariant?.calculatedPrice?.calculatedAmount}',
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
                                          color: Color(0xFF4C91FF),
                                        ),
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        'In stock: $totalStock',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF4C91FF),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 3),
                                Row(
                                  children: [
                                    Icon(Icons.location_city_rounded,
                                        size: 20, color: Color(0xFF312F2F)),
                                    SizedBox(width: 4),
                                    Text(
                                      quantitiesByLocation.entries
                                          .map((entry) =>
                                              "${entry.key}: ${entry.value}")
                                          .join(", "),
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
                                            color: Color.fromRGBO(76, 145, 255, 0.1),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Text(
                                            category.name,
                                            style: TextStyle(
                                              color: Color(0xFF4C91FF),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                                SizedBox(height: 20),
                                Column(
                                  children: options.entries.map((option) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Select ${option.key.title}",
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFFADADAD),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children:
                                                option.value.map((value) {
                                              final variant = product.variants
                                                  .firstWhere((variant) =>
                                                      variant.options
                                                          .firstWhere((o) =>
                                                              o.optionId ==
                                                              option.key.id)
                                                          .id ==
                                                      value.id);
                                              bool isInStock =
                                                  (variant.getQuantitiesByLocation()[
                                                              selectedLocationId] ??
                                                          0) >
                                                      0;
                                              bool isSelected =
                                                  selectedVariant == variant;

                                              return Row(
                                                children: [
                                                  VariantSelectorButton(
                                                    text: value.value,
                                                    isSelected: isSelected,
                                                    onTap: () {
                                                      setState(() {
                                                        selectedVariant =
                                                            variant;
                                                        quantity = _cartService.getCartLineItemByVariantId(cart!.items, selectedVariant?.id)?.quantity ?? 1;
                                                        updateQuantityButtons();
                                                      });
                                                    },
                                                    isDisabled: !isInStock,
                                                  ),
                                                  SizedBox(width: 8),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                      ],
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: 14),
                                _ShowProductInfo(description: product.title),
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
                  child: Center(
                    child: ElevatedButton(
                      onPressed: _isAddingToCart || cart == null ? null : () async {
                        setState(() {
                          _isAddingToCart = true;
                        });

                        CartLineItem? cartLineItem = _cartService.getCartLineItemByVariantId(cart!.items, selectedVariant?.id);
                        try {
                          if (cartLineItem != null) {
                            await _cartService.setLineItemQuantity(
                                cart!.id, cartLineItem.id, quantity);
                          }
                          else {
                            await _cartService.addLineItem(
                                cart!.id, selectedVariant!.id, quantity);
                            cart = await _loadCart();
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: cartLineItem != null
                                  ? Text('Item quantity edited successfully!')
                                  : Text('Successfully added to cart!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } catch (e) {
                          print(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: cartLineItem != null
                                  ? Text('Failed to edit item quantity. Try again later.')
                                  : Text('Failed to add item to cart. Try again later.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } finally {
                          setState(() {
                            _isAddingToCart = false;
                          });
                        }
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
                          color: _isAddingToCart || cart == null ? Color(0xFF666666) : Color(0xFF111111),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 4,
                              color: Color.fromRGBO(0, 0, 0, 0.15),
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isAddingToCart || cart == null
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                cart == null ||
                                    _cartService.getCartLineItemByVariantId(cart!.items, selectedVariant?.id) == null
                                ? 'Add to Cart'
                                : 'Edit Quantity',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
    required bool active
  }) {
    return Container(
      width: 37, // Keep the reduced size of the container
      height: 37, // Keep the reduced size of the container
      decoration: BoxDecoration(
        color: active ? Color(0xFF111111) : Color(0xFFADADAD),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: IconButton(
          icon: Icon(
            icon,
            weight: 900,
            size: 22,
          ),
          onPressed: active ? onPressed : null,
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
                    Color.fromRGBO(76, 145, 255, 1),
                    Color.fromRGBO(255, 64, 78, 1),
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
                      color: Color(0xFF4C91FF),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading products',
                      style: TextStyle(
                        color: Color(0xFFFF404E),
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
