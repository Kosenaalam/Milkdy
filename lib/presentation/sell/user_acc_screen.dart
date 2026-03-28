

import 'package:flutter/material.dart';
import 'package:milkdy/data/repositories/initialise.dart';

class UserAccScreen extends StatelessWidget{
   UserAccScreen({super.key});

  final user = supabase.auth.currentUser;

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
      // Text(user.id),
       //Text(user.createdAt),
       
      ],
    ),
  );    
  }
}