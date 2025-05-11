import 'package:flutter/material.dart';

class PeriodSelector extends StatelessWidget {
  final int selectedPeriod;
  final Function(int) onPeriodSelected;

  const PeriodSelector({
    Key? key,
    required this.selectedPeriod,
    required this.onPeriodSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Period',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _periodButton(1, 'Today'),
                _periodButton(7, 'Week'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _periodButton(int days, String label) {
    final isSelected = selectedPeriod == days;
    return InkWell(
      onTap: () => onPeriodSelected(days),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
