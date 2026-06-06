import 'package:flutter/material.dart';
import '../../config/AppTheme.dart';
import '../../widgets/gradient_scaffold.dart';

class BreakdownDetailPage extends StatelessWidget {
  const BreakdownDetailPage({super.key});

  static const _timeline = [
    _TimelineStep('Reporte enviado', '28 May • 08:20 AM', true),
    _TimelineStep('Técnico asignado', '28 May • 09:05 AM', true),
    _TimelineStep('En reparación', '28 May • 10:30 AM', true),
    _TimelineStep('Resuelta', '28 May • 02:15 PM', true),
  ];

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Reporte de Avería',
      showBack: true,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        children: [
          _summaryCard(),
          const SizedBox(height: 12),
          const Text('Seguimiento', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _buildTimeline(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Proyector - Aula 102', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                  child: const Text('Resuelta', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.stateOk)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _infoRow(Icons.label_outline, 'Categoría', 'Equipos'),
            const SizedBox(height: 6),
            _infoRow(Icons.flag_outlined, 'Prioridad', 'Alta'),
            const SizedBox(height: 10),
            const Text('"El proyector no encendía durante la clase de la mañana."',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(children: [
      Icon(icon, size: 16, color: AppColors.textMuted),
      const SizedBox(width: 8),
      Text('$label: ', style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
      Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMain)),
    ]);
  }

  Widget _buildTimeline() {
    return Column(
      children: List.generate(_timeline.length, (i) {
        final step = _timeline[i];
        final isLast = i == _timeline.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: step.done ? AppColors.stateOk : AppColors.border,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast) Expanded(child: Container(width: 2, color: AppColors.border)),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(step.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMain)),
                      const SizedBox(height: 2),
                      Text(step.time, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _TimelineStep {
  final String title;
  final String time;
  final bool done;
  const _TimelineStep(this.title, this.time, this.done);
}
