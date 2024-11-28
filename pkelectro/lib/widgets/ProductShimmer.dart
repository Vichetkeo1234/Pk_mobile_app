import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white, // Set background color to white
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), // Shadow color with opacity
              spreadRadius: 2, // How far the shadow spreads
              blurRadius: 5, // Blur radius for softness
              offset: Offset(2, 3), // Position of the shadow (x, y)
            ),
          ],
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.white, // Base shimmer color
          highlightColor: Colors.grey[200]!, // Highlight shimmer color
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white, // Shimmer box background
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 10,
                width: 100,
                color: Colors.white, // Shimmer bar color
              ),
              SizedBox(height: 8),
              Container(
                height: 10,
                width: 150,
                color: Colors.white, // Shimmer bar color
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class ProductShimmers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white, // Set background color to white
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), // Shadow color with opacity
              spreadRadius: 2, // How far the shadow spreads
              blurRadius: 5, // Blur radius for softness
              offset: Offset(2, 3), // Position of the shadow (x, y)
            ),
          ],
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.white, // Base shimmer color
          highlightColor: Colors.grey[200]!, // Highlight shimmer color
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white, // Shimmer box background
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 10,
                width: 100,
                color: Colors.white, // Shimmer bar color
              ),
              SizedBox(height: 8),
              Container(
                height: 10,
                width: 150,
                color: Colors.white, // Shimmer bar color
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SlideShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 150, // Same as CarouselSlider
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

