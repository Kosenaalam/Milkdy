import 'package:milkdy/data/models/each_milk_entry_model.dart';
import 'package:milkdy/data/models/monthly_model.dart';
import 'package:milkdy/data/repositories/milk_entry_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final milkEntryRepoProvider = Provider((ref) => MilkRepo(),);




final getEntriesProvider = FutureProvider.family<List<EachMilkEntryModel>, ({String customerId, int days})>((ref, arg) async{
  final repo = ref.watch(milkEntryRepoProvider);
  return await repo.getEntries(arg.customerId, arg.days);
});

final deleteDataProvider = FutureProvider.family<void, String>((ref, entryId) async{
  final repo = ref.watch(milkEntryRepoProvider);
  await repo.deletedata(entryId);
});

final getMonthlyCollectionProvider = FutureProvider.family<List<MonthlyModel>, ({String customerId, int months})>((ref, arg ) async{
  final repo = ref.watch(milkEntryRepoProvider);
  return await repo.getMonthlyCollection(arg.customerId, arg.months);
});

final getpdfDataProvider = FutureProvider.family<List<EachMilkEntryModel>, ({String customerId, int month, int year})>((ref, arg) async{
  final repo = ref.watch(milkEntryRepoProvider);
  return await repo.getMonthEntries(arg.customerId, arg.month, arg.year);
});