class Timesheet {
  int? id;
  final String userId;
  final DateTime date;
  double hours;
  DateTime createdAt;

  Timesheet({
    this.id,
    required this.userId,
    DateTime? date,
    this.hours = 0.0,
    DateTime? createdAt,
  }) : date = date ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now();

  Timesheet copy({
    int? id,
    String? userId,
    DateTime? date,
    double? hours,
    DateTime? createdAt,
  }) {
    return Timesheet(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      hours: hours ?? this.hours,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
    if (id != null) "id": id,
    "user_id": userId,
    "date": date.toIso8601String(),
    "hours": hours,
    "created_at": createdAt.toIso8601String(),
  };

  static Timesheet fromMap(Map<String, dynamic> map) {
    return Timesheet(
      id: map["id"],
      userId: map["user_id"],
      date: DateTime.parse(map["date"]),
      hours: (map["hours"] as num).toDouble(),
      createdAt: DateTime.parse(map["created_at"]),
    );
  }

  @override
  String toString() => "AppUser($id, $userId, $date, $hours, $createdAt)";
}
