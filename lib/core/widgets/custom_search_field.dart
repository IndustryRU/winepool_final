import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final String? hintText;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool enabled;

  const CustomSearchField({
    super.key,
    this.onChanged,
    this.controller,
    this.hintText,
    this.onTap,
    this.keyboardType,
    this.textInputAction,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onTap: onTap,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      enabled: enabled,
      decoration: InputDecoration(
        hintText: hintText ?? 'Поиск вина, винодельни или сорта...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}