import 'package:flutter/material.dart';
import 'package:winepool_final/features/wines/domain/region.dart';
import 'package:country_flags/country_flags.dart';

class RegionListItem extends StatelessWidget {
  final Region region;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const RegionListItem({
    super.key,
    required this.region,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final country = region.country;
    final hasCountry = country != null;

    return CheckboxListTile(
      title: Text(region.name ?? 'Название отсутствует'),
      subtitle: hasCountry
          ? Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 15,
                  child: CountryFlag.fromCountryCode(
                    country.code,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  country.name,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            )
          : null,
      value: isSelected,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
    );
  }
}