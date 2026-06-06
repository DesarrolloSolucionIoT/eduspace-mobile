import 'package:flutter/material.dart';
import '../../config/AppTheme.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../models/teacher.dart';

class PersonalDataPage extends StatefulWidget {
  final Teacher? teacher;
  const PersonalDataPage({super.key, this.teacher});

  @override
  State<PersonalDataPage> createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final t = widget.teacher;
    _nameController = TextEditingController(text: t != null ? '${t.firstName} ${t.lastName}' : '');
    _emailController = TextEditingController(text: t?.email ?? '');
    _phoneController = TextEditingController(text: t?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Datos Personales',
      showBack: true,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        children: [
          Center(
            child: Stack(
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
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                    child: const Icon(Icons.camera_alt, size: 13, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _field('Nombre completo', _nameController, TextInputType.name),
                  const SizedBox(height: 16),
                  _field('Correo electrónico', _emailController, TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  _field('Teléfono', _phoneController, TextInputType.phone),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cambios guardados ✓'), backgroundColor: AppColors.primary),
                );
                Navigator.pop(context);
              },
              child: const Text('Guardar Cambios'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController controller, TextInputType type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textMuted)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: type,
          style: const TextStyle(fontSize: 14, color: AppColors.textMain),
        ),
      ],
    );
  }
}
