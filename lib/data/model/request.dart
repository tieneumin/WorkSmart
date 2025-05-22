class Request {
  int? id;
  final int userId;
  final int categoryId;
  final String body;
  String status; // e.g. "pending", "approved", "rejected"
  final String attachment;
  final DateTime createdAt;

  Request({
    this.id,
    required this.userId,
    required this.categoryId,
    required this.body,
    this.status = "pending",
    this.attachment = "",
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Request copy({
    int? id,
    int? userId,
    int? categoryId,
    String? body,
    String? status,
    String? attachment,
    DateTime? createdAt,
  }) {
    return Request(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      body: body ?? this.body,
      status: status ?? this.status,
      attachment: attachment ?? this.attachment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "userId": userId,
    "categoryId": categoryId,
    "body": body,
    "status": status,
    "attachment": attachment,
    "createdAt": createdAt.toIso8601String(),
  };

  static Request fromMap(Map<String, dynamic> map) {
    return Request(
      id: map["id"],
      userId: map["userId"],
      categoryId: map["categoryId"],
      body: map["body"],
      status: map["status"],
      attachment: map["attachment"],
      createdAt: DateTime.parse(map["createdAt"]),
    );
  }

  @override
  String toString() {
    return "Request{id: $id, userId: $userId, categoryId: $categoryId, body: $body, status: $status, attachment: $attachment, createdAt: $createdAt}";
  }
}
