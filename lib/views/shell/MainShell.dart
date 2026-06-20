import 'package:flutter/material.dart';
import '../../config/AppTheme.dart';
import '../home/HomeTab.dart';
import '../iot/IotTab.dart';
import '../agenda/AgendaTab.dart';
import '../profile/ProfileTab.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;
  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  // Index del tab de Agenda dentro de _tabs.
  static const _agendaIndex = 2;
  final _agendaKey = GlobalKey<AgendaTabState>();

  late final List<Widget> _tabs = [
    const HomeTab(),
    const IotTab(),
    AgendaTab(key: _agendaKey),
    const ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
          // La Agenda se mantiene viva en el IndexedStack, así que la recargamos
          // al entrar para reflejar reservas/reuniones creadas en otros tabs.
          if (i == _agendaIndex) _agendaKey.currentState?.reload();
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.memory_outlined), activeIcon: Icon(Icons.memory), label: 'IoT'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), activeIcon: Icon(Icons.calendar_today), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
        ],
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
      ),
    );
  }
}
