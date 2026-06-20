import 'package:flutter/material.dart';
import '../../config/AppTheme.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../models/resource.dart';
import '../breakdown/ReportBreakdownPage.dart';

class ResourceDetailPage extends StatelessWidget {
  final Resource resource;

  const ResourceDetailPage({super.key, required this.resource});

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = _badge(resource.status);

    return GradientScaffold(
      title: 'Detalle del Recurso',
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
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(color: Color(0xFFE0E7FF), shape: BoxShape.circle),
                    child: const Icon(Icons.devices_outlined, color: Color(0xFF6366f1), size: 32),
                  ),
                  const SizedBox(height: 12),
                  Text(resource.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
                    child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
                  ),
                ],
              ),
            ),
          ),
          _infoCard(),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReportBreakdownPage(spaceName: resource.location, resourceName: resource.name, resourceId: resource.id))),
              icon: const Icon(Icons.warning_amber_outlined),
              label: const Text('Reportar Avería'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _infoRow(Icons.qr_code_outlined, 'Código', resource.code),
            const Divider(height: 20, color: AppColors.border),
            _infoRow(Icons.label_outline, 'Categoría', resource.category),
            const Divider(height: 20, color: AppColors.border),
            _infoRow(Icons.location_on_outlined, 'Ubicación', resource.location),
            if (resource.assignedDate != null) ...[
              const Divider(height: 20, color: AppColors.border),
              _infoRow(Icons.calendar_today_outlined, 'Asignado', resource.assignedDate!),
            ],
          ],
        ),
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

  (String, Color, Color) _badge(String status) {
    return switch (status) {
      'active' => ('En uso', const Color(0xFFDCFCE7), AppColors.stateOk),
      'expiring' => ('Por vencer', const Color(0xFFFEF3C7), AppColors.stateWarn),
      _ => ('Asignado', const Color(0xFFE0E7FF), const Color(0xFF3730A3)),
    };
  }
}
