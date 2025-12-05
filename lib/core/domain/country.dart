import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

enum Country {
  russia('Russia', 'RU'),
  france('France', 'FR'),
  italy('Italy', 'IT'),
  spain('Spain', 'ES'),
  germany('Germany', 'DE'),
  usa('USA', 'US'),
  argentina('Argentina', 'AR'),
  chile('Chile', 'CL'),
  australia('Australia', 'AU'),
  newZealand('New Zealand', 'NZ');

  const Country(this.name, this.code);

  final String name;
  final String code;

  static Country? fromString(String? countryName) {
    if (countryName == null) return null;
    
    // Приводим к одному регистру для сравнения
    final normalizedCountry = countryName.toLowerCase().trim();
    
    for (final country in Country.values) {
      if (country.name.toLowerCase() == normalizedCountry ||
          country.code.toLowerCase() == normalizedCountry.toLowerCase()) {
        return country;
      }
    }
    
    return null;
 }

  Widget buildFlag({double size = 20.0}) {
    return SizedBox(
      width: size,
      height: size,
      child: CountryFlag.fromCountryCode(code),
    );
 }
  
  Widget buildFlagWithCode({double size = 20.0}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildFlag(size: size),
        const SizedBox(width: 4),
        Text(
          code,
          style: TextStyle(
            fontSize: size * 0.6,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}