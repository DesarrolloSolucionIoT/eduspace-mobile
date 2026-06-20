import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/AppTheme.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../models/teacher.dart';
import '../../services/teachers_service.dart';
import '../../utils/token_utils.dart';
import '../notifications/NotificationsPage.dart';
import 'PersonalDataPage.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
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

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kAuthToken);
    await prefs.remove(kUserRole);
    await prefs.remove(kProfileId);
    if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Perfil',
      body: FutureBuilder<Teacher?>(
        future: _teacherFuture,
        builder: (context, snap) {
          final teacher = snap.data;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            children: [
              _buildHeader(teacher),
              const SizedBox(height: 24),
              _buildMenuCard(context, teacher),
              const SizedBox(height: 24),
              _buildLogoutButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(Teacher? teacher) {
    final name = teacher != null ? '${teacher.firstName} ${teacher.lastName}' : 'Docente';
    return Column(
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10)],
          ),
          child: const Icon(Icons.person, size: 40, color: AppColors.primary),
        ),
        const SizedBox(height: 14),
        Text(name, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white)),
        if (teacher != null) ...[
          const SizedBox(height: 4),
          Text(teacher.email, style: const TextStyle(fontSize: 13, color: Colors.white70)),
        ],
      ],
    );
  }

  Widget _buildMenuCard(BuildContext context, Teacher? teacher) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            _menuItem(
              context,
              Icons.person_outline,
              'Datos Personales',
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => PersonalDataPage(teacher: teacher)))
                  .then((_) => setState(() { _teacherFuture = _loadTeacher(); })),
            ),
            _menuItem(
              context,
              Icons.notifications_outlined,
              'Mis Notificaciones',
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage())),
            ),
            _languageMenuItem(),
            _menuItem(context, Icons.help_outline, 'Ayuda y Soporte', null, isLast: true),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String label, VoidCallback? onTap, {bool isLast = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 15, color: AppColors.textMain))),
            const Icon(Icons.chevron_right, color: Color(0xFFCBD5E0)),
          ],
        ),
      ),
    );
  }

  Widget _languageMenuItem() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
      child: Row(
        children: [
          const Icon(Icons.language, size: 20, color: AppColors.primary),
          const SizedBox(width: 14),
          const Expanded(child: Text('Idioma', style: TextStyle(fontSize: 15, color: AppColors.textMain))),
          _LangToggle(),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _logout,
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text('Cerrar Sesión', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white70),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _LangToggle extends StatefulWidget {
  @override
  State<_LangToggle> createState() => _LangToggleState();
}

class _LangToggleState extends State<_LangToggle> {
  bool _esActive = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: const Color(0xFFEDF2F7), borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _langBtn('ES', _esActive, () => setState(() => _esActive = true)),
          _langBtn('EN', !_esActive, () => setState(() => _esActive = false)),
        ],
      ),
    );
  }

  Widget _langBtn(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: active ? Colors.white : AppColors.textMuted)),
      ),
    );
  }
}
