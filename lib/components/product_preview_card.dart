import 'package:flutter/material.dart';
import 'package:vending_locker_app/data/product.dart';
// import 'package:vending_locker_app/services/product_service.dart';

class ProductPreviewCard extends StatefulWidget {
  final Product product;
  final bool isFavorite;
  final bool showCategory;
  final bool showLocation;

  const ProductPreviewCard({
    super.key,
    required this.product,
    this.isFavorite = false,
    this.showCategory = false,
    this.showLocation = false
  });

  @override
  ProductPreviewCardState createState() => ProductPreviewCardState();
}

class ProductPreviewCardState extends State<ProductPreviewCard> {
  final cartItems = <Product>[]; // List to store cart items
  late bool _isFavorite; // Separate state variable

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite; // Initialize the state variable
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite; // Toggle state
    });
  }

  void _addToCart(Product product, BuildContext context) {
    setState(() {
      cartItems.add(product); // Add the item to the cart
    });

    // create overlay to show "Added to Cart" message at the top
    final overlay = Overlay.of(context);

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 80,
        left: 120,
        right: 120,
        child: Material(
          color: Colors.transparent,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              decoration: BoxDecoration(
                color: Color(0xFF5271FF), // Background color
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  'Added to Cart!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
        ),
      ),
    );

    // insert overlay
    overlay.insert(overlayEntry);

    // remove the overlay after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return SizedBox(
      width: 150, // fixed width for each item
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // use minimum space needed
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFF5F5F5),
                ),
                child: Stack(children: [
                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Center(
                      child: Image.network(
                        product.images.isNotEmpty ? product.images[0] : '',
                        fit: BoxFit.contain, // added to control image sizing
                        errorBuilder : (context, error, stackTrace) {
                          return Icon(Icons.broken_image, size: 48, color: Colors.grey);
                        },
                      ),
                    ),
                  ),
                  // Favorite button
                  Positioned(
                    top: 8,
                    left: 8,
                    child: InkWell(
                      onTap: _toggleFavorite,
                      child: Container(
                        padding: EdgeInsets.all(4), // Space inside the circle
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color
                          shape: BoxShape.circle, // Circular shape
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08), // Subtle shadow
                              blurRadius: 8, // Blurred shadow edges
                              spreadRadius: 2, // Shadow distance
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Color(0xFFF32357), // Heart color
                            size: 19, // Icon size
                          ),
                        ),
                      ),
                    ),
                  ),
                  // plus button
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () {
                        // When tapped, add to cart and show feedback
                        _addToCart(product, context);
                      },
                      child: Container(
                        width: 28, // Circle width
                        height: 28, // Circle height
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color
                          borderRadius: BorderRadius.circular(8), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08), // Subtle shadow
                              blurRadius: 8, // Blurred shadow edges
                              spreadRadius: 2, // Shadow distance
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.add, // "Add" icon for the cart
                          color: Color(0xFF5271FF), // Icon color (blue)
                          size: 20, // Icon size
                        ),
                      ),
                    ),
                  ),
                ]
              )
            ),
            // Product name and price
            SizedBox(height: 4),
            Text(
              product.name,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              maxLines: 2, // limit text to 2 lines
              overflow: TextOverflow.ellipsis, // show ... if text overflows
            ),
            SizedBox(height: 4),
            Text(
              '€${product.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 12, color: Color(0xFF312F2F)),
            ),
            if(widget.showLocation)
              SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.place,
                    size: 14,
                    color: Color.fromRGBO(49, 47, 47, 1),
                  ),
                  SizedBox(width: 4),
                  Text(
                    product.allLocationsString,
                    style: TextStyle(
                      fontSize: 10,
                      color: Color.fromRGBO(49, 47, 47, 1),
                    ),
                  ),
                ],
              ),
            if(widget.showCategory)
              SizedBox(height: 6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(231, 236, 255, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  product.category,
                  style: TextStyle(
                    color: Color.fromRGBO(82, 113, 255, 1),
                    fontSize: 9
                  ),
                ),
              )
          ],
        ),
      ),
    );
  } // build
}
