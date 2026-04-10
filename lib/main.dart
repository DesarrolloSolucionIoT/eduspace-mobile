import 'package:eduspace_mobile/views/classrooms/ClassroomsPage.dart';
import 'package:eduspace_mobile/views/sharedspaces/SharedSpacesPage.dart';
import 'package:eduspace_mobile/views/teachers/TeachersManagementPage.dart';
import 'package:flutter/material.dart';
import 'routes/routes.dart';
import 'views/iam/LoginPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: appRoutes,
    );
  }
}


