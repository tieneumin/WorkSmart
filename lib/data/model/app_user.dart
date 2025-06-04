class AppUser {
  final String id;
  final String email;
  final double salary;
  final String role;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.email,
    this.salary = 0.0,
    this.role = "Employee",
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  AppUser copy({
    String? id,
    String? email,
    double? salary,
    String? role,
    DateTime? createdAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      salary: salary ?? this.salary,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "email": email,
    "salary": salary,
    "role": role,
    "created_at": createdAt.toIso8601String(),
  };

  static AppUser fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map["id"],
      email: map["email"],
      salary: (map["salary"] as num).toDouble(),
      role: map["role"],
      createdAt: DateTime.parse(map["created_at"]),
    );
  }

  @override
  String toString() => "AppUser($id, $email, $salary, $role, $createdAt)";
}
