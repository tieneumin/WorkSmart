// class Timesheet {
//   int? userId;
//   int? id;
//   String title;
//   String body;

//   Timesheet({this.id, this.userId, required this.title, required this.body});

//   @override
//   String toString() {
//     return "Timesheet($userId, $id, $title, $body)";
//   }

//   Map<dynamic, dynamic> toMap() {
//     return {"userId": 1, "title": title, "body": body};
//   }

//   static Timesheet fromMap(Map<dynamic, dynamic> map) {
//     return Timesheet(
//       userId: map["userId"],
//       id: map["id"],
//       title: map["title"],
//       body: map["body"],
//     );
//   }
// }
