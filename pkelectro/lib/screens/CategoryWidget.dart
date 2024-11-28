import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pkelectro/models/categories/category_res_model.dart';
import 'package:pkelectro/models/products/producByCateModel.dart';
import 'package:pkelectro/widgets/khmer_date.dart';

// Fetch Trending Products
Future<List<ListTitle>> fetchTrendingProducts() async {
  final response = await http.get(Uri.parse('https://pkapi.pkelectro.com/api/title/frontend'));
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final trendingProductResModel = CategoryResModel.fromJson(data);
    return trendingProductResModel.listTitle ?? [];
  } else {
    throw Exception('Failed to load trending products');
  }
}

// Fetch Products (Default or Search API)
Future<List<ListNews>> fetchProducts(String categoryId, String searchQuery) async {
  String url;

  if (searchQuery.isEmpty && categoryId.isEmpty) {
    url = 'https://pkapi.pkelectro.com/api/products/normal'; // Default API
  } else {
    url =
    'https://pkapi.pkelectro.com/api/products/?page=3&txtSearch=$searchQuery&txtCate=$categoryId&txtStatus='; // Search API
  }

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final productByCateResModel = ProductByCateResModel.fromJson(data);
    return productByCateResModel.listNews ?? [];
  } else {
    throw Exception('Failed to load products');
  }
}

// Category Page
class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ListTitle>>(
      future: fetchTrendingProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) {
                return Container(
                  width: 150,
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  color: Colors.grey[300],
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Products Promotion Found'));
        }

        final titles = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: titles.length,
              itemBuilder: (context, index) {
                return ProductTrending(
                  productTitle: titles[index],
                  onCategorySelected: (categoryId) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductsPage(categoryId: categoryId.toString()),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// Product Trending Card
class ProductTrending extends StatelessWidget {
  final ListTitle productTitle;
  final Function(int categoryId) onCategorySelected;

  ProductTrending({
    required this.productTitle,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (productTitle.id != null) {
          onCategorySelected(productTitle.id!);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Container(
          width: 120,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 6,
                spreadRadius: 2,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                productTitle.nameTitle ?? 'No Title',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Icon(
                Icons.computer_outlined,
                color: Colors.green,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Products Page
class ProductsPage extends StatefulWidget {
  final String categoryId;

  ProductsPage({required this.categoryId});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String _searchQuery = ''; // Stores the search query
  late Future<List<ListNews>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = fetchProducts(widget.categoryId, _searchQuery);
  }

  // Search handler
  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
      _futureProducts = fetchProducts(widget.categoryId, _searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products for Category'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _handleSearch,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<ListNews>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Products Found'));
          }

          final products = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 3 / 4,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(product: product);
              },
            ),
          );
        },
      ),
    );
  }
}

// Product Card Widget
class ProductCard extends StatelessWidget {
  final ListNews product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final String imagePath = 'https://pkapi.pkelectro.com/images/';
    final String imageUrl = product.thumnail?.isNotEmpty == true
        ? '$imagePath${product.thumnail}'
        : 'https://pkapi.pkelectro.com/images/default.jpeg';

    return GestureDetector(
      onTap: () {},
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
                      '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
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
                          dateTime: product.createAt != null
                              ? DateTime.parse(product.createAt!)
                              : DateTime.now(),
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
