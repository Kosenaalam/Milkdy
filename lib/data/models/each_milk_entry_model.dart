

class EachMilkEntryModel {
  final String id;
  final DateTime date;
  final double liters;
  final double fat;
  final double rate;
  final double amount;
  final double recived;
  final double paid;
  final String feed;
  final String entryType;
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
    required this.feed,
    required this.entryType,
    required this.balance
  });

  factory EachMilkEntryModel.fromMap(Map<String, dynamic> map) {
    return EachMilkEntryModel(
      id: (map['id'] ?? '').toString(),
      date: DateTime.parse(map['entry_date']),
      liters: (map['liters'] ?? 0).toDouble(),
      fat: (map['actual_fat'] ?? 0).toDouble(),
      rate: (map['daily_rate'] ?? 0).toDouble(),
      amount: (map['amount'] ?? 0).toDouble(),
      recived: (map['received'] ?? 0).toDouble(),
      feed: (map['feed'] ?? '').toString(),
      paid: (map['paid'] ?? 0).toDouble(),
      entryType: (map['entry_type'] ?? '').toString(),
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
      'feed': feed,
      'entry_type': entryType,
      'balance': balance,
    };
  }
}