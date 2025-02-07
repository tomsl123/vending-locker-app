import 'package:flutter/material.dart';
import 'package:vending_locker_app/components/product_preview_card.dart';
import 'package:vending_locker_app/entities/product/model.dart';
import 'package:vending_locker_app/entities/product/service.dart';

import '../constants.dart';
import '../screens/item_detail_page.dart';

class SearchResultPage extends StatefulWidget {
  final String searchQuery;
  final String locationId;

  const SearchResultPage({
    super.key,
    required this.searchQuery,
    required this.locationId,
  });

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final ProductService _productService = ProductService();
  late Future<List<Product>> _searchResultsFuture;

  @override
  void initState() {
    super.initState();
    _searchResultsFuture = _productService.searchProducts(
      widget.searchQuery,
      widget.locationId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Results for "${widget.searchQuery}"',
          style: const TextStyle(
            color: Color(0xFF111111),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF111111)),
      ),
      body: FutureBuilder<List<Product>>(
        future: _searchResultsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4C91FF),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Error loading results: ${snapshot.error}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            final locationName = Constants.locationIds[widget.locationId] ?? 'the selected location';
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'No products found in $locationName matching "${widget.searchQuery}"',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF312F2F),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${snapshot.data!.length} ${snapshot.data!.length > 1? 'items': 'item'} found',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF312F2F),
                  ),
                ),
                const SizedBox(height: 20), // Space between count and grid
                Expanded(
                  child: GridView.builder(
                    itemCount: snapshot.data!.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
                      childAspectRatio: 150 / 240,
                    ),
                    itemBuilder: (context, index) {
                      final product = snapshot.data![index];
                      return ProductPreviewCard(
                        product: product,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                productId: product.id,
                              ),
                            ),
                          );
                        },
                        showCategory: true,
                        showLocation: true,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}