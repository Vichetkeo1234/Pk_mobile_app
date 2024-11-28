import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:pkelectro/models/products/product_res_model.dart';
import 'package:pkelectro/models/products/trendingproduct_res_model.dart';
import 'package:pkelectro/models/slide_show/slideshow_res_model.dart';
import 'package:pkelectro/screens/AllProduct.dart';
import 'package:pkelectro/screens/ProductDetailPage.dart';
import 'package:pkelectro/screens/TrendingProductDetailPage.dart';
import 'package:pkelectro/widgets/ProductShimmer.dart';

// Fetch products from API
Future<List<ListEmployee>> fetchProducts() async {
  final response = await http.get(Uri.parse('https://pkapi.pkelectro.com/api/products/normal'));
  print(response.body); // Log the raw response

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    print(data); // Log parsed data
    if (data['product'] != null) {
      return (data['product'] as List)
          .map((item) => ListEmployee.fromJson(item))
          .toList();
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load products');
  }
}
// Fetch trending products from API and parse using the TrendingProductResModel
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
Future<List<ListSlide>> fetchBannerSlides() async {
  final response = await http.get(Uri.parse('https://pkapi.pkelectro.com/api/slide/show'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final slideShowResModel = SlideShowResModel.fromJson(data);
    return slideShowResModel.listSlide ?? [];
  } else {
    throw Exception('Failed to load banners');
  }
}

// Main HomeBody Widget
class HomeBody extends StatelessWidget {
  final List<String> bannerImages = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
  ];
  final Function(ListTrending) addToCart; // Accept the addToCart function

  // Constructor for passing the addToCart function
  HomeBody({required this.addToCart});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Banner Section
          FutureBuilder<List<ListSlide>>(
            future: fetchBannerSlides(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 150,
                    child: SlideShimmer(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No Banners Found'));
              }

              final banners = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 150,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 1.0,
                    ),
                    items: banners.map((banner) {
                      final String imagePath = 'https://pkapi.pkelectro.com/images/';

                      // Handle shimmer or default image if the banner image is null
                      if (banner.image == null || banner.image!.isEmpty) {
                        return SlideShimmer(); // Replace with shimmer placeholder widget
                      }

                      final String imageUrl = '$imagePath${banner.image}';

                      return GestureDetector(
                        onTap: () {
                          if (banner.url != null && banner.url!.isNotEmpty) {
                            // Open URL in a browser
                            print("Navigating to: ${banner.url}");
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),

          // Other Sections
          PromotionSection(),
          CategorySection(title: "ទំនិញក្នុងស្តុកទាំងអស់"),
        ],
      ),
    );
  }

}

// Promotion Section Widget
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
                return ProductShimmers();
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
                  Text("Trending Products", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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



// Corrected Category Section Widget
class CategorySection extends StatelessWidget {
  final String title;
  CategorySection({required this.title});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ListTrending>>(
      future: fetchTrendingProducts(), // Fetch trending products instead of normal products
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6, // Number of shimmer placeholders
              itemBuilder: (context, index) {
                return ProductShimmers();
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Trending Products Found'));
        }

        final trendingProducts = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () {
                      // Navigate to a page listing all trending products
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => AllProductsPage()),
                      // );
                    },
                    child: Text(
                      "ច្រើនទៀត >>", // "More >>" in Khmer
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: trendingProducts.length,
                  itemBuilder: (context, index) {
                    return ProductTrending(producttrending: trendingProducts[index]);
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
class ProductCard extends StatelessWidget {
  final ListEmployee product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final String imagePath = 'https://pkapi.pkelectro.com/images/';
    final String imageUrl = product.thumnail != null
        ? '$imagePath${product.thumnail}'
        : 'https://pkapi.pkelectro.com/images/default.png'; // Fallback image

    return GestureDetector(
      onTap: () {
        // Navigate to Product Detail Page
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
                      '${product.price} \$', // Display price
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    if (product.cost != null)
                      Text(
                        '${product.cost} \$', // Display old price if available
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    SizedBox(height: 4),
                    Text(
                      product.tiltle ?? 'No Name', // Display name or default text
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

// Product Card Widget
class ProductTrending extends StatelessWidget {
  final ListTrending producttrending;

  ProductTrending({required this.producttrending});

  @override
  Widget build(BuildContext context) {
    final String imagePath = 'https://pkapi.pkelectro.com/images/';
    final String imageUrl = producttrending.thumnail != null
        ? '$imagePath${producttrending.thumnail}'
        : 'https://pkapi.pkelectro.com/images/default.png'; // Fallback image

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

class BannerCard extends StatelessWidget {
  final ListSlide banner;

  BannerCard({required this.banner});

  @override
  Widget build(BuildContext context) {
    final String imagePath = 'https://pkapi.pkelectro.com/images/';
    final String imageUrl = banner.image != null
        ? '$imagePath${banner.image}'
        : 'https://pkapi.pkelectro.com/images/default.png'; // Fallback image

    return GestureDetector(
      onTap: () {
        if (banner.url != null && banner.url!.isNotEmpty) {
          // Open URL in a browser or navigate
          print("Navigating to: ${banner.url}");
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

