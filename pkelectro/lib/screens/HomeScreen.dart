// import 'package:flutter/material.dart';
// import 'package:pkelectro/widgets/BottomNavBar.dart';
// import 'package:pkelectro/screens/HomeBody.dart';
// import 'package:pkelectro/models/products/trendingproduct_res_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int cartItemCount = 0;
//   List<ListTrending> cartItems = [];
//
//   @override
//   void initState() {
//     super.initState();
//     loadCartItems();
//   }
//
//   Future<void> loadCartItems() async {
//     final prefs = await SharedPreferences.getInstance();
//     final cartData = prefs.getStringList('cartItems');
//     if (cartData != null) {
//       setState(() {
//         cartItems = cartData.map((item) {
//           final itemData = item.split(';');
//           return ListTrending(
//             id: int.parse(itemData[0]),
//             tiltle: itemData[1],
//             price: int.parse(itemData[2]),
//             cost: int.parse(itemData[3]),
//             thumnail: itemData[4],
//           );
//         }).toList();
//         cartItemCount = cartItems.length;
//       });
//     }
//   }
//
//   Future<void> saveCartItems() async {
//     final prefs = await SharedPreferences.getInstance();
//     final cartData = cartItems.map((item) {
//       return '${item.id};${item.tiltle};${item.price};${item.cost};${item.thumnail}';
//     }).toList();
//     await prefs.setStringList('cartItems', cartData);
//   }
//
//   void addToCart(ListTrending product) {
//     setState(() {
//       cartItems.add(product);
//       cartItemCount = cartItems.length;
//     });
//     saveCartItems();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         leading: Icon(Icons.menu),
//         title: Container(
//           padding: EdgeInsets.symmetric(horizontal: 8.0),
//           child: TextField(
//             decoration: InputDecoration(
//               hintText: 'Search...',
//               hintStyle: TextStyle(color: Colors.grey[600]),
//               prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
//               filled: true,
//               fillColor: Colors.white,
//               contentPadding: EdgeInsets.symmetric(vertical: 0),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(30),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//             style: TextStyle(fontSize: 16),
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications, color: Colors.white),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: HomeBody(addToCart: addToCart), // Pass addToCart function
//       bottomNavigationBar: BottomNavBar(
//         cartItemCount: cartItemCount,
//         cartItems: cartItems,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:pkelectro/screens/HomePageUI.dart';
import 'package:pkelectro/widgets/BottomNavBar.dart';
import 'package:pkelectro/models/products/trendingproduct_res_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int cartItemCount = 0;
  List<ListTrending> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadCartItems();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAdvertisingModal();
    });
  }

  Future<void> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getStringList('cartItems');
    if (cartData != null) {
      setState(() {
        cartItems = cartData.map((item) {
          final itemData = item.split(';');
          return ListTrending(
            id: int.parse(itemData[0]),
            tiltle: itemData[1],
            price: int.parse(itemData[2]),
            cost: int.parse(itemData[3]),
            thumnail: itemData[4],
          );
        }).toList();
        cartItemCount = cartItems.length;
      });
    }
  }

  Future<void> saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = cartItems.map((item) {
      return '${item.id};${item.tiltle};${item.price};${item.cost};${item.thumnail}';
    }).toList();
    await prefs.setStringList('cartItems', cartData);
  }

  void addToCart(ListTrending product) {
    setState(() {
      cartItems.add(product);
      cartItemCount = cartItems.length;
    });
    saveCartItems();
  }

  void showAdvertisingModal() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        // Schedule auto-close after 5 seconds
        Future.delayed(Duration(seconds: 5), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop(); // Close the dialog
          }
        });

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 32), // Placeholder to balance the close button
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Icon(Icons.close, color: Colors.red, size: 24),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Super Sale',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Get up to 50% off on your favorite products!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 16),
                Image.asset(
                  'assets/images/ads.jpeg', // Replace with your image URL
                  height: 150,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    // Navigate to a promotion or details page if necessary
                  },
                  child: Text('Learn More'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: HeaderPage(),
      // body: HomeBody(addToCart: addToCart), // Pass addToCart function
      body: UpdatedHomeUI(),
      bottomNavigationBar: BottomNavBar(
        cartItemCount: cartItemCount,
        cartItems: cartItems,
      ),
    );
  }
}
