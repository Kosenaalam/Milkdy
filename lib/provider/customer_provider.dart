import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:milkdy/data/models/sell_model.dart';
import 'package:milkdy/data/repositories/custumer_repo.dart';


final customerRepoProvider = Provider((ref) => CustomerRepo(),);

final customerListProvider = FutureProvider<List<CustumerModel>>((ref) async{
  final repo = ref.watch(customerRepoProvider);
  return await repo.fetchCustomer();
});

final customerDeleteProvider = FutureProvider.family<void, String>((ref, customerId) async{
  final repo = ref.watch(customerRepoProvider);
  await repo.deleteCustomer(customerId);
});





