
import 'package:milkdy/data/models/add_milk_entry_model.dart';
import 'package:milkdy/data/models/each_milk_entry_model.dart';
import 'package:milkdy/data/models/monthly_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
 // import 'package:intl/intl.dart';


 //final formatter = DateFormat.yMd();
class MilkRepo {
  final supabase = Supabase.instance.client;

  /// ✅ INSERT (uses your DB function)
  Future<void> addMilkEntry({
    required String customerId,
    required DateTime date,
    required double liters,
    required double fat,
    required double rate,
    required double received,
    required double paid,
    required String feedValue,
    required String fatType,
    required double fatbase,
    required String entryType,
    
  }) async {
    final userId = supabase.auth.currentUser!.id;
    

    await supabase.rpc(
      'insert_milk_entry',
      params: {
        'c_id': customerId,
        'u_id': userId,
        'entry_date': date.toIso8601String().split('T')[0],
        'liters': liters,
        'fat': fat,
        'rate': rate,
        'received': received,
        'paid': paid,
        'feed': feedValue,
        'fat_type': fatType,
        'fat_base': fatbase,
        'entry_type': entryType,
      },
    );
  }
 

  /// ✅ RANGE DASHBOARD (7/15/30) fetching the data
  // Future<List<RangeDashboardModel>> getRangeDashboard(
  //     String customerId, int days) async {

  //   final response = await supabase.rpc(
  //     'get_range_dashboard',
  //     params: {
  //       'c_id': customerId,
  //       'days_count': days,
  //     },
  //   );

  //   return (response as List)
  //       .map((e) => RangeDashboardModel.fromMap(e))
  //       .toList();
  // }
  Future<List<EachMilkEntryModel>> getEntries(
    String customerId, int days) async {

  final response = await supabase.rpc(
    'get_range_entries', // already discussed earlier
    params: {
      'c_id': customerId,
      'days_count': days,
    },
  );

  return (response as List)
        .map((e) => EachMilkEntryModel.fromMap(e))
        .toList();
}
Future<void>deletedata(String entryId)async{
  final userId = supabase.auth.currentUser!.id;
  
  final res = await supabase
  .from('distribution_ledger')
  .delete()
  .eq('id', entryId)
  .eq('user_id', userId)
  .select();
  if(res.isEmpty){
    throw Exception('error to delete');
  }
}


Future<void> recalculateBalance(String customerId) async {
  await supabase.rpc(
    'recalculate_balance',
    params: {
      'c_id': customerId,
    },
  );
}
// this is for monthly collection data fetching
Future<List<MonthlyModel>> getMonthlyCollection(
    String customerId, int months) async {

  final res = await supabase.rpc(
    'get_monthly_collection',
    params: {
      'c_id': customerId,
      'months_count': months,
    },
  );

 return (res as List).map((e) => MonthlyModel.fromMap(e)).toList();
}
 // this  is for pdf generation data fetching
Future<List<EachMilkEntryModel>> getMonthEntries(
  String customerId,
  int month,
  int year,
) async {
  final res = await supabase.rpc(
    'get_month_entries',
    params: {
      'c_id': customerId,
      'month_num': month,
      'year_num': year,
    },
  );

  return (res as List)
      .map((e) => EachMilkEntryModel.fromMap(e))
      .toList();
}
}