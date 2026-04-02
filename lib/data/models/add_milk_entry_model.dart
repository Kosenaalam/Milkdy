
// // fetch helping model
// class RangeDashboardModel {
//     final String id;
//   final DateTime date;
//   final double liters;
//   final double avgFat;
//   final double avgRate;
//   final double amount;
//   final double balance;

//   RangeDashboardModel({
//     required this.id,
//     required this.date,
//     required this.liters,
//     required this.avgFat,
//     required this.avgRate,
//     required this.amount,
//     required this.balance,
//   });

//   factory RangeDashboardModel.fromMap(Map<String, dynamic> map) {
//     return RangeDashboardModel(
//       id: (map['id'] ?? '').toString(),
//       date: DateTime.parse(map['entry_date']),
//       liters: (map['total_liters'] ?? 0).toDouble(),
//       avgFat: (map['avg_fat'] ?? 0).toDouble(),
//       avgRate: (map['avg_rate'] ?? 0).toDouble(),
//       amount: (map['total_amount'] ?? 0).toDouble(),
//       balance: (map['closing_balance'] ?? 0).toDouble(),
//     );
//   }
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'entry_date': date.toIso8601String(),
//       'total_liters': liters,
//       'avg_fat': avgFat,
//       'avg_rate': avgRate,
//       'total_amount': amount,
//       'closing_balance': balance,
//     };
//   }
// }

