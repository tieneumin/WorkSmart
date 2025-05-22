// class Session {
//   int? id;
//   int userId;
//   // If using flat hours, set start and end to null and use hours.
//   DateTime? start;
//   DateTime? end;
//   int? hours; // EOD flat hours (e.g. 8)
//   DateTime date; // The day this session is for

//   Session({
//     this.id,
//     required this.userId,
//     this.start,
//     this.end,
//     this.hours,
//     required this.date,
//   });

//   Map<String, dynamic> toMap() => {
//     'id': id,
//     'userId': userId,
//     'start': start?.toIso8601String(),
//     'end': end?.toIso8601String(),
//     'hours': hours,
//     'date': date.toIso8601String(),
//   };

//   static Session fromMap(Map<String, dynamic> map) => Session(
//     id: map['id'],
//     userId: map['userId'],
//     start: map['start'] != null ? DateTime.parse(map['start']) : null,
//     end: map['end'] != null ? DateTime.parse(map['end']) : null,
//     hours: map['hours'],
//     date: DateTime.parse(map['date']),
//   );
// }
