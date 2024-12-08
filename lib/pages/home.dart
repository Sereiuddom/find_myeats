import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'wheel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track selected tab

  // List of screens for BottomNavigationBar
  final List<Widget> _screens = [
    HomeScreenContent(), // Home page content
    WheelScreen(), // Wheel page content
    MapScreen(), // Map page content
  ];

  // Method to handle BottomNavigationBar taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Icon for Home
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.casino), // Icon for the roulette wheel
            label: 'Wheel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on), // Icon for the map
            label: 'Map',
          ),
        ],
      ),
    );
  }
}

// The main Home content widget
class HomeScreenContent extends StatefulWidget {
  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  String selectedLocation = 'Aeon 2'; // Default selected location
  PageController _pageController = PageController(); // Page controller for swipe
  int _currentPage = 0; // Track current page

  @override
  void dispose() {
    _pageController.dispose(); // Dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/images/logo.png', // Logo path
                height: 40,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: DropdownButton<String>(
                value: selectedLocation, // Display the selected location
                items: <String>['Aeon 2', 'Toul Kork', 'AUPP']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLocation = newValue!; // Update the selected location
                  });
                },
                underline: Container(),
                icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0), // Increased top padding
            child: Text(
              "Featured Restaurants",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int index) {
                setState(() {
                  _currentPage = index; // Update current page index
                });
              },
              children: [
                // Page 1
                ListView(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    featuredRestaurantTile('assets/images/kungfu.png'),
                    featuredRestaurantTile('assets/images/hokk.jpg'),
                    featuredRestaurantTile('assets/images/chicken.png'),
                  ],
                ),
                // Page 2
                ListView(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    featuredRestaurantTile('assets/images/kimmo.jpg'),
                    featuredRestaurantTile('assets/images/potato.jpg'),
                    featuredRestaurantTile('assets/images/ringer.jpg'),
                  ],
                ),
              ],
            ),
          ),
          // Page Indicator
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                2, // Total number of pages (now 2)
                    (index) => buildIndicator(index == _currentPage),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget featuredRestaurantTile(String imagePath) {
    return Container(
      margin: EdgeInsets.only(bottom: 24), // Increased bottom spacing
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12, // Slightly larger blur radius
            offset: Offset(0, 6), // Deeper shadow offset
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          imagePath,
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildIndicator(bool isSelected) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: 10,
      width: isSelected ? 24 : 10, // Wider for selected, smaller for unselected
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.grey, // Blue for selected
        borderRadius: BorderRadius.circular(10), // Round corners
      ),
    );
  }
}

// MapScreen for displaying MapSection
class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map View"),
      ),
      body: Column(
        children: [
          Expanded(
            child: MapSection(
              latitude: 11.60008, // Example latitude
              longitude: 104.88538, // Example longitude
            ),
          ),
        ],
      ),
    );
  }
}

class MapSection extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MapSection({
    required this.latitude,
    required this.longitude,
    Key? key,
  }) : super(key: key);

  @override
  _MapSectionState createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {
  final MapController _mapController = MapController();
  double _currentZoom = 13.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(widget.latitude, widget.longitude),
                zoom: _currentZoom,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://a.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(widget.latitude, widget.longitude),
                      builder: (ctx) => const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Zoom Buttons
          Positioned(
            bottom: 10,
            right: 10,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoom_in',
                  mini: true,
                  onPressed: () {
                    setState(() {
                      _currentZoom += 1;
                      _mapController.move(
                        LatLng(widget.latitude, widget.longitude),
                        _currentZoom,
                      );
                    });
                  },
                  child: const Icon(Icons.zoom_in),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'zoom_out',
                  mini: true,
                  onPressed: () {
                    setState(() {
                      _currentZoom -= 1;
                      _mapController.move(
                        LatLng(widget.latitude, widget.longitude),
                        _currentZoom,
                      );
                    });
                  },
                  child: const Icon(Icons.zoom_out),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
