import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'home_screen.dart';
import 'saved_screen.dart';
import 'profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  
  static const brandColor = Color(0xFF7FAF8B);

  final List<Widget> _pages = [
    const HomeScreen(),
    const SavedScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); 

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, 
      body: _pages[_currentIndex],
      
      bottomNavigationBar: Padding(

        padding: const EdgeInsets.fromLTRB(15, 10, 15, 25),
        child: GNav(

          rippleColor: brandColor.withOpacity(0.2),
          hoverColor: brandColor.withOpacity(0.1),
          gap: 8,
          
          activeColor: Colors.white,
          tabBackgroundColor: brandColor,
          
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(milliseconds: 400),
          
          color: Colors.grey[700], 
          
          selectedIndex: _currentIndex,
          onTabChange: (index) {
            setState(() {
              _currentIndex = index;
            });
          },

          tabs: const [
            GButton(
              icon: Icons.home_rounded,
              text: 'Home',
            ),
            GButton(
              icon: Icons.bookmark_rounded,
              text: 'Saved',
            ),
            GButton(
              icon: Icons.person_rounded,
              text: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}