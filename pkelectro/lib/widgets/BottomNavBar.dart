import 'package:flutter/material.dart';
import 'package:pkelectro/models/products/trendingproduct_res_model.dart';
import 'package:pkelectro/screens/BrandScreen.dart';
import 'package:pkelectro/screens/ProfileScreen.dart';

// Bottom Navigation Bar
class BottomNavBar extends StatefulWidget {
  final int cartItemCount;
  final List<ListTrending> cartItems; // Accept cartItems as a parameter

  BottomNavBar({this.cartItemCount = 0, required this.cartItems}); // Required cartItems

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  bool isLoggedIn = false; // Flag to track login status

  // Simulate a login callback
  void onLoginSuccess() {
    setState(() {
      isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.blueAccent,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.location_city_sharp), label: "Location"),
        BottomNavigationBarItem(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Icons.breakfast_dining),
              if (widget.cartItemCount > 0)
                Positioned(
                  right: -6,
                  top: -6,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      widget.cartItemCount.toString(),
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          label: "Brands",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      onTap: (index) {
        if (index == 1) {
          // Location icon tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LocationScreen(),
            ),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BrandScreen(),
            ),
          );
        } else if (index == 3) {
          // Profile icon tapped

            // Navigate to Profile if logged in
            // Profile icon tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(),
              ),
            );

        }
      },
    );
  }
}

// Location Screen
class LocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              size: 100,
              color: Colors.blueAccent,
            ),
            SizedBox(height: 20),
            Text(
              'Our Store Location',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'PK Electro, 10 St 253, Phnom Penh',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Handle navigation to a map or location details if needed
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Opening map...')),
                );
              },
              icon: Icon(Icons.map),
              label: Text('View on Map'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Brand Screen
// class BrandScreen extends StatelessWidget {
//   // Sample brand logos
//   final List<String> brands = [
//     'assets/brands/acer.png',
//     'assets/brands/apple.png',
//     'assets/brands/asus.png',
//     'assets/brands/dell.png',
//     'assets/brands/hp.png',
//     'assets/brands/lenovo.png',
//     'assets/brands/logitech.png',
//     'assets/brands/microsoft.png',
//     'assets/brands/razer.png',
//     'assets/brands/toshiba.png',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Brands'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: GridView.builder(
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 4, // Four columns for logos
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//           ),
//           itemCount: brands.length,
//           itemBuilder: (context, index) {
//             return Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     blurRadius: 5,
//                     spreadRadius: 2,
//                     offset: Offset(2, 2),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Image.asset(
//                   brands[index],
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }