import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // Ensures all items are displayed
      selectedItemColor: Colors.blue, // Highlight color for selected item
      unselectedItemColor: Colors.grey, // Color for non-selected items
      showSelectedLabels: false, // Hides labels for selected items
      showUnselectedLabels: false, // Hides labels for unselected items
      items: [
        // Home
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home', // Label is required but won't be shown
        ),
        // Favorites
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites', // Label is hidden
        ),
        // Wheel
        BottomNavigationBarItem(
          icon: Icon(Icons.casino), // Icon for the roulette wheel
          label: 'Wheel', // Label is hidden
        ),
        // Search
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on), // Location icon for "Search"
          label: 'Search', // Label is hidden
        ),
        // Profile
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile', // Label is hidden
        ),
      ],
    );
  }
}
