class Resource {
  final int id;
  final String name;
  final String code;
  final String category;
  final String location;
  final String status; // 'active', 'assigned', 'expiring'
  final String? assignedDate;

  Resource({
    required this.id,
    required this.name,
    required this.code,
    required this.category,
    required this.location,
    required this.status,
    this.assignedDate,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String? ?? '',
      category: json['category'] as String? ?? '',
      location: json['location'] as String? ?? '',
      status: json['status'] as String? ?? 'assigned',
      assignedDate: json['assignedDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'category': category,
        'location': location,
        'status': status,
        'assignedDate': assignedDate,
      };
}
