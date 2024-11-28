import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pkelectro/screens/CategoryWidget.dart';

class AllProductsPage extends StatefulWidget {
  @override
  _AllProductsPageState createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  late Future<List<dynamic>> categoriesFuture;
  late Future<List<dynamic>> productsFuture;
  String? selectedCategoryId; // To store the selected category ID

  @override
  void initState() {
    super.initState();
    categoriesFuture = fetchCategories();
    productsFuture = fetchProducts(); // Fetch products initially without a filter
  }

  // Fetch categories from API
  Future<List<dynamic>> fetchCategories() async {
    final response = await http.get(Uri.parse('https://pkapi.pkelectro.com/api/title/frontend'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['list_Title'] ?? [];
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Fetch products from API
  Future<List<dynamic>> fetchProducts({String? categoryId}) async {
    final uri = categoryId != null
        ? Uri.parse('https://pkapi.pkelectro.com/api/products/normal?category=$categoryId')
        : Uri.parse('https://pkapi.pkelectro.com/api/products/normal');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['list_Employee'] ?? [];
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Callback when a category is selected
  void onCategorySelected(int categoryId) {
    setState(() {
      selectedCategoryId = categoryId.toString();
      productsFuture = fetchProducts(categoryId: selectedCategoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Products'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Category Block at the Top
          FutureBuilder<List<dynamic>>(
            future: categoriesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: 50,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No Categories Found'));
              }

              final categories = snapshot.data!;
              return Container(
                height: 60,
                margin: EdgeInsets.only(top: 10, bottom: 10),

                  child: CategoryPage(),

              );
            },
          ),
          // Products Section
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No Products Found'));
                }

                final products = snapshot.data!;
                return GridView.builder(
                  padding: EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final productName = product['Title'];
                    final productPrice = product['Price'];
                    final imageUrl = product['Thumbnail'] != null
                        ? 'https://pkapi.pkelectro.com/images/${product['Thumbnail']}'
                        : 'https://pkapi.pkelectro.com/images/default.png';

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            child: Image.network(
                              imageUrl,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              productName ?? 'Unnamed Product',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '\$${productPrice?.toStringAsFixed(2) ?? '0.00'}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
