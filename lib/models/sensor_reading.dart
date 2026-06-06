class SensorReading {
  final int? id;
  final String? edgeReadingId;
  final String? deviceId;
  final String? zoneId;
  final double? temperature;
  final double? humidity;
  final bool? occupancyPresent;
  final int? alertLedState;
  final DateTime? recordedAt;
  final DateTime? receivedAt;

  SensorReading({
    this.id,
    this.edgeReadingId,
    this.deviceId,
    this.zoneId,
    this.temperature,
    this.humidity,
    this.occupancyPresent,
    this.alertLedState,
    this.recordedAt,
    this.receivedAt,
  });

  factory SensorReading.fromJson(Map<String, dynamic> json) {
    return SensorReading(
      id: json['id'] as int?,
      edgeReadingId: json['edgeReadingId'] as String?,
      deviceId: json['deviceId'] as String?,
      zoneId: json['zoneId'] as String?,
      temperature: (json['temperature'] as num?)?.toDouble(),
      humidity: (json['humidity'] as num?)?.toDouble(),
      occupancyPresent: json['occupancyPresent'] as bool?,
      alertLedState: json['alertLedState'] as int?,
      recordedAt: json['recordedAt'] != null ? DateTime.tryParse(json['recordedAt'] as String) : null,
      receivedAt: json['receivedAt'] != null ? DateTime.tryParse(json['receivedAt'] as String) : null,
    );
  }

  /// Derived status string for display logic. Mirrors Edge alert_led_state:
  /// 0 = ok, 1 = warn, 2+ = danger.
  String get status {
    if (alertLedState == null) return 'offline';
    if (alertLedState! >= 2) return 'danger';
    if (alertLedState! == 1) return 'alert';
    return 'active';
  }

  String get occupancyLabel => occupancyPresent == true ? 'Ocupado' : 'Libre';
}

class SensorTrendPoint {
  final String label;
  final double value;

  SensorTrendPoint({required this.label, required this.value});
}
