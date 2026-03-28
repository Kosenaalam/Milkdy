
import 'package:milkdy/data/repositories/initialise.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:milkdy/data/models/sell_model.dart';

class CustomerRepo {
   final _supabase = Supabase.instance.client;

   Future<CustumerModel> addCustumer(AddCustomerModel customer) async {
   final userId = supabase.auth.currentUser?.id;

   final response = await _supabase
    .from('customers')
    .insert(
     customer.toMap(userId!))
     .select()
     .single();
    
     return CustumerModel.fromMap(response);
   }
   Future <List<CustumerModel>> fetchCustomer() async{
    final userId = _supabase.auth.currentUser?.id;
    
    final response = 
     await _supabase
     .from('customers')
     .select('id, name, phone')
     .eq('user_id', userId!)
     .order('created_at', ascending: false,
     );
    return  (response as List)
      .map((e) => CustumerModel.fromMap(e))
      .toList(); 
   }

   Future<void> deleteCustomer( String customerId) async{
    final userId = _supabase.auth.currentUser?.id;
   final response = await _supabase
     .from('customers')
     .delete()
     .eq('id', customerId)
     .eq('user_id', userId!)
     .select();
     // If no rows were deleted, it means permission denied or not found
  if ( response.isEmpty) {
    throw Exception('Delete failed: Customer not found or permission denied');
  }
   }
  
}
 