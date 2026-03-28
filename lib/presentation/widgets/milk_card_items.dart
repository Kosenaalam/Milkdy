

import 'package:flutter/material.dart';

class MilkCardItems extends StatelessWidget{
  const MilkCardItems({
    super.key,
     required this.item,
     required this.onDelete
     });

     final VoidCallback onDelete;
  final dynamic item;

  @override
  Widget build(BuildContext context) {
   return      GestureDetector(
    onLongPress: onDelete,
     child: Card(
             child: Padding(
                   padding: const EdgeInsets.all(12),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${item.date.day}/${item.date.month}"),
                          Text("${item.liters}L"),
                          Text("${item.fat}F"),
                          Text("₹${item.rate}"),
                          Text("₹${item.amount}"),
                          Text("₹${item.recived}"),
                          Text("₹${item.paid}"),
                          Text(
                               "₹${item.balance}",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                             ),
                            ),
                          ),
                        );
  }
}