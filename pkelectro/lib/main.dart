import 'package:flutter/material.dart';
import 'package:pkelectro/screens/AllProduct.dart';
import 'package:pkelectro/screens/HomeBody.dart';
import 'package:pkelectro/screens/HomeScreen.dart';
import 'package:pkelectro/screens/root_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false, // Optional: turn off Material 3 if you're using it
      ),
      home: HomeScreen(),
      routes: {
        '/all-products': (context) => AllProductsPage(
          // title: "All Products",
          // products: sampleProducts, // Pass your product list
        ),
      },
    );
  }
}

