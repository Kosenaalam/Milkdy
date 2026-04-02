import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // 1. Add the import here!

class MilkdySplashScreen extends StatelessWidget {
  const MilkdySplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This pulls the background color from your AppTheme
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 2. Add the SVG Logo here
            SvgPicture.asset(
              'assets/logos/milkdy_logo.svg', // Match your folder name exactly!
              height: 180.0,
              semanticsLabel: 'Milkdy Logo',
            ),
            const SizedBox(height: 20),
            // Optional: Add your app name in text below
            Text(
              'MILKDY',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}