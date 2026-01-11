import 'package:flutter/material.dart';

class FilterOptionListItem extends StatelessWidget {
  final Widget leading;
  final String title;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const FilterOptionListItem({
    super.key,
    required this.leading,
    required this.title,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!isSelected),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 12),
          Expanded(
            child: Text(title),
          ),
          Checkbox(
            value: isSelected,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}