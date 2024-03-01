import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final List<String> suggestions;
  final Function(String value) onSubmitted;
  final BuildContext context; // Se agrega el BuildContext como parámetro

  const CustomSearchBar({
    Key? key,
    required this.onChanged,
    required this.suggestions,
    required this.onSubmitted,
    required this.context, // Se añade el BuildContext
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5f5f5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFA7701), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        decoration: const InputDecoration(
          hintText: '¿Qué estás buscando?',
          prefixIcon: Icon(Icons.search, color: Color(0xff43c7ff)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
