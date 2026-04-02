import 'package:flutter/material.dart';

class RangeDashboardButtons extends StatelessWidget {
  final int selectedDays;
  final Function(int) onChanged;

  const RangeDashboardButtons({
    super.key,
    required this.selectedDays,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _btn(7, selectedDays, onChanged),
          _btn(15, selectedDays, onChanged),
          _btn(30, selectedDays, onChanged),
        ],
      ),
    );
  }

  Widget _btn(int days, int selectedDays, Function(int) onChanged) {
    final isSelected = selectedDays == days;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.amber : null,
      ),
      onPressed: () => onChanged(days),
      child: Text("$days Days"),
    );
  }
}