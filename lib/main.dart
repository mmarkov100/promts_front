import 'package:flutter/material.dart';
import 'package:promts_application_1/core/config/config.dart';
import 'package:promts_application_1/features/auth/view/splash_screen_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    final AppConfig appConfig = AppConfig();
    String jwtToken = appConfig.getJwtToken();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Promts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(jwtToken: jwtToken,),
    );
  }
}