import 'package:flutter/material.dart';
import '../../config/AppTheme.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../services/teachers_service.dart';
import '../../models/teacher.dart';
import '../../utils/token_utils.dart';
import '../notifications/NotificationsPage.dart';
import '../breakdown/ReportBreakdownPage.dart';
import '../agenda/SpaceBookingPage.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Future<Teacher?>? _teacherFuture;

  @override
  void initState() {
    super.initState();
    _teacherFuture = _loadTeacher();
  }

  Future<Teacher?> _loadTeacher() async {
    final id = await getTeacherIdFromToken();
    if (id == null) return null;
    try {
      return await TeachersService().getTeacherById(id);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Inicio',
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage())),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(color: AppColors.stateDanger, shape: BoxShape.circle),
                child: const Center(child: Text('3', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700))),
              ),
            ),
          ],
        ),
      ],
      body: FutureBuilder<Teacher?>(
        future: _teacherFuture,
        builder: (context, snap) {
          final teacher = snap.data;
          final name = teacher != null ? '${teacher.firstName} ${teacher.lastName}' : 'Profesor';
          return _buildBody(context, name);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, String name) {
    final now = DateTime.now();
    final weekdays = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    final months = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
    final dateStr = '${weekdays[now.weekday - 1]}, ${now.day} de ${months[now.month - 1]}';

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      children: [
        Text('Hola, Prof. ${name.split(' ').first}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        Text(dateStr, style: const TextStyle(fontSize: 14, color: Colors.white70)),
        const SizedBox(height: 24),
        _buildNextClassCard(),
        const SizedBox(height: 24),
        const Text('Acciones Rápidas', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: _buildQuickAction(context, Icons.add_circle_outline, AppColors.secondary, 'Nueva Reserva', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SpaceBookingPage()));
            })),
            const SizedBox(width: 14),
            Expanded(child: _buildQuickAction(context, Icons.warning_amber_outlined, AppColors.danger, 'Reportar Avería', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportBreakdownPage()));
            })),
          ],
        ),
      ],
    );
  }

  Widget _buildNextClassCard() {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PRÓXIMA CLASE', style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w600, letterSpacing: 1)),
            const SizedBox(height: 8),
            const Text('Sistemas Embebidos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.location_on_outlined, size: 15, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text('Aula L-204 • 10:00 AM', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, IconData icon, Color color, String label, VoidCallback onTap) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 10),
              Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMain), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
