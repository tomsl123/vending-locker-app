import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vending_locker_app/entities/product/model.dart';
import '../constants.dart';

class ProductPreviewCard extends StatefulWidget {
  final Product product;
  final bool isFavorite;
  final bool showCategory;
  final bool showLocation;
  final VoidCallback? onTap;

  const ProductPreviewCard({
    super.key,
    required this.product,
    this.isFavorite = false,
    this.showCategory = false,
    this.showLocation = false,
    this.onTap,
  });

  @override
  ProductPreviewCardState createState() => ProductPreviewCardState();
}

class ProductPreviewCardState extends State<ProductPreviewCard> {
  final cartItems = <Product>[];
  late bool _isFavorite = false;
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final savedFavorite =
        await asyncPrefs.getBool('favorite_${widget.product.id}');
    if (mounted && savedFavorite != null) {
      setState(() {
        _isFavorite = savedFavorite;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    await asyncPrefs.setBool('favorite_${widget.product.id}', _isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    Map<String, int> quantitiesByLocation =
        product.variants.fold<Map<String, int>>({}, (map, variant) {
      variant.getQuantitiesByLocation().forEach((locationId, quantity) {
        final locationName = Constants.locationIds[locationId] ?? locationId;
        map[locationName] = (map[locationName] ?? 0) + quantity;
      });
      return map;
    });

    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 150,
        height: 240,
        child: Padding(
          padding: EdgeInsets.all(6),
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
                          product.images.isNotEmpty
                              ? product.images[0].url
                              : '',
                          fit: BoxFit.contain, // added to control image sizing
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.broken_image,
                                size: 48, color: Colors.grey);
                          },
                        ),
                      ),
                    ),
                    // Favorite button
                    Positioned(
                      top: 8,
                      left: 8,
                      child: GestureDetector(
                        onTap: _toggleFavorite,
                        child: Container(
                          padding: EdgeInsets.all(4), // Space inside the circle
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            shape: BoxShape.circle, // Circular shape
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.08), // Subtle shadow
                                blurRadius: 8, // Blurred shadow edges
                                spreadRadius: 2, // Shadow distance
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              _isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Color(0xFFFF404E), // Heart color
                              size: 23, // Icon size
                            ),
                          ),
                        ),
                      ),
                    ),
                    // plus button
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                          padding: EdgeInsets.all(4), // Space inside the circle
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            shape: BoxShape.circle, // Circular shape
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.08), // Subtle shadow
                                blurRadius: 8, // Blurred shadow edges
                                spreadRadius: 2, // Shadow distance
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add, // "Add" icon for the cart
                              color: Color(0xFF4C91FF), // Icon color (blue)
                              size: 23, // Icon size
                            ),
                          )),
                    ),
                  ])),
              // Product name and price
              SizedBox(height: 8),
              Text(
                product.title,
                style: TextStyle(fontSize: 12),
                maxLines: 2, // limit text to 2 lines
                overflow: TextOverflow.ellipsis, // show ... if text overflows
              ),
              Text(
                '€${product.variants.first.calculatedPrice?.calculatedAmount}',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111111)),
              ),
              if (widget.showLocation)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_city_rounded,
                      size: 16,
                      color: Color(0xFF111111),
                    ),
                    SizedBox(width: 4),
                    Text(
                      quantitiesByLocation.entries
                          .map((entry) => "${entry.key}: ${entry.value}")
                          .join(", "),
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF111111),
                      ),
                    ),
                  ],
                ),
              if (widget.showCategory) SizedBox(height: 6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(76, 145, 255, 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  product.categories.first.name,
                  style: TextStyle(
                      color: Color.fromRGBO(76, 145, 255, 1), fontSize: 9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } // build
}
