
// fetch helping model
class RangeDashboardModel {
    final String id;
  final DateTime date;
  final double liters;
  final double avgFat;
  final double avgRate;
  final double amount;
  final double balance;

  RangeDashboardModel({
    required this.id,
    required this.date,
    required this.liters,
    required this.avgFat,
    required this.avgRate,
    required this.amount,
    required this.balance,
  });

  factory RangeDashboardModel.fromMap(Map<String, dynamic> map) {
    return RangeDashboardModel(
      id: (map['id']),
      date: DateTime.parse(map['entry_date']),
      liters: (map['total_liters'] ?? 0).toDouble(),
      avgFat: (map['avg_fat'] ?? 0).toDouble(),
      avgRate: (map['avg_rate'] ?? 0).toDouble(),
      amount: (map['total_amount'] ?? 0).toDouble(),
      balance: (map['closing_balance'] ?? 0).toDouble(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'entry_date': date.toIso8601String(),
      'total_liters': liters,
      'avg_fat': avgFat,
      'avg_rate': avgRate,
      'Total_amount': amount,
      'closing_balance': balance,
    };
  }
}


// | function_name       | full_function_code                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
// | ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
// | get_range_dashboard | CREATE OR REPLACE FUNCTION public.get_range_dashboard(c_id uuid, days_count integer)
//  RETURNS TABLE(entry_date date, total_liters numeric, avg_fat numeric, avg_rate numeric, total_amount numeric, closing_balance numeric)
//  LANGUAGE sql
// AS $function$
//   SELECT
//     d1.entry_date,
//     SUM(d1.liters),
//     AVG(d1.actual_fat),
//     AVG(d1.daily_rate),
//     SUM(d1.amount),

//     (
//       SELECT d2.balance
//       FROM distribution_ledger d2
//       WHERE d2.customer_id = c_id
//         AND d2.entry_date = d1.entry_date
//       ORDER BY d2.created_at DESC
//       LIMIT 1
//     )

//   FROM distribution_ledger d1
//   WHERE d1.customer_id = c_id
//     AND d1.entry_date >= CURRENT_DATE - days_count

//   GROUP BY d1.entry_date
//   ORDER BY d1.entry_date DESC;
// $function$
//                                                                                                                                                                                                                                                                                                                                                                        |
// | get_range_entries   | CREATE OR REPLACE FUNCTION public.get_range_entries(c_id uuid, days_count integer)
//  RETURNS TABLE(entry_date date, liters numeric, actual_fat numeric, daily_rate numeric, amount numeric, received numeric, paid numeric, balance numeric)
//  LANGUAGE sql
// AS $function$
//   SELECT
//     entry_date,
//     liters,
//     actual_fat,
//     daily_rate,
//     amount,
//     received,
//     paid,
//     balance
//   FROM distribution_ledger
//   WHERE customer_id = c_id
//     AND entry_date >= CURRENT_DATE - days_count
//   ORDER BY entry_date DESC, created_at DESC;
// $function$
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
// | get_total_balance   | CREATE OR REPLACE FUNCTION public.get_total_balance(c_id uuid)
//  RETURNS double precision
//  LANGUAGE plpgsql
// AS $function$
// BEGIN
//   RETURN COALESCE(
//     (SELECT balance 
//      FROM distribution_ledger 
//      WHERE customer_id = c_id 
//      ORDER BY created_at DESC 
//      LIMIT 1), 
//     0.0
//   );
// END;
// $function$
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
// | insert_milk_entry   | CREATE OR REPLACE FUNCTION public.insert_milk_entry(c_id uuid, u_id uuid, liters numeric, fat numeric, rate numeric, received numeric, paid numeric)
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
//                                                                                                                                                                                                                 |
// | rls_auto_enable     | CREATE OR REPLACE FUNCTION public.rls_auto_enable()
//  RETURNS event_trigger
//  LANGUAGE plpgsql
//  SECURITY DEFINER
//  SET search_path TO 'pg_catalog'
// AS $function$
// DECLARE
//   cmd record;
// BEGIN
//   FOR cmd IN
//     SELECT *
//     FROM pg_event_trigger_ddl_commands()
//     WHERE command_tag IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
//       AND object_type IN ('table','partitioned table')
//   LOOP
//      IF cmd.schema_name IS NOT NULL AND cmd.schema_name IN ('public') AND cmd.schema_name NOT IN ('pg_catalog','information_schema') AND cmd.schema_name NOT LIKE 'pg_toast%' AND cmd.schema_name NOT LIKE 'pg_temp%' THEN
//       BEGIN
//         EXECUTE format('alter table if exists %s enable row level security', cmd.object_identity);
//         RAISE LOG 'rls_auto_enable: enabled RLS on %', cmd.object_identity;
//       EXCEPTION
//         WHEN OTHERS THEN
//           RAISE LOG 'rls_auto_enable: failed to enable RLS on %', cmd.object_identity;
//       END;
//      ELSE
//         RAISE LOG 'rls_auto_enable: skip % (either system schema or not in enforced list: %.)', cmd.object_identity, cmd.schema_name;
//      END IF;
//   END LOOP;
// END;
// $function$
//  |