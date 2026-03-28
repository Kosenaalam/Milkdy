
  
  import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();
  enum FateCategory{ fate, nonfate, hybrid}


class SellModel {


  const SellModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.fate,
    required this.category
  });

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final double fate;
  final FateCategory category;

  String get formatterDate{
    return formatter.format(date);
  }
}

class CustumerModel {
   CustumerModel({
    required this.id,
    required this.name,
    required this.phone,
  });
  final String id;
  final String name;
  final String phone;

  factory CustumerModel.fromMap(Map<String, dynamic> map) {
    return CustumerModel(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
    );
  }
}
class AddCustomerModel {
  final String name;
  final String phone;

  AddCustomerModel({
    required this.name,
    required this.phone,
  });

  Map<String, dynamic> toMap(String userId) {
    return {
      'name': name,
      'phone': phone,
      'user_id': userId,
    };
  }
}


// /////| pg_get_functiondef                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
// | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
// | CREATE OR REPLACE FUNCTION public.insert_milk_entry(c_id uuid, u_id uuid, liters numeric, fat numeric, rate numeric, received numeric, paid numeric)
//  RETURNS void
//  LANGUAGE plpgsql
// AS $function$
// DECLARE
//   prev_balance numeric := 0;
//   amount numeric;
//   new_balance numeric;
// BEGIN
//   SELECT balance INTO prev_balance
//   FROM distribution_ledger
//   WHERE customer_id = c_id
//   ORDER BY created_at DESC
//   LIMIT 1;

//   prev_balance := COALESCE(prev_balance, 0);

//   amount := liters * rate;

//   new_balance := prev_balance + amount - received + paid;

//   INSERT INTO distribution_ledger (
//     customer_id,
//     user_id,
//     entry_date,
//     liters,
//     actual_fat,
//     daily_rate,
//     amount,
//     received,
//     paid,
//     balance
//   )
//   VALUES (
//     c_id,
//     u_id,
//     CURRENT_DATE,
//     liters,
//     fat,
//     rate,
//     amount,
//     received,
//     paid,
//     new_balance
//   );
// END;
// $function$
//  |