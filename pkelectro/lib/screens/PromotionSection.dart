import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pkelectro/models/products/trendingproduct_res_model.dart';
import 'package:pkelectro/screens/TrendingProductDetailPage.dart';
// Fetch trending products from API
Future<List<ListTrending>> fetchTrendingProducts() async {
  final response = await http.get(Uri.parse('https://pkapi.pkelectro.com/api/products/trending'));
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final trendingProductResModel = TrendingProductResModel.fromJson(data);
    return trendingProductResModel.listTrending ?? [];
  } else {
    throw Exception('Failed to load trending products');
  }
}

class PromotionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ListTrending>>(
      future: fetchTrendingProducts(), // Fetch trending products here
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6, // Number of shimmer placeholders
              itemBuilder: (context, index) {
                // return ProductShimmers();
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Products Promotion Found'));
        }

        final productTrending = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Trending Products", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.orange)),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productTrending.length,
                  itemBuilder: (context, index) {
                    return ProductTrending(producttrending: productTrending[index]); // Corrected here
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
// Product Card Widget
class ProductTrending extends StatelessWidget {
  final ListTrending producttrending;

  ProductTrending({required this.producttrending});

  @override
  Widget build(BuildContext context) {
    final String imagePath = 'https://pkapi.pkelectro.com/images/';
    final String imageUrl = producttrending.thumnail != null
        ? '$imagePath${producttrending.thumnail}'
        : 'https://pkapi.pkelectro.com/images/default.jpeg'; // Fallback image

    return GestureDetector(
      onTap: () {
        // Navigate to Product Detail Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrendingProductDetailPage(productTrending: producttrending),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5,
                spreadRadius: 2,
                offset: Offset(2, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Icon(Icons.favorite_border, color: Colors.orange),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${producttrending.price} \$', // Display price
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    if (producttrending.cost != null)
                      Text(
                        '${producttrending.cost} \$', // Display old price if available
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    SizedBox(height: 4),
                    Text(
                      producttrending.tiltle ?? 'No Name', // Display name or default text
                      style: TextStyle(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
