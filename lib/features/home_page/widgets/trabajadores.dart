// Definición de la clase Trabajador
class Trabajador {
  final String nombre;
  final String oficio;
  final String barrio;
  final String apellido;
  Trabajador({
    required this.nombre,
    required this.apellido,
    required this.oficio,
    required this.barrio,
  });
}

// Lista de trabajadores de ejemplo
List<Trabajador> trabajadores = [
  Trabajador(
      nombre: 'Juan',
      oficio: 'Carpintero',
      barrio: 'Centro',
      apellido: 'perez'),
  Trabajador(
      nombre: 'Pedro',
      oficio: 'Electricista',
      barrio: 'Cordon',
      apellido: 'lopez'),
  Trabajador(
      nombre: 'María',
      oficio: 'Plomero',
      barrio: 'Punta Carretas',
      apellido: 'rodriguez'),
  Trabajador(
      nombre: 'Ana', oficio: 'Albañil', barrio: 'Malvin', apellido: 'perez'),
  Trabajador(
      nombre: 'Martin', oficio: 'Albañil', barrio: 'Cordon', apellido: 'perez'),
  Trabajador(
      nombre: 'Ana',
      oficio: 'Jardinero',
      barrio: 'Bella Italia',
      apellido: 'perez'),
  Trabajador(
      nombre: 'Ana', oficio: 'Pintor', barrio: 'Cordon', apellido: 'perez'),
  Trabajador(
      nombre: 'Laura',
      oficio: 'Pintor',
      barrio: 'La blanqueada',
      apellido: 'perez'),
  Trabajador(
      nombre: 'Ana', oficio: 'Albañil', barrio: 'Cordon', apellido: 'Ferrari'),
  // Agrega más trabajadores según tus necesidades
];
