import 'package:flutter/material.dart';
import 'package:milkdy/data/models/monthly_model.dart';

class RangeDashboardMonthly extends StatelessWidget {
  final List<MonthlyModel> monthlyData;

  const RangeDashboardMonthly({super.key, required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: monthlyData.map((item) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            title: Text(item.month),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Milk: ${item.liters}L"),
                Text("Fat: ${item.avgFat.toStringAsFixed(1)}"),
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Rec: ₹${item.recived}"),
                Text("Paid: ₹${item.tPaid}"),
                Text("Milk Amount: ₹${item.amount}", style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}