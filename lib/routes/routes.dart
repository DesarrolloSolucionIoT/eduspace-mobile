import 'package:eduspace_mobile/views/classrooms/ClassroomsPage.dart';
import 'package:eduspace_mobile/views/iam/LoginPage.dart';
import 'package:eduspace_mobile/views/landing/InitialPage.dart';
import 'package:eduspace_mobile/views/sharedspaces/SharedSpacesPage.dart';
import 'package:eduspace_mobile/views/teachers/TeachersManagementPage.dart';
import 'package:flutter/material.dart';

import '../views/home/HomePage.dart';
import '../views/meetings/MeetingsPage.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => HomePage(),
  '/login': (context) => LoginPage(),
  '/classrooms': (context) => ClassroomsPage(),
  '/shared-spaces': (context) => SharedSpacesPage(),
  '/meetings': (context) => MeetingsPage(),
  '/teachers': (context) => TeachersManagementPage(),
  '/welcome' : (context) => InitialPage(),
};