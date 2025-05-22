// class Salary {
//   int? id;
//   int? userId;
//   double amount;
//   // DateTime date; // e.g. salary for this month
//   // String? pdfUrl; // for generated salary slip (optional)

//   Salary({
//     this.id,
//     required this.userId,
//     required this.amount,
//     // required this.date,
//     // this.pdfUrl,
//   });

//   Map<dynamic, dynamic> toMap() => {
//     'id': id,
//     'userId': userId,
//     'amount': amount,
//     // 'date': date.toIso8601String(),
//     // 'pdfUrl': pdfUrl,
//   };

//   static Salary fromMap(Map<dynamic, dynamic> map) => Salary(
//     id: map['id'],
//     userId: map['userId'],
//     amount: map['amount'],
//     // date: DateTime.parse(map['date']),
//     // pdfUrl: map['pdfUrl'],
//   );
// }
