import 'package:flutter/material.dart';
import 'package:milkdy/data/models/sell_model.dart';
import 'package:milkdy/presentation/sell/milk_screen_Dashboard.dart';
import 'package:milkdy/presentation/widgets/new_milk_entry_card.dart';

class SellCardItems extends StatefulWidget{
   const SellCardItems({
    super.key, 
    required this.customer,
    required this.onDelete,
    });

   final CustumerModel customer;
   final VoidCallback? onDelete;

  @override
  State<SellCardItems> createState() => _SellCardItemsState();
}

class _SellCardItemsState extends State<SellCardItems> {
   void _milkEntryOverlay(){
    showModalBottomSheet(
      context: context, 
      useSafeArea: true,
      isScrollControlled: true,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom),
         child: NewMilkEntryCard(customerId: widget.customer.id,),
         ),
    );
    // NewMilkEntryCard(customerId:  widget.customer.id,),
    // );
   }
   void _openDashboard(){
      Navigator.push(context,
     MaterialPageRoute(
      builder: (ctx) =>
       RangeDashboardScreen(customerId: widget.customer.id,
        customerName: widget.customer.name,
        ),
        ),
      );
   }

  @override
 @override
Widget build(BuildContext context) {
  return SafeArea(
    child: Card(
      
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        leading: IconButton(
          icon: const Icon(Icons.delete, ),
          onPressed: widget.onDelete,
        ),
        title: Text(
          widget.customer.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          widget.customer.phone,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
              IconButton(
              icon: const Icon(Icons.visibility,  size: 26),
              onPressed: _openDashboard,
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.blue, size: 26),
              onPressed: _milkEntryOverlay,
            ),
          ],
        ),
      ),
    ),
  );
}
}