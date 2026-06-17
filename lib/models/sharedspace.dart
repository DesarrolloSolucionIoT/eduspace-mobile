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

class SharedSpaceReservation {
  final int id;
  final int sharedSpaceId;
  final int teacherId;
  final String sharedSpaceName;
  final DateTime reservationDate;
  final String startTime;
  final String endTime;
  final String reason;
  final DateTime createdAt;

  SharedSpaceReservation({
    required this.id,
    required this.sharedSpaceId,
    required this.teacherId,
    required this.sharedSpaceName,
    required this.reservationDate,
    required this.startTime,
    required this.endTime,
    required this.reason,
    required this.createdAt,
  });

  factory SharedSpaceReservation.fromJson(Map<String, dynamic> json) {
    return SharedSpaceReservation(
      id: json['id'] as int,
      sharedSpaceId: json['sharedAreaId'] as int,
      teacherId: json['teacherId'] as int,
      sharedSpaceName: json['sharedAreaName'] as String,
      reservationDate: DateTime.parse(json['reservationDate'] as String),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      reason: json['reason'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

