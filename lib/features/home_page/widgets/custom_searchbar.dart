import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final List<String> suggestions;

  const CustomSearchBar({
    Key? key,
    required this.onChanged,
    required this.suggestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:const Color(0xFFF5f5f5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFA7701), width: 2), // Color de los bordes celeste
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Color de la sombra
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Cambia la posición de la sombra
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: const InputDecoration(
          hintText: 'Buscar...',
          prefixIcon: Icon(Icons.search, color:Color(0xff43c7ff)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
