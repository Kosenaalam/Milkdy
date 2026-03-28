

import 'package:flutter/material.dart';

class MilkCardItem extends StatelessWidget{
  const MilkCardItem({
    super.key, 
  required this.item,
  });

  final dynamic item;

  @override
  Widget build(BuildContext context) {
   return  Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
             child: Padding(
             padding: const EdgeInsets.all(10),
              child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Text("${item.date.day}/${item.date.month}",
                       style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("${item.liters}L"),
                    Text(item.avgFat.toStringAsFixed(1)),
                    Text("₹${item.avgRate.toStringAsFixed(0)}"),
                    Text("₹${item.amount.toStringAsFixed(0)}"),
                    Text(
                     "₹${item.balance.toStringAsFixed(0)}",
                       style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                 ),
              ),
           );
    }
 }