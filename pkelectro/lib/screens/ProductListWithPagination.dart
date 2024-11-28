import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pkelectro/models/products/all_product_res_model.dart';
import 'package:pkelectro/widgets/khmer_date.dart';

class ProductListWithPagination extends StatefulWidget {
  @override
  _ProductListWithPaginationState createState() =>
      _ProductListWithPaginationState();
}

class _ProductListWithPaginationState extends State<ProductListWithPagination> {
  final String apiUrl = 'https://pkapi.pkelectro.com/api/products/allNormal';
  List<ListEmployee> productList = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response =
      await http.get(Uri.parse('$apiUrl?page=$currentPage&limit=10'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final productResModel = NormalProductResModel.fromJson(data);

        setState(() {
          productList.addAll(productResModel.listEmployee ?? []);
          currentPage++;
          hasMore = productResModel.listEmployee?.isNotEmpty ?? false;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      print('Error fetching products: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Products'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blueAccent.shade200,
              Colors.white,
            ],
          ),
        ),
        child: productList.isEmpty && isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: productList.length + (hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == productList.length) {
                    fetchProducts();
                    return Center(child: CircularProgressIndicator());
                  }

                  final product = productList[index];
                  return ProductCard(product: product);
                },
              ),
            ),
            if (isLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
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
        : 'https://pkapi.pkelectro.com/images/default.png';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10),
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.tiltle ?? 'No Name',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '\$${product.price}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '\$${product.cost ?? '0.00'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.date_range_rounded, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        KhmerDate(
                          dateTime: DateTime.parse(
                              product.createAt ?? DateTime.now().toString()),
                        ),
                      ],
                    ),
                    Text(
                      product.note ?? 'No Name',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.teal
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              // Button
              ElevatedButton(
                onPressed: () {
                  // Add action here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Order Now",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
