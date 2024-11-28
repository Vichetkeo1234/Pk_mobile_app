import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pkelectro/models/slide_show/slideshow_res_model.dart';

// Fetch banner slides from API
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

class BannerCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ListSlide>>(
      future: fetchBannerSlides(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 150,
              child: Center(child: CircularProgressIndicator()), // Loading indicator
            ),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('Error loading banners: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('No banners available')),
          );
        }

        final banners = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: CarouselSlider.builder(
            itemCount: banners.length,
            itemBuilder: (context, index, realIndex) {
              final banner = banners[index];
              final String imagePath = 'https://pkapi.pkelectro.com/images/';
              final String imageUrl = banner.image != null && banner.image!.isNotEmpty
                  ? '$imagePath${banner.image}'
                  : 'https://pkapi.pkelectro.com/images/default.png';

              return GestureDetector(
                onTap: () {
                  if (banner.url != null && banner.url!.isNotEmpty) {
                    print("Navigating to: ${banner.url}");
                    // Add navigation logic, e.g., open URL in a browser
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: 150,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              viewportFraction: 1.0,
            ),
          ),
        );
      },
    );
  }
}
