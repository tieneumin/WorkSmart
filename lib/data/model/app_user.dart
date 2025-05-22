class AppUser {
  int? id;
  final String email;
  String role;
  double salary;
  final DateTime createdAt;

  AppUser({
    this.id,
    required this.email,
    this.role = "employee",
    this.salary = 0.0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  AppUser copy({
    int? id,
    String? email,
    String? role,
    double? salary,
    DateTime? createdAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      salary: salary ?? this.salary,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "email": email,
    "role": role,
    "salary": salary,
    "created_at": createdAt.toIso8601String(),
  };

  static AppUser fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map["id"],
      email: map["email"],
      role: map["role"],
      salary: map["salary"],
      createdAt: DateTime.parse(map["created_at"]),
    );
  }

  @override
  String toString() => "AppUser($id, $email, $role, $salary, $createdAt)";
}
