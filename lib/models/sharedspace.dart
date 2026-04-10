class SharedSpace {
  final int id;
  final String name;
  final int capacity;
  final String description;

  SharedSpace({
    required this.id,
    required this.name,
    required this.capacity,
    required this.description,
  });

  factory SharedSpace.fromJson(Map<String, dynamic> json) {
    return SharedSpace(
      id: json['id'] as int,
      name: json['name'] as String,
      capacity: json['capacity'] as int,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'capacity': capacity,
      'description': description,
    };
  }
}