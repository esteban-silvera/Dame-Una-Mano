import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final List<String> suggestions;
  final Function(String value) onSubmitted;
  final BuildContext context;

  const CustomSearchBar({
    Key? key,
    required this.onChanged,
    required this.suggestions,
    required this.onSubmitted,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xf1f1f1f1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xff43c7ff), width: 1.5),
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
          hintText: 'Buscar pintor,albañil...',
          hintStyle: TextStyle(
              color: Color.fromARGB(255, 4, 4, 4),
              fontSize: 16,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w300),
          prefixIcon: Icon(Icons.search, color: Color(0xFFFA7701)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
