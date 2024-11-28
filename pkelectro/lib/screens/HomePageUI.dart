import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pkelectro/models/products/product_res_model.dart';
import 'package:pkelectro/screens/BannerCard.dart';
import 'package:pkelectro/screens/CategoryWidget.dart';
import 'package:pkelectro/screens/ProductDetailPage.dart';
import 'package:pkelectro/screens/ProductListWithPagination.dart';
import 'package:pkelectro/screens/PromotionSection.dart';
import 'package:pkelectro/widgets/khmer_date.dart';

// Cart State (List of products with quantities)
List<Map<String, dynamic>> cart = [];

// Fetch products from API
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

// Updated Home UI
class UpdatedHomeUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              HeaderSection(),
              BannerCarousel(),
              CategoryPage(),
              PromotionSection(),
              // Product Grid Section
              FutureBuilder<List<ListEmployee>>(
                future: fetchProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(child: Text('Error: ${snapshot.error}')),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(child: Text('No products found')),
                    );
                  }

                  final listProducts = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header for All Products
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'All Products',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductListWithPagination(),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text('See more'),
                                    Icon(Icons.navigate_next_rounded),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Product Grid
                        GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true, // Allow GridView to adjust to content size
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
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// Header Section Widget
class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int totalQuantity =
    cart.fold(0, (sum, item) => sum + (item['quantity'] as int));
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.menu, color: Colors.black),
          Text(
            'PK Electro',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
            child: Stack(
              children: [
                Icon(Icons.shopping_cart, color: Colors.black),
                if (totalQuantity > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$totalQuantity',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Product Card Widget
class ProductCard extends StatefulWidget {
  final ListEmployee product;

  ProductCard({required this.product});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool get isAddedToCart =>
      cart.any((item) => item['product'] == widget.product);

  void _toggleCart() {
    setState(() {
      if (isAddedToCart) {
        cart.removeWhere((item) => item['product'] == widget.product);
      } else {
        cart.add({'product': widget.product, 'quantity': 1});
      }
    });

    // Show a Snackbar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        isAddedToCart
            ? '${widget.product.tiltle ?? 'Product'} added to cart'
            : '${widget.product.tiltle ?? 'Product'} removed from cart',
      ),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final String imagePath = 'https://pkapi.pkelectro.com/images/';
    final String imageUrl = widget.product.thumnail?.isNotEmpty == true
        ? '$imagePath${widget.product.thumnail}'
        : 'https://pkapi.pkelectro.com/images/default.jpeg';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: widget.product),
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
                    child: GestureDetector(
                      onTap: _toggleCart,
                      child: Icon(
                        isAddedToCart
                            ? Icons.check_circle
                            : Icons.favorite_border,
                        color: isAddedToCart ? Colors.green : Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${widget.product.price?.toStringAsFixed(2) ?? '0.00'}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.product.tiltle ?? 'No Name',
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
                          dateTime: widget.product.createAt != null
                              ? DateTime.parse(widget.product.createAt!)
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

// Cart Page
class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void _removeFromCart(Map<String, dynamic> item) {
    setState(() {
      cart.remove(item);
    });

    // Show Snackbar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${item['product'].tiltle ?? 'Product'} removed from cart'),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: cart.isEmpty
          ? Center(child: Text('No items in cart'))
          : ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          final item = cart[index];
          final product = item['product'] as ListEmployee;
          final quantity = item['quantity'] as int;

          return ListTile(
            leading: Image.network(
              'https://pkapi.pkelectro.com/images/${product.thumnail ?? 'default.jpeg'}',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(product.tiltle ?? 'No Title'),
            subtitle: Text(
                '\$${product.price?.toStringAsFixed(2) ?? '0.00'} x $quantity'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeFromCart(item),
            ),
          );
        },
      ),
    );
  }
}
