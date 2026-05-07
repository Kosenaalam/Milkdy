import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:milkdy/data/repositories/auth_repo.dart';
import 'package:milkdy/data/repositories/initialise.dart';
import 'package:milkdy/internet_check/internet_wrapper.dart';
import 'package:milkdy/presentation/sell/theme_app.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSupabase();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(
      
      const ProviderScope(
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      home: InternetWrapper(
        child: const LoginUser(),
      ),
    );
  }
}