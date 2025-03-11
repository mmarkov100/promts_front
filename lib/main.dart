import 'package:flutter/material.dart';
import 'package:promts_application_1/features/main/view/widgets/widget_main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Promts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WidgetMainScreen(),
    );
  }
}
