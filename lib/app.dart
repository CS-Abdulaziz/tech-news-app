import 'package:flutter/material.dart';

class TechPulseApp extends StatefulWidget {
  const TechPulseApp({super.key});

  @override
  State<TechPulseApp> createState() => _TechPulseAppState();
}

class _TechPulseAppState extends State<TechPulseApp> {
  int currentIndex = 0;

  final pages = const [
    Center(child: Text("Home")),
    Center(child: Text("Explore")),
    Center(child: Text("Favorites")),
    Center(child: Text("Profile")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
