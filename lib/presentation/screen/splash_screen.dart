import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; 

class MilkdySplashScreen extends StatelessWidget {
  const MilkdySplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //svg logo
            SvgPicture.asset(
              'assets/logos/milkdy_logo.svg', 
              height: 180.0,
              semanticsLabel: 'Milkdy Logo',
            ),
            const SizedBox(height: 20),
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