import 'dart:async';
import 'package:flutter/material.dart';
import '../../config/AppTheme.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../models/classroom.dart';
import '../../models/resource.dart';
import '../../models/sensor_reading.dart';
import '../../models/sharedspace.dart';
import '../../services/classroom_service.dart';
import '../../services/iot_service.dart';
import '../../services/resource_service.dart';
import '../../services/sharedspaces_service.dart';
import '../../utils/token_utils.dart';
import 'ClassroomDetailPage.dart';
import 'ResourceDetailPage.dart';
import 'SharedAreaDetailPage.dart';

class IotTab extends StatefulWidget {
  const IotTab({super.key});

  @override
  State<IotTab> createState() => _IotTabState();
}

class _IotTabState extends State<IotTab> {
  int _tab = 0; // 0 = salones, 1 = espacios, 2 = recursos
  Future<List<Classroom>>? _classroomsFuture;
  Future<List<SharedSpace>>? _spacesFuture;

  final _iotService = IotService();
  final _resourceService = ResourceService();
  final _sharedSpacesService = SharedSpacesService();

  // Caches: entity id → latest SensorReading (or null = offline)
  final Map<int, SensorReading?> _sensorCache = {};
  final Map<int, SensorReading?> _spaceSensorCache = {};

  Future<List<Resource>>? _resourcesFuture;

  // Loaded entities, kept so the periodic refresh can re-poll their zones.
  List<Classroom> _classrooms = [];
  List<SharedSpace> _spaces = [];
  Timer? _sensorTimer;

  @override
  void initState() {
    super.initState();
    _classroomsFuture = _loadClassrooms();
    _spacesFuture = _loadSpaces();
    _resourcesFuture = _resourceService.getMyResources();
    // Live updates: re-poll each zone's latest reading periodically.
    _sensorTimer = Timer.periodic(const Duration(seconds: 10), (_) => _refreshSensors());
  }

  @override
  void dispose() {
    _sensorTimer?.cancel();
    super.dispose();
  }

  Future<List<Classroom>> _loadClassrooms() async {
    final teacherId = await getTeacherIdFromToken();
    final all = await ClassroomService().getAllClassrooms();
    final filtered = teacherId == null ? all : all.where((c) => c.teacherId == teacherId).toList();

    _classrooms = filtered;
    _refreshSensors();
    return filtered;
  }

  Future<List<SharedSpace>> _loadSpaces() async {
    final spaces = await _sharedSpacesService.getAllSharedSpaces();
    _spaces = spaces;
    _refreshSensors();
    return spaces;
  }

  /// Re-fetches the latest reading for every classroom and shared area that has a zone.
  void _refreshSensors() {
    for (final c in _classrooms) {
      if (c.zoneId != null && c.id != null) {
        _iotService.getLatestByZone(c.zoneId!).then((reading) {
          if (mounted) setState(() => _sensorCache[c.id!] = reading);
        });
      }
    }
    for (final s in _spaces) {
      if (s.zoneId != null) {
        _iotService.getLatestByZone(s.zoneId!).then((reading) {
          if (mounted) setState(() => _spaceSensorCache[s.id] = reading);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Monitoreo IoT',
      actions: const [
        Padding(padding: EdgeInsets.only(right: 12), child: Icon(Icons.search, color: Colors.white)),
      ],
      body: Column(
        children: [
          _buildChips(),
          Expanded(
            child: switch (_tab) {
              0 => _buildSalones(),
              1 => _buildEspacios(),
              _ => _buildRecursos(),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        children: [
          _chip('Salones', _tab == 0, () => setState(() => _tab = 0)),
          const SizedBox(width: 10),
          _chip('Espacios', _tab == 1, () => setState(() => _tab = 1)),
          const SizedBox(width: 10),
          _chip('Recursos', _tab == 2, () => setState(() => _tab = 2)),
        ],
      ),
    );
  }

  Widget _chip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: active ? AppColors.primary : Colors.white)),
      ),
    );
  }

  Widget _buildEspacios() {
    return FutureBuilder<List<SharedSpace>>(
      future: _spacesFuture,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }
        if (snap.hasError || !snap.hasData || snap.data!.isEmpty) {
          return _emptyState(Icons.meeting_room_outlined, 'Sin espacios', 'No hay espacios compartidos.');
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          itemCount: snap.data!.length,
          itemBuilder: (context, i) {
            final space = snap.data![i];
            return _spaceMonitorCard(context, space, _spaceSensorCache[space.id]);
          },
        );
      },
    );
  }

  Widget _spaceMonitorCard(BuildContext context, SharedSpace space, SensorReading? sensors) {
    final isLoading = space.zoneId != null && !_spaceSensorCache.containsKey(space.id);
    final isAlert = sensors?.status == 'alert' || sensors?.status == 'danger';
    final hasDevice = space.zoneId != null;

    return AppCard(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SharedAreaDetailPage(space: space, sensors: sensors))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(space.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary))),
              if (isLoading)
                const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
              else if (!hasDevice)
                _statusBadge('Sin IoT', const Color(0xFF6B7280), const Color(0xFFF3F4F6))
              else if (sensors == null)
                _statusBadge('Offline', const Color(0xFF6B7280), const Color(0xFFF3F4F6))
              else
                _statusBadge(isAlert ? 'Alerta' : 'Activo', isAlert ? AppColors.stateWarn : AppColors.stateOk, isAlert ? const Color(0xFFFEF3C7) : const Color(0xFFDCFCE7)),
            ],
          ),
          const SizedBox(height: 12),
          if (sensors != null)
            Row(
              children: [
                _sensorChip(Icons.thermostat_outlined, '${sensors.temperature?.toStringAsFixed(1)}°C', AppColors.sensorTemp),
                const SizedBox(width: 18),
                _sensorChip(Icons.water_drop_outlined, '${sensors.humidity?.toStringAsFixed(0)}%', AppColors.sensorHumidity),
                const SizedBox(width: 18),
                _sensorChip(sensors.occupancyPresent == true ? Icons.person : Icons.person_outline, sensors.occupancyLabel, AppColors.sensorOccupancy),
              ],
            )
          else if (!isLoading)
            Text(
              hasDevice ? 'Sin lecturas recientes' : 'No hay dispositivo IoT configurado',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
        ],
      ),
    );
  }

  Widget _buildSalones() {
    return FutureBuilder<List<Classroom>>(
      future: _classroomsFuture,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }
        if (snap.hasError || !snap.hasData || snap.data!.isEmpty) {
          return _emptyState(Icons.school_outlined, 'Sin salones asignados', 'No tienes salones asignados actualmente.');
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          itemCount: snap.data!.length,
          itemBuilder: (context, i) {
            final classroom = snap.data![i];
            final sensors = classroom.id != null ? _sensorCache[classroom.id!] : null;
            return _classroomCard(context, classroom, sensors);
          },
        );
      },
    );
  }

  Widget _classroomCard(BuildContext context, Classroom classroom, SensorReading? sensors) {
    final isLoading = classroom.zoneId != null && classroom.id != null && !_sensorCache.containsKey(classroom.id!);
    final isAlert = sensors?.status == 'alert' || sensors?.status == 'danger';
    final hasDevice = classroom.zoneId != null;

    return AppCard(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ClassroomDetailPage(classroom: classroom, sensors: sensors))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(classroom.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary))),
              if (isLoading)
                const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
              else if (!hasDevice)
                _statusBadge('Sin IoT', const Color(0xFF6B7280), const Color(0xFFF3F4F6))
              else if (sensors == null)
                _statusBadge('Offline', const Color(0xFF6B7280), const Color(0xFFF3F4F6))
              else
                _statusBadge(isAlert ? 'Alerta' : 'Activo', isAlert ? AppColors.stateWarn : AppColors.stateOk, isAlert ? const Color(0xFFFEF3C7) : const Color(0xFFDCFCE7)),
            ],
          ),
          const SizedBox(height: 12),
          if (sensors != null)
            Row(
              children: [
                _sensorChip(Icons.thermostat_outlined, '${sensors.temperature?.toStringAsFixed(1)}°C', AppColors.sensorTemp),
                const SizedBox(width: 18),
                _sensorChip(Icons.water_drop_outlined, '${sensors.humidity?.toStringAsFixed(0)}%', AppColors.sensorHumidity),
                const SizedBox(width: 18),
                _sensorChip(sensors.occupancyPresent == true ? Icons.person : Icons.person_outline, sensors.occupancyLabel, AppColors.sensorOccupancy),
              ],
            )
          else if (!isLoading)
            Text(
              hasDevice ? 'Sin lecturas recientes' : 'No hay dispositivo IoT configurado',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
        ],
      ),
    );
  }

  Widget _buildRecursos() {
    return FutureBuilder<List<Resource>>(
      future: _resourcesFuture,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }
        if (snap.hasError) {
          return _emptyState(Icons.inventory_2_outlined, 'Error al cargar recursos', 'No se pudieron obtener tus recursos.');
        }
        final resources = snap.data ?? [];
        if (resources.isEmpty) {
          return _emptyState(Icons.inventory_2_outlined, 'Sin recursos', 'No tienes recursos asignados actualmente.');
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          itemCount: resources.length,
          itemBuilder: (context, i) => _resourceCard(context, resources[i]),
        );
      },
    );
  }

  Widget _resourceCard(BuildContext context, Resource resource) {
    final (label, bg, fg) = _resourceBadge(resource.status);
    return AppCard(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ResourceDetailPage(resource: resource))),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(color: Color(0xFFE0E7FF), shape: BoxShape.circle),
            child: const Icon(Icons.devices_outlined, color: Color(0xFF6366f1), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(resource.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textMain)),
                const SizedBox(height: 2),
                Text('Cód. ${resource.code} • ${resource.location}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          _statusBadge(label, fg, bg),
        ],
      ),
    );
  }

  (String, Color, Color) _resourceBadge(String status) {
    return switch (status) {
      'active' => ('En uso', AppColors.stateOk, const Color(0xFFDCFCE7)),
      'expiring' => ('Por vencer', AppColors.stateWarn, const Color(0xFFFEF3C7)),
      _ => ('Asignado', const Color(0xFF3730A3), const Color(0xFFE0E7FF)),
    };
  }

  Widget _sensorChip(IconData icon, String value, Color color) {
    return Row(children: [
      Icon(icon, size: 18, color: color),
      const SizedBox(width: 4),
      Text(value, style: TextStyle(fontSize: 14, color: AppColors.textMain, fontWeight: FontWeight.w600)),
    ]);
  }

  Widget _statusBadge(String label, Color fg, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
    );
  }

  Widget _emptyState(IconData icon, String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Colors.white70),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 6),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
