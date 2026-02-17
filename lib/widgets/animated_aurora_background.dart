import 'package:flutter/material.dart';

class AuroraHeaderBackground extends StatelessWidget {
  const AuroraHeaderBackground({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Stack(
      children: [
        /// Dark gradient base
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0D1117),
                Color(0xFF161B22),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        Positioned(
          top: -120,
          left: -80,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF7FAF8B).withOpacity(0.18),
            ),
          ),
        ),
      ],
    );
  }
}
