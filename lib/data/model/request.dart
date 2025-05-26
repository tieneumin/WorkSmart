class Request {
  int? id;
  final String userId;
  final String title;
  final String body;
  String status;
  final String file;
  final DateTime createdAt;

  Request({
    this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.status = "pending",
    this.file = "",
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Request copy({
    int? id,
    String? userId,
    String? title,
    String? body,
    String? status,
    String? file,
    DateTime? createdAt,
  }) {
    return Request(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      status: status ?? this.status,
      file: file ?? this.file,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
    if (id != null) "id": id,
    "userId": userId,
    "title": title,
    "body": body,
    "status": status,
    "file": file,
    "createdAt": createdAt.toIso8601String(),
  };

  static Request fromMap(Map<String, dynamic> map) {
    return Request(
      id: map["id"],
      userId: map["userId"],
      title: map["title"],
      body: map["body"],
      status: map["status"],
      file: map["file"],
      createdAt: DateTime.parse(map["createdAt"]),
    );
  }

  @override
  String toString() {
    return "Request{id: $id, userId: $userId, title: $title, body: $body, status: $status, attachment: $file, createdAt: $createdAt}";
  }
}
