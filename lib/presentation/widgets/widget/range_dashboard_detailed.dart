import 'package:flutter/material.dart';
import 'package:milkdy/data/models/each_milk_entry_model.dart';
import 'package:milkdy/presentation/widgets/milk_card_items.dart';

class RangeDashboardDetailed extends StatelessWidget {
  final List<EachMilkEntryModel> entries;
  final Function(String) onDelete;

  const RangeDashboardDetailed({
    super.key,
    required this.entries,
    required this.onDelete,
  });


  Future<bool?> _showDeleteDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("Delete Entry?"),
      content: const Text("This will remove the entry and recalculate balances. This cannot be undone."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text("Delete", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 800,
        child: Column(
          children: [

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                 vertical: 4.0,
                 ),
              child: Container(
                color: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                 
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Date"),
                    Text("Milk"),
                    Text("Fat"),
                    Text("Rate"),
                    Text("Amount"),
                    Text("Rec"),
                    Text("Paid"),
                    Text('feed'),
                    Text("Balance"),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),

            // List of entries
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final item = entries[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,
                  ),
                  child: MilkCardItems(
                    item: item,
                    onDelete: () async {
                      final isLast = item.id != entries.first.id;
                      if (isLast) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Only latest entry can be deleted')),
                        );
                        return;
                      }

                      final confirm = await _showDeleteDialog(context);
                      if (confirm == true) {
                        onDelete(item.id);
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}