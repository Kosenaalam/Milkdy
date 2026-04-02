import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:milkdy/data/repositories/auth_repo.dart';
import 'package:milkdy/data/repositories/initialise.dart';
import 'package:milkdy/presentation/sell/theme_app.dart';


  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initSupabase();
    // If you ever want to lock screen rotation in the future:
   WidgetsFlutterBinding.ensureInitialized();
   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
  runApp(
    MaterialApp(
       debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      home: LoginUser(),),
    
  );
   });
   }