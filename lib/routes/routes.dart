import 'package:flutter/material.dart';
import '../views/iam/LoginPage.dart';
import '../views/iam/RegisterPage.dart';
import '../views/shell/MainShell.dart';
import '../views/iot/ClassroomDetailPage.dart';
import '../views/iot/ResourceDetailPage.dart';
import '../views/agenda/MeetingDetailPage.dart';
import '../views/agenda/SpaceBookingPage.dart';
import '../views/profile/PersonalDataPage.dart';
import '../views/notifications/NotificationsPage.dart';
import '../views/breakdown/ReportBreakdownPage.dart';
import '../views/breakdown/BreakdownDetailPage.dart';

// Legacy admin pages (kept for admin role)
import '../views/classrooms/ClassroomsPage.dart';
import '../views/sharedspaces/SharedSpacesPage.dart';
import '../views/teachers/TeachersManagementPage.dart';
import '../views/meetings/MeetingsPage.dart';
import '../views/home/HomePage.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const MainShell(),
  '/login': (context) => LoginPage(),
  '/register': (context) => RegisterPage(),

  // Teacher shell
  '/home': (context) => const MainShell(initialIndex: 0),
  '/iot': (context) => const MainShell(initialIndex: 1),
  '/agenda': (context) => const MainShell(initialIndex: 2),
  '/profile': (context) => const MainShell(initialIndex: 3),

  // Detail pages (pushed on top of shell)
  '/notifications': (context) => const NotificationsPage(),
  '/breakdown/report': (context) => const ReportBreakdownPage(),
  '/breakdown/detail': (context) => const BreakdownDetailPage(),
  '/profile/personal-data': (context) => const PersonalDataPage(),
  '/space-booking': (context) => const SpaceBookingPage(),

  // Legacy admin routes
  '/admin/home': (context) => HomePage(),
  '/classrooms': (context) => ClassroomsPage(),
  '/shared-spaces': (context) => SharedSpacesPage(),
  '/meetings': (context) => MeetingsPage(),
  '/teachers': (context) => TeachersManagementPage(),
};
