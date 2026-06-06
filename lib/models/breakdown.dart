class Breakdown {
  final int? id;
  final String space;
  final String category;
  final String priority;
  final String description;
  final String status; // 'pending', 'assigned', 'in_repair', 'resolved'
  final String? reportedAt;

  Breakdown({
    this.id,
    required this.space,
    required this.category,
    required this.priority,
    required this.description,
    this.status = 'pending',
    this.reportedAt,
  });

  Map<String, dynamic> toJson() => {
        'space': space,
        'category': category,
        'priority': priority,
        'description': description,
        'status': status,
      };
}
