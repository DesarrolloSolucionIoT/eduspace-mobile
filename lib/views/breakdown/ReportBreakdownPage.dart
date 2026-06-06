import 'package:flutter/material.dart';
import '../../config/AppTheme.dart';
import '../../widgets/gradient_scaffold.dart';

class ReportBreakdownPage extends StatefulWidget {
  final String? spaceName;
  final String? resourceName;

  const ReportBreakdownPage({super.key, this.spaceName, this.resourceName});

  @override
  State<ReportBreakdownPage> createState() => _ReportBreakdownPageState();
}

class _ReportBreakdownPageState extends State<ReportBreakdownPage> {
  final _descController = TextEditingController();
  String _category = 'Infraestructura';
  String _priority = 'Media';

  final _categories = ['Infraestructura', 'Equipos', 'Mobiliario', 'Conectividad', 'Otro'];
  final _priorities = ['Baja', 'Media', 'Alta', 'Urgente'];

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Reportar Incidencia',
      showBack: true,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Espacio / Aula'),
                  const SizedBox(height: 8),
                  _readonlyField(widget.spaceName ?? 'No especificado'),
                  if (widget.resourceName != null) ...[
                    const SizedBox(height: 16),
                    _label('Recurso'),
                    const SizedBox(height: 8),
                    _readonlyField(widget.resourceName!),
                  ],
                  const SizedBox(height: 16),
                  _label('Categoría de Avería'),
                  const SizedBox(height: 8),
                  _dropdown(_categories, _category, (v) => setState(() => _category = v!)),
                  const SizedBox(height: 16),
                  _label('Prioridad'),
                  const SizedBox(height: 8),
                  _dropdown(_priorities, _priority, (v) => setState(() => _priority = v!)),
                  const SizedBox(height: 16),
                  _label('Descripción del Problema'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descController,
                    maxLines: 4,
                    decoration: const InputDecoration(hintText: 'Detalla lo sucedido...', hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                  ),
                  const SizedBox(height: 16),
                  _photoPlaceholder(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.send_outlined),
              label: const Text('Enviar Reporte'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reporte enviado ✓'), backgroundColor: AppColors.primary),
    );
    Navigator.pop(context);
  }

  Widget _label(String text) => Text(text, style: const TextStyle(fontSize: 14, color: AppColors.textMuted));

  Widget _readonlyField(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(value, style: const TextStyle(fontSize: 14, color: AppColors.textMain)),
    );
  }

  Widget _dropdown(List<String> items, String value, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 14)))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _photoPlaceholder() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border, width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Column(
          children: [
            Icon(Icons.camera_alt_outlined, size: 28, color: AppColors.textMuted),
            SizedBox(height: 8),
            Text('Adjuntar Foto', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
