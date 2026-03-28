

class EachMilkEntryModel {
  final String id;
  final DateTime date;
  final double liters;
  final double fat;
  final double rate;
  final double amount;
  final double recived;
  final double paid;
  final double balance;

  EachMilkEntryModel({
    required this.id,
    required this.date,
    required this.liters,
    required this.fat,
    required this.rate,
    required this.amount,
    required this.recived,
    required this.paid,
    required this.balance
  });

  factory EachMilkEntryModel.fromMap(Map<String, dynamic> map) {
    return EachMilkEntryModel(
      id: (map['id']),
      date: DateTime.parse(map['entry_date']),
      liters: (map['liters'] ?? 0).toDouble(),
      fat: (map['actual_fat'] ?? 0).toDouble(),
      rate: (map['daily_rate'] ?? 0).toDouble(),
      amount: (map['amount'] ?? 0).toDouble(),
      recived: (map['received'] ?? 0).toDouble(),
      paid: (map['paid'] ?? 0).toDouble(),
      balance: (map['balance'] ?? 0).toDouble(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'entry_date': date.toIso8601String().split('T')[0],
      'liters': liters,
      'actual_fat': fat,
      'daily_rate': rate,
      'amount': amount,
      'received': recived,
      'paid': paid,
      'balance': balance,
    };
  }
}