import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatelessWidget {
  final void Function()? onLogout;
  final String? selectedRoute;

  const AppDrawer({Key? key, this.onLogout, this.selectedRoute}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    Widget buildTile({required IconData icon, required String title, required String route}) {
      final bool selected = ModalRoute.of(context)?.settings.name == route;
      return ListTile(
        leading: Icon(icon, color: selected ? Colors.blue : Colors.grey[700]),
        title: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.blue : Colors.black87,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: selected,
        selectedTileColor: Colors.blue.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: () {
          Navigator.pop(context); // Cierra el Drawer
          if (!selected) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
      );
    }

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1976D2), Color(0xFF43E97B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: DrawerHeader(
              child: Center(
                child: Text(
                  'Menú',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
          buildTile(icon: Icons.home, title: 'Home', route: '/'),
          buildTile(icon: Icons.meeting_room, title: 'Classrooms', route: '/classrooms'),
          buildTile(icon: Icons.group_work, title: 'Shared Spaces', route: '/shared-spaces'),
          buildTile(icon: Icons.event, title: 'Meetings', route: '/meetings'),
          buildTile(icon: Icons.person, title: 'Teachers', route: '/teachers'),
          const Spacer(),
          const Divider(thickness: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
            onTap: () => _logout(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
