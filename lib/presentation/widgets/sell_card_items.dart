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
    builder: (ctx) => NewMilkEntryCard(customerId:  widget.customer.id,),
    );
   }
   void _openDashboard(){
      Navigator.push(context,
     MaterialPageRoute(
      builder: (ctx) =>
       RangeDashboardScreen(customerId: widget.customer.id ),
        ),
      );
   }

  @override
 @override
Widget build(BuildContext context) {
  return Card(
    color: const Color.fromARGB(255, 7, 255, 61),
    elevation: 4,
    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      leading: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red, size: 22),
        onPressed: widget.onDelete,
      ),
      title: Text(
        widget.customer.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        widget.customer.phone,
        style: const TextStyle(fontSize: 14),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
            IconButton(
            icon: const Icon(Icons.visibility, color: Colors.black87, size: 26),
            onPressed: _openDashboard,
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.blue, size: 26),
            onPressed: _milkEntryOverlay,
          ),
        ],
      ),
    ),
  );
}
}