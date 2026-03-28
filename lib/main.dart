import 'package:flutter/material.dart';
import 'package:milkdy/data/repositories/auth_repo.dart';
import 'package:milkdy/data/repositories/initialise.dart';


  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initSupabase();
  runApp(
    MaterialApp(
      home: LoginUser(),),
    
  );
}