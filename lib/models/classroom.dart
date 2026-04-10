class Classroom {
  final int? id;
  final String name;
  final String description;
  final int teacherId;

  Classroom({
    this.id,
    required this.name,
    required this.description,
    required this.teacherId,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      id: json['id'] != null ? json['id'] as int : null,
      name: json['name'] as String,
      description: json['description'] as String,
      teacherId: json['teacherId'] as int,
    );
  }

  Map<String, dynamic> toJson({bool includeId = false}) {
    final data = {
      'name': name,
      'description': description,
    };
    if (includeId && id != null) {
      data['id'] = id!.toString();
    }
    return data;
  }
}
