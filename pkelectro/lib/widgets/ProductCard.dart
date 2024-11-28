import 'package:flutter/material.dart';

import '../style/styles.dart';

class ProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Image.asset('assets/images/mac.jpg', height: 100), // Placeholder for product image
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Product Title", style: AppTextStyles.title),
                SizedBox(height: 4),
                Text("\$499", style: AppTextStyles.price),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
