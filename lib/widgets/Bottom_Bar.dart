// Yeh widget bottom navigation state ko manage karega
import 'package:e/screens/buyer/Shops/all_shops.dart';
import 'package:e/screens/buyer/home_screen.dart';
import 'package:e/screens/buyer/wishlist.dart';

import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  // Selected tab index
  int _selectedIndex = 0;

  // Pages ki list (Aap yahan apne asli screens daal sakte hain)
  final List<Widget> _pages = <Widget>[
    HomeScreen(),
    AllShopsScreen(),
    Text('Messages Page'),
    WishlistScreen(),
  ];

  // Tab change hone par yeh function call hoga
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Jo bhi page select hoga, woh yahan dikhega
      body: Center(child: _pages.elementAt(_selectedIndex)),
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          // Thoda sa shadow dene ke liye
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          // Selected item ka index

          currentIndex: _selectedIndex,
          // Item press hone par function call karna
          onTap: _onItemTapped,
          // Background color
          backgroundColor: Colors.white,
          // Item style
          type: BottomNavigationBarType.fixed, // Saare items hamesha dikhenge
          selectedItemColor: Colors.green, // Selected item ka color
          unselectedItemColor: Colors.grey.shade600, // Unselected item ka color
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 11),

          items: const <BottomNavigationBarItem>[
            // 1. Home
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            // 2. Categories
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view),
              label: 'Categories',
            ),
            // 3. Cart

            // 4. Messages (Aapki request ke mutabik)
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Messages',
            ),
            // 5. Profile
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorite',
            ),
          ],
        ),
      ),
    );
  }
}
