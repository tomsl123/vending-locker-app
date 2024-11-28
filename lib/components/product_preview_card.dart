
// Similar items widget
import 'package:flutter/material.dart';
import 'package:vending_locker_app/data/product.dart';
import 'package:vending_locker_app/services/product_service.dart';

class ProductPreviewCard extends StatefulWidget {
  final String imageUrl;
  final String name;
  final double price;
  bool isFavorited = false;
  final List<String> category;
  final String location;

  ProductPreviewCard({super.key, required this.imageUrl, required this.name, required this.price, required this.category, required this.location});

  @override
  ProductPreviewCardState createState() => ProductPreviewCardState();
}

class ProductPreviewCardState extends State<ProductPreviewCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,     // fixed width for each item
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // use minimum space needed
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFF5F5F5),
                ),
                child: Stack (
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Center(
                          child: Image.asset(
                            widget.imageUrl,
                            fit: BoxFit.contain, // added to control image sizing
                          ),
                        ),
                      ),
                      // Favorite button
                      Positioned(
                        top: 8,
                        left: 8,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              widget.isFavorited = !widget.isFavorited;
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center (
                                child: Icon(
                                  widget.isFavorited ? Icons.favorite : Icons.favorite_border,
                                  color: widget.isFavorited ? Color(0xFFF32357) : Color(0xFFF32357),
                                  size: 19,
                                ),
                              )
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
                            _addToCart(widget, context);
                          },
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.add,
                              color: Color(0xFF5271FF),
                            ),
                          ),
                        ),
                      )
                    ]
                )
            ),
            // Product name and price
            SizedBox(height: 4),
            Text(
              widget.name,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500),
              maxLines: 3,          // limit text to 3 lines
              overflow: TextOverflow.ellipsis,  // show ... if text overflows
            ),
            SizedBox(height: 4),
            Text(
              '€${widget.price.toStringAsFixed(2)}',
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF312F2F)),
            ),
          ],
        ),
      ),
    );
  } // build
}