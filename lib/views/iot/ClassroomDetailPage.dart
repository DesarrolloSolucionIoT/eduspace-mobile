import 'package:flutter/material.dart';
import '../../config/AppTheme.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../models/classroom.dart';
import '../../models/sensor_reading.dart';

class ClassroomDetailPage extends StatelessWidget {
  final Classroom classroom;
  final SensorReading? sensors;

  const ClassroomDetailPage({super.key, required this.classroom, this.sensors});

  static final List<SensorTrendPoint> _tempTrend = [
    SensorTrendPoint(label: '06h', value: 55),
    SensorTrendPoint(label: '07h', value: 62),
    SensorTrendPoint(label: '08h', value: 58),
    SensorTrendPoint(label: '10h', value: 70),
    SensorTrendPoint(label: '11h', value: 65),
    SensorTrendPoint(label: '12h', value: 60),
  ];

  static final List<SensorTrendPoint> _humidityTrend = [
    SensorTrendPoint(label: '06h', value: 30),
    SensorTrendPoint(label: '07h', value: 45),
    SensorTrendPoint(label: '08h', value: 40),
    SensorTrendPoint(label: '10h', value: 55),
    SensorTrendPoint(label: '11h', value: 50),
    SensorTrendPoint(label: '12h', value: 48),
  ];

  @override
  Widget build(BuildContext context) {
    final isAlert = sensors?.status == 'alert' || sensors?.status == 'danger';
    final tempColor = isAlert ? AppColors.stateDanger : AppColors.secondary;

    return GradientScaffold(
      title: classroom.name,
      showBack: true,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        children: [
          _bigTempCard(tempColor, isAlert),
          const SizedBox(height: 16),
          _sensorSummaryCard(),
          const SizedBox(height: 24),
          const Text('Tendencias (últimas 6h)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 14),
          _trendCard('Temperatura', Icons.thermostat_outlined, AppColors.sensorTemp, '${sensors?.temperature?.toStringAsFixed(0) ?? '--'}°C', _tempTrend),
          _trendCard('Humedad', Icons.water_drop_outlined, AppColors.sensorHumidity, '${sensors?.humidity?.toStringAsFixed(0) ?? '--'}%', _humidityTrend),
          const SizedBox(height: 12),
          const Text('Información del Sensor', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          _deviceInfoCard(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _bigTempCard(Color color, bool isAlert) {
    final tempStr = sensors?.temperature?.toStringAsFixed(0) ?? '--';
    final label = sensors == null
        ? 'Sin datos del sensor'
        : isAlert
            ? 'Temperatura Alta'
            : 'Temperatura Ideal';

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Column(
            children: [
              Text('$tempStr°C', style: TextStyle(fontSize: 52, fontWeight: FontWeight.bold, color: color)),
              Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textMuted)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sensorSummaryCard() {
    return AppCard(
      margin: EdgeInsets.zero,
      leftBorderColor: AppColors.secondary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _sensorItem('HUMEDAD', '${sensors?.humidity?.toStringAsFixed(0) ?? '--'}%'),
          _sensorItem('OCUPACIÓN', sensors?.occupancyLabel ?? 'Sin datos'),
        ],
      ),
    );
  }

  Widget _sensorItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain)),
      ],
    );
  }

  Widget _trendCard(String title, IconData icon, Color color, String current, List<SensorTrendPoint> points) {
    final maxVal = points.map((p) => p.value).reduce((a, b) => a > b ? a : b);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Icon(icon, size: 18, color: color),
                  const SizedBox(width: 6),
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textMain)),
                ]),
                Text(current, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 70,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: points.map((p) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: FractionallySizedBox(
                      heightFactor: p.value / maxVal,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.85),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ),
                    ),
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(points.first.label, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
                Text(points[points.length ~/ 2].label, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
                Text(points.last.label, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _deviceInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          children: [
            _infoRow(Icons.memory, 'Dispositivo', sensors?.deviceId ?? '--'),
            const Divider(height: 1, color: AppColors.border),
            _infoRow(Icons.place_outlined, 'Zona', sensors?.zoneId ?? '--'),
            const Divider(height: 1, color: AppColors.border),
            _infoRow(Icons.schedule, 'Última lectura', _lastReadingText()),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMain),
            ),
          ),
        ],
      ),
    );
  }

  /// Hora de la última lectura + cuánto tiempo pasó (ej: "08:31:42 · hace 3 h 58 m").
  String _lastReadingText() {
    final dt = sensors?.recordedAt ?? sensors?.receivedAt;
    if (dt == null) return 'Sin datos';
    final local = dt.toLocal();
    final time = '${_two(local.hour)}:${_two(local.minute)}:${_two(local.second)}';
    return '$time · ${_relative(DateTime.now().difference(local))}';
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  String _relative(Duration d) {
    if (d.isNegative || d.inMinutes < 1) return 'hace instantes';
    if (d.inHours < 1) return 'hace ${d.inMinutes} m';
    if (d.inDays < 1) return 'hace ${d.inHours} h ${d.inMinutes % 60} m';
    return 'hace ${d.inDays} d';
  }
}
