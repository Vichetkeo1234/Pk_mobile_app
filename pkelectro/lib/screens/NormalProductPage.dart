// Product Card Widget
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pkelectro/models/products/product_res_model.dart';
import 'package:pkelectro/screens/ProductDetailPage.dart';
import 'package:pkelectro/widgets/khmer_date.dart';
Future<List<ListEmployee>> fetchProducts() async {
  final response = await http.get(Uri.parse('https://pkapi.pkelectro.com/api/products/normal'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final productResModel = ProductResModel.fromJson(data);
    return productResModel.listEmployee ?? [];
  } else {
    throw Exception('Failed to load products');
  }
}
class NormalProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ListEmployee>>(
      future: fetchProducts(), // Fetch trending products here
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
        final listProducts = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'All Products',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 400, // Adjust as needed
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: listProducts.length,
                  itemBuilder: (context, index) {
                    final product = listProducts[index];
                    return ProductCard(product: product);
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
class ProductCard extends StatelessWidget {
  final ListEmployee product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final String imagePath = 'https://pkapi.pkelectro.com/images/';
    final String imageUrl = product.thumnail != null
        ? '$imagePath${product.thumnail}'
        : 'https://pkapi.pkelectro.com/images/default.jpeg';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Icon(Icons.favorite_border, color: Colors.blueAccent),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${product.price}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      product.tiltle ?? 'No Name',
                      style: TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        KhmerDate(
                          dateTime: DateTime.parse(
                              product.createAt ?? DateTime.now().toString()),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.star, size: 14, color: Colors.yellow),
                      ],
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
