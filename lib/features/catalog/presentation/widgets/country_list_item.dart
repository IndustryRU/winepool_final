import 'package:flutter/material.dart';
import 'package:winepool_final/features/wines/domain/country.dart';
import 'package:country_flags/country_flags.dart';

class CountryListItem extends StatelessWidget {
  final Country country;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const CountryListItem({
    super.key,
    required this.country,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!isSelected);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              height: 24,
              child: CountryFlag.fromCountryCode(
                country.code,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              country.code.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(country.name)),
            Checkbox(
              value: isSelected,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}