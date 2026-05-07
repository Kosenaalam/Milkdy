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
            title: Text(item.month,style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Milk: ${item.liters}L",style: TextStyle(fontWeight: FontWeight.bold),),
                Text("Fat: ${item.avgFat.toStringAsFixed(1)}",style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Rec: ₹${item.recived}",style: TextStyle(fontWeight: FontWeight.bold),),
                Text("Paid: ₹${item.tPaid}",style: TextStyle(fontWeight: FontWeight.bold),),
                Text("Milk Amount: ₹${item.amount}", style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}