import 'package:flutter/material.dart';

IconData obtenerIcono(String profession) {
  switch (profession.toLowerCase()) {
    case 'electricista':
      return Icons.flash_on;
    case 'jardinero':
      return Icons.eco;
    case 'plomero':
      return Icons.plumbing;
    case 'carpintero':
      return Icons.build;
    case 'mecánico':
      return Icons.car_repair_rounded;
    case 'albañil':
      return Icons.construction;
    case 'pintor':
      return Icons.format_paint;
    case 'mecanico':
      return Icons.miscellaneous_services_sharp;
    case 'cerrajero':
      return Icons.key;
    default:
      // Icono predeterminado para otros oficios
      return Icons.work_outline;
  }
}

class ServiceItem extends StatelessWidget {
  final String service;

  const ServiceItem({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Acción al presionar un servicio
        print("Servicio seleccionado: $service");
        // Puedes realizar la búsqueda u otras acciones aquí
      },
      splashColor: Colors.lightBlueAccent.withOpacity(0.5),
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 12), // Ajusta el padding según sea necesario
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(color: Colors.lightBlue.shade300),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ServiceItem(service: service),
      ),
    );
  }
}
