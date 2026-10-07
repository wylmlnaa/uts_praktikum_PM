import 'package:flutter/material.dart';

/// Custom RadioButtonGroup Widget matching requirements
class RadioButtonGroup extends StatelessWidget {
  final List<String> labels;
  final String? picked;
  final ValueChanged<String> onSelected;
  final Color activeColor;

  const RadioButtonGroup({
    super.key,
    required this.labels,
    this.picked,
    required this.onSelected,
    this.activeColor = const Color(0xFF2563EB),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: labels.map((label) {
        final bool isSelected = picked == label;
        return InkWell(
          onTap: () => onSelected(label),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? activeColor.withValues(alpha: 0.08) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? activeColor : const Color(0xFFE2E8F0),
                width: isSelected ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? activeColor : const Color(0xFF94A3B8),
                      width: isSelected ? 6 : 2,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF475569),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Custom CheckboxGroup Widget matching requirements
class CheckboxGroup extends StatelessWidget {
  final List<String> labels;
  final List<String> checked;
  final ValueChanged<List<String>> onSelected;
  final Color activeColor;

  const CheckboxGroup({
    super.key,
    required this.labels,
    required this.checked,
    required this.onSelected,
    this.activeColor = const Color(0xFF2563EB),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: labels.map((label) {
        final bool isChecked = checked.contains(label);
        return InkWell(
          onTap: () {
            final newList = List<String>.from(checked);
            if (isChecked) {
              newList.remove(label);
            } else {
              newList.add(label);
            }
            onSelected(newList);
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isChecked ? activeColor.withValues(alpha: 0.08) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isChecked ? activeColor : const Color(0xFFE2E8F0),
                width: isChecked ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: isChecked,
                  activeColor: activeColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  onChanged: (bool? val) {
                    final newList = List<String>.from(checked);
                    if (val == true) {
                      if (!newList.contains(label)) newList.add(label);
                    } else {
                      newList.remove(label);
                    }
                    onSelected(newList);
                  },
                ),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isChecked ? FontWeight.bold : FontWeight.w500,
                      color: isChecked ? const Color(0xFF1E293B) : const Color(0xFF475569),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
