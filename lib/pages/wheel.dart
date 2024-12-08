import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class WheelScreen extends StatefulWidget {
  @override
  _WheelScreenState createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> {
  final List<String> items = [
    'assets/images/ajisen.png',
    'assets/images/pepper.png',
    'assets/images/texas.png',
    'assets/images/domino.png',
    'assets/images/pizzac.png',
    'assets/images/carl.png',
    'assets/images/table.jpg',
    'assets/images/sheep.png',
  ];

  final StreamController<int> controller = StreamController<int>();
  String selectedLocation = 'Aeon 2'; // Default selected location

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  void _spinWheel() {
    // Generate a random index for the winning item
    final randomIndex = Random().nextInt(items.length);
    controller.add(randomIndex); // Add index to the stream to spin the wheel

    // Show dialog with the result
    Future.delayed(const Duration(seconds: 5), () {
      _showResultDialog(randomIndex);
    });
  }

  void _showResultDialog(int prizeIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Image.asset(
          items[prizeIndex],
          height: 200, // Larger size for better visibility
          fit: BoxFit.contain,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        toolbarHeight: 70,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png', // Logo path
              height: 40,
            ),
            const SizedBox(width: 10), // Space between logo and dropdown
            DropdownButton<String>(
              value: selectedLocation,
              items: <String>['Aeon 2']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedLocation = newValue!;
                });
              },
              underline: Container(),
              icon: Icon(Icons.arrow_drop_down, color: Colors.black),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Spin The Wheel',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              width: 300,
              child: FortuneWheel(
                selected: controller.stream,
                items: items
                    .map((imagePath) => FortuneItem(
                  child: Image.asset(imagePath, height: 50), // Display images
                ))
                    .toList(),
                physics: NoPanPhysics(), // Prevents spinning by touch
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 150, // Width of the button
              height: 60, // Height of the button
              child: ElevatedButton(
                onPressed: _spinWheel,
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                child: const Text('Spin'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
