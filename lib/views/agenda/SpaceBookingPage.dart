import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/AppTheme.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../models/sharedspace.dart';
import '../../services/sharedspaces_service.dart';
import '../../utils/token_utils.dart';


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

                var spaces = snap.data ?? [];
                if (_selectedFilter != 'Todos') {
                  spaces = spaces.where((s) => 
                    s.name.toLowerCase().contains(_selectedFilter.toLowerCase())
                  ).toList();
                }

                if (spaces.isEmpty) {
                  return _emptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  itemCount: spaces.length,
                  itemBuilder: (context, i) => _spaceCard(context, spaces[i]),
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
            onTap: () => setState(() { 
              _selectedFilter = f; 
              _spacesFuture = SharedSpacesService().getAllSharedSpaces();
              }),
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
  DateTime _selectedDate = DateTime.now();
  List<SharedSpaceReservation> _reservations = [];
  List<String> _allSlots = [];
  String? _selectedSlot;
  final _reasonController = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadReservations();
    _reasonController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _loadReservations() async {
  setState(() => _loading = true);
  try {
    final res = await SharedSpacesService().getReservations(widget.space.id, _selectedDate);
    final slots = List.generate(10, (i) {
        final h = (8 + i).toString().padLeft(2, '0');
        return '$h:00';
      });
      if (!mounted) return;
      setState(() {
        _reservations = res;
        _allSlots = slots;
        _selectedSlot = null;
        _loading = false;
      });
  } catch (_) {
    if (!mounted) return;
    setState(() => _loading = false);
  }
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
                  const Text('Fecha',
                      style:
                          TextStyle(fontSize: 14, color: AppColors.textMuted)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickDate,
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 16, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Text(
                          DateFormat('EEEE, d \'de\' MMMM', 'es')
                              .format(_selectedDate),
                          style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textMain,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Horarios disponibles',
                      style:
                          TextStyle(fontSize: 14, color: AppColors.textMuted)),
                  const SizedBox(height: 12),
                  _loading
                      ? const Center(
                          child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(
                              color: Colors.white),
                        ))
                      : _slotGrid(),
                  const SizedBox(height: 20),
                  const Text('Motivo de la reserva',
                      style:
                          TextStyle(fontSize: 14, color: AppColors.textMuted)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _reasonController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Ej. Clase de recuperación, conferencia...',
                      hintStyle:
                          TextStyle(fontSize: 13, color: AppColors.textMuted),
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
              onPressed: _selectedSlot == null || _reasonController.text.trim().isEmpty
                  ? null
                  : _confirmReserve,
              child: const Text('Confirmar Reserva'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      locale: const Locale('es'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
      _loadReservations();
    }
  }

  Future<void> _confirmReserve() async {
    try {
      final teacherId = await getTeacherIdFromToken();
      if (teacherId == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error: no se pudo identificar al usuario'),
              backgroundColor: Colors.red),
        );
        return;
      }
      final start = '${_selectedSlot!}:00';
      final hour = int.parse(_selectedSlot!.split(':')[0]);
      final end = '${(hour + 1).toString().padLeft(2, '0')}:00:00';

      await SharedSpacesService().reserveSpace(
        widget.space.id,
        teacherId,
        _selectedDate,
        start,
        end,
        _reasonController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Reserva realizada con éxito ✓'),
            backgroundColor: AppColors.primary),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  Widget _slotGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.5,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: _allSlots.map((slot) {
        final isTaken = _reservations.any((r) => r.startTime.substring(0, 5) == slot);
        final isSelected = _selectedSlot == slot;
        return GestureDetector(
          onTap: isTaken ? null : () => setState(() => _selectedSlot = slot),
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
