class MonthlyModel {
    final String id;
    final String month;
  final double liters;
  final double avgFat;
  final double tPaid;
  final double amount;
  final double recived;

  MonthlyModel({
    required this.id,
    required this.month,
    required this.liters,
    required this.avgFat,
    required this.tPaid,
    required this.amount,
    required this.recived,
  });

  factory MonthlyModel.fromMap(Map<String, dynamic> map) {
    return MonthlyModel(
      id: (map['id'] ?? '').toString(),
      month: (map['month'] ?? '' ).toString(),
      liters: (map['total_liters'] ?? 0).toDouble(),
      avgFat: (map['avg_fat'] ?? 0).toDouble(),
      tPaid: (map['total_paid'] ?? 0).toDouble(),
      amount: (map['total_amount'] ?? 0).toDouble(),
      recived: (map['total_received'] ?? 0).toDouble(),
    );
  }
}