import 'package:flutter/material.dart';
import 'config/AppTheme.dart';
import 'routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduSpace IoT',
      theme: AppTheme.light,
      initialRoute: '/login',
      routes: appRoutes,
      debugShowCheckedModeBanner: false,
    );
  }
}
