import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pkelectro/models/brands/brands_res_model.dart';

class BrandScreen extends StatefulWidget {
  @override
  _BrandScreenState createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  late Future<List<ListSlide>> _brandsFuture;

  @override
  void initState() {
    super.initState();
    _brandsFuture = fetchBrands();
  }

  Future<List<ListSlide>> fetchBrands() async {
    final response = await http.get(Uri.parse('https://pkapi.pkelectro.com/api/brands/normal'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final brandResModel = BrandResModel.fromJson(data);
      return brandResModel.listSlide ?? [];
    } else {
      throw Exception('Failed to load brands');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brands'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<ListSlide>>(
        future: _brandsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No brands found'));
          }

          final brands = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Four columns for logos
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: brands.length,
              itemBuilder: (context, index) {
                final brand = brands[index];
                final imageUrl = 'https://pkapi.pkelectro.com/images/${brand.image}';

                return GestureDetector(
                  onTap: () {
                    // Handle brand click, e.g., open a URL or show details
                    if (brand.url != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening ${brand.url}')),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 5,
                          spreadRadius: 2,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
