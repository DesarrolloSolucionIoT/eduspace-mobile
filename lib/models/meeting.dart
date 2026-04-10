class Meeting {
  final int? meetingId;
  final String title;
  final String description;
  final String date;
  final String start;
  final String end;
  final int administratorId;
  final int classroomId;

  Meeting({
     this.meetingId,
    required this.title,
    required this.description,
    required this.date,
    required this.start,
    required this.end,
    required this.administratorId,
    required this.classroomId,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      meetingId: json['meetingId'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      date: json['date'] as String? ?? '',
      start: json['start'] as String? ?? '',
      end: json['end'] as String? ?? '',
      administratorId: json['administratorId']?['administratorIdentifier'] as int? ?? 0,
      classroomId: json['classroomId']?['classroomIdentifier'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'start': start,
      'end': end,
      'administratorId': {'administratorIdentifier': administratorId},
      'classroomId': {'classroomIdentifier': classroomId},
    };
  }
}
