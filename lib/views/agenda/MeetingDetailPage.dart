import 'package:flutter/material.dart';
import '../../config/AppTheme.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../models/meeting.dart';

class MeetingDetailPage extends StatelessWidget {
  final Meeting meeting;
  const MeetingDetailPage({super.key, required this.meeting});

  String _hm(String t) => t.length >= 5 ? t.substring(0, 5) : t;

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Detalle de Reunión',
      showBack: true,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(color: Color(0xFFE0E7FF), shape: BoxShape.circle),
                    child: const Icon(Icons.event, color: Color(0xFF6366f1), size: 28),
                  ),
                  const SizedBox(height: 12),
                  Text(meeting.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: const Color(0xFFE0E7FF), borderRadius: BorderRadius.circular(6)),
                    child: const Text('Programada', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF3730A3))),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _infoRow(Icons.person_outline, 'Organiza', 'Coordinación Académica'),
                  const Divider(height: 20, color: AppColors.border),
                  _infoRow(Icons.calendar_today_outlined, 'Fecha', meeting.date),
                  const Divider(height: 20, color: AppColors.border),
                  _infoRow(Icons.access_time_outlined, 'Horario', '${_hm(meeting.start)} - ${_hm(meeting.end)}'),
                  const Divider(height: 20, color: AppColors.border),
                  _infoRow(Icons.business_outlined, 'Lugar', 'Aula / Sala ${meeting.classroomId}'),
                ],
              ),
            ),
          ),
          if (meeting.description.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(meeting.description, style: const TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.5)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 12),
        Text('$label: ', style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMain))),
      ],
    );
  }
}
