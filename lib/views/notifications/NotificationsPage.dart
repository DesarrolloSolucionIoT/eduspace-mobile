import 'package:flutter/material.dart';
import '../../config/AppTheme.dart';
import '../../widgets/gradient_scaffold.dart';
import '../iot/ClassroomDetailPage.dart';
import '../../models/classroom.dart';
import '../../models/sensor_reading.dart';
import '../breakdown/BreakdownDetailPage.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  static const List<_NotifItem> _items = [
    _NotifItem(
      icon: Icons.people_outline,
      iconBg: Color(0xFFFEE2E2),
      iconFg: AppColors.stateDanger,
      title: 'Aforo excedido en Aula L-204',
      subtitle: 'Ocupación crítica: 35/30 personas.',
      time: 'Hace 5m',
      type: 'iot',
    ),
    _NotifItem(
      icon: Icons.thermostat_outlined,
      iconBg: Color(0xFFFEF3C7),
      iconFg: AppColors.stateWarn,
      title: 'Temperatura alta en Lab de Redes',
      subtitle: '28°C por encima del rango ideal.',
      time: 'Hace 1h',
      type: 'iot',
    ),
    _NotifItem(
      icon: Icons.event_available_outlined,
      iconBg: Color(0xFFE0E7FF),
      iconFg: Color(0xFF6366f1),
      title: 'Nueva reunión asignada',
      subtitle: 'Coordinación Académica te asignó a una reunión mañana.',
      time: 'Hace 3h',
      type: 'meeting',
    ),
    _NotifItem(
      icon: Icons.check_circle_outline,
      iconBg: Color(0xFFDCFCE7),
      iconFg: AppColors.stateOk,
      title: 'Avería resuelta',
      subtitle: 'El proyector del Aula 102 ya fue reparado.',
      time: 'Ayer',
      type: 'breakdown',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Notificaciones',
      showBack: true,
      body: _items.isEmpty
          ? _emptyState()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              itemCount: _items.length,
              itemBuilder: (context, i) => _notifCard(context, _items[i]),
            ),
    );
  }

  Widget _notifCard(BuildContext context, _NotifItem item) {
    return AppCard(
      onTap: () => _handleTap(context, item),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: item.iconBg, shape: BoxShape.circle),
            child: Icon(item.icon, color: item.iconFg, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textMain)),
                const SizedBox(height: 3),
                Text(item.subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(item.time, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  void _handleTap(BuildContext context, _NotifItem item) {
    if (item.type == 'breakdown') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const BreakdownDetailPage()));
    } else if (item.type == 'iot') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ClassroomDetailPage(
            classroom: Classroom(id: 1, name: 'Aula L-204', description: '', teacherId: 0),
            sensors: SensorReading(temperature: 28, humidity: 50, occupancyPresent: true, alertLedState: 1)
          ),
          ),
      );
    }
  }

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_off_outlined, size: 56, color: Colors.white70),
          SizedBox(height: 16),
          Text('Todo al día', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 6),
          Text('No tienes notificaciones nuevas por ahora.', style: TextStyle(fontSize: 13, color: Colors.white70)),
        ],
      ),
    );
  }
}

class _NotifItem {
  final IconData icon;
  final Color iconBg;
  final Color iconFg;
  final String title;
  final String subtitle;
  final String time;
  final String type;

  const _NotifItem({required this.icon, required this.iconBg, required this.iconFg, required this.title, required this.subtitle, required this.time, required this.type});
}
