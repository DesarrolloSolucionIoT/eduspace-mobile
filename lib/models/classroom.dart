class Classroom {
  final int? id;
  final String name;
  final String description;
  final int teacherId;
  final String? zoneId;

  Classroom({
    this.id,
    required this.name,
    required this.description,
    required this.teacherId,
    this.zoneId,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      id: json['id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String,
      teacherId: json['teacherId'] as int,
      zoneId: json['zoneId'] as String?,
    );
  }

  Map<String, dynamic> toJson({bool includeId = false}) {
    final data = <String, dynamic>{
      'name': name,
      'description': description,
    };
    if (zoneId != null) data['zoneId'] = zoneId;
    if (includeId && id != null) data['id'] = id.toString();
    return data;
  }
}
