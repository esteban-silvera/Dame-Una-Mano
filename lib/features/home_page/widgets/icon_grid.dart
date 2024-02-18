import 'package:flutter/material.dart';

class ProfesionIcon extends StatelessWidget {
  final String profesion;

  const ProfesionIcon({super.key, required this.profesion});

  @override
  Widget build(BuildContext context) {
    IconData iconData = obtenerIcono();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(iconData, size: 30),
        const SizedBox(height: 6),
        Text(profesion),
      ],
    );
  }

  IconData obtenerIcono() {
    switch (profesion.toLowerCase()) {
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
      default:
        // Icono predeterminado para otros oficios
        return Icons.work_outline;
    }
  }
}

class ProfesionGrid extends StatelessWidget {
  const ProfesionGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3, // Número de columnas en la cuadrícula
      crossAxisSpacing: 16, // Espaciado horizontal entre los íconos
      mainAxisSpacing: 16, // Espaciado vertical entre los íconos
      padding: const EdgeInsets.all(16), // Padding exterior de la cuadrícula
      children: const [
        ProfesionIcon(profesion: 'Electricista'),
        ProfesionIcon(profesion: 'Jardinero'),
        ProfesionIcon(profesion: 'Plomero'),
        ProfesionIcon(profesion: 'Carpintero'),
        ProfesionIcon(profesion: 'Mecánico'),
        ProfesionIcon(profesion: 'Albañil'),
        ProfesionIcon(profesion: 'Pintor'),
        ProfesionIcon(profesion: 'Otro oficio'),
      ],
    );
  }
}


class ServicesGrid extends StatelessWidget {
  final List<String> services;

  const ServicesGrid({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 6.0,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          String service = services[index];
          return ServiceItem(service: service);
        },
      ),
    );
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
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12), // Ajusta el padding según sea necesario
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
