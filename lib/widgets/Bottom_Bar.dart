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
 
  int _selectedIndex = 0;

  
  final List<Widget> _pages = <Widget>[
    HomeScreen(),
    AllShopsScreen(),
    Text('Messages Page'),
    WishlistScreen(),
  ];

  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(child: _pages.elementAt(_selectedIndex)),
      
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          
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
          
          onTap: _onItemTapped,
          
          backgroundColor: Colors.white,
          
          type: BottomNavigationBarType.fixed, 
          selectedItemColor: Colors.green, 
          unselectedItemColor: Colors.grey.shade600, 
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
