import 'package:flutter/material.dart';
import '../../config/AppTheme.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../models/sharedspace.dart';
import '../../services/sharedspaces_service.dart';

class SpaceBookingPage extends StatefulWidget {
  const SpaceBookingPage({super.key});

  @override
  State<SpaceBookingPage> createState() => _SpaceBookingPageState();
}

class _SpaceBookingPageState extends State<SpaceBookingPage> {
  Future<List<SharedSpace>>? _spacesFuture;
  String _selectedFilter = 'Todos';

  final List<String> _filters = ['Todos', 'Aulas', 'Auditorios', 'Laboratorios'];

  @override
  void initState() {
    super.initState();
    _spacesFuture = SharedSpacesService().getAllSharedSpaces();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Reservar Espacio',
      showBack: true,
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: FutureBuilder<List<SharedSpace>>(
              future: _spacesFuture,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                }
                if (snap.hasError || !snap.hasData || snap.data!.isEmpty) {
                  return _emptyState();
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  itemCount: snap.data!.length,
                  itemBuilder: (context, i) => _spaceCard(context, snap.data![i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: _filters.map((f) {
          final active = f == _selectedFilter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = f),
            child: Container(
              margin: const EdgeInsets.only(right: 10, top: 8, bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: active ? Colors.white : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(child: Text(f, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: active ? AppColors.primary : Colors.white))),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _spaceCard(BuildContext context, SharedSpace space) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(space.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
          const SizedBox(height: 4),
          Text('Capacidad: ${space.capacity} personas', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          if (space.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(space.description, style: const TextStyle(fontSize: 12, color: AppColors.textMuted), maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _AvailabilityPage(space: space))),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
              child: const Text('Ver Disponibilidad', style: TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.meeting_room_outlined, size: 56, color: Colors.white70),
          SizedBox(height: 16),
          Text('Sin espacios disponibles', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}

// ── Sub-page: Disponibilidad ────────────────────────────────────────────────

class _AvailabilityPage extends StatefulWidget {
  final SharedSpace space;
  const _AvailabilityPage({required this.space});

  @override
  State<_AvailabilityPage> createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<_AvailabilityPage> {
  final _slots = ['08:00', '09:00', '10:00', '11:00', '12:00', '13:00'];
  final _taken = {'08:00', '12:00'};
  String? _selected = '10:00';
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: widget.space.name,
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
                  const Text('Fecha', style: TextStyle(fontSize: 14, color: AppColors.textMuted)),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.primary),
                      SizedBox(width: 10),
                      Text('Viernes, 31 de Mayo', style: TextStyle(fontSize: 14, color: AppColors.textMain, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Horarios disponibles', style: TextStyle(fontSize: 14, color: AppColors.textMuted)),
                  const SizedBox(height: 12),
                  _slotGrid(),
                  const SizedBox(height: 20),
                  const Text('Motivo de la reserva', style: TextStyle(fontSize: 14, color: AppColors.textMuted)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _reasonController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Ej. Clase de recuperación, conferencia...',
                      hintStyle: TextStyle(fontSize: 13, color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selected == null
                  ? null
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reserva solicitada ✓ (Pendiente de aprobación)'), backgroundColor: AppColors.primary),
                      );
                      Navigator.popUntil(context, (r) => r.isFirst || r.settings.name == '/');
                    },
              child: const Text('Confirmar Reserva'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _slotGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.5,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: _slots.map((slot) {
        final isTaken = _taken.contains(slot);
        final isSelected = _selected == slot;
        return GestureDetector(
          onTap: isTaken ? null : () => setState(() => _selected = slot),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : (isTaken ? const Color(0xFFF1F5F9) : Colors.white),
              border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              slot,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : (isTaken ? const Color(0xFFCBD5E0) : AppColors.textMain),
                decoration: isTaken ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
