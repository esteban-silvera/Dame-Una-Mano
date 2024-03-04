import 'package:dame_una_mano/features/home_page/widgets/barrios.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dame_una_mano/features/perfil/sceens/wokers_profile.dart';
import 'package:dame_una_mano/features/home_page/widgets/widgets_home.dart';
import 'package:dame_una_mano/features/utils/side_bar.dart';
import 'package:dame_una_mano/features/authentication/widgets/widgets.dart';

class BarrioScreen extends StatefulWidget {
  final String selectedProfession;

  BarrioScreen({
    required this.selectedProfession,
  });

  @override
  _BarrioScreenState createState() => _BarrioScreenState();
}

class _BarrioScreenState extends State<BarrioScreen> {
  String? selectedBarrio;
  List<Trabajador> trabajadores = [];

  @override
  void initState() {
    super.initState();
    _fetchTrabajadores();
  }

  Future<void> _fetchTrabajadores() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('professionals')
          .where('job', isEqualTo: widget.selectedProfession)
          .get();

      trabajadores = querySnapshot.docs.map((doc) {
        return Trabajador(
          id: doc.id, // ID del documento, que es la ID del trabajador
          nombre: doc['name'],
          apellido: doc['lastname'],
          barrio: doc['barrio'],
          oficio: doc['job'],
        );
      }).toList();

      setState(() {});
    } catch (e) {
      print('Error al obtener trabajadores: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedProfession),
      ),
      drawer: Sidebar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: DropdownButton<String>(
                  hint: const Text('Seleccionar Barrio'),
                  onChanged: (String? barrio) {
                    setState(() {
                      selectedBarrio = barrio;
                    });
                  },
                  items: barriosMontevideo.map((String barrio) {
                    return DropdownMenuItem<String>(
                      value: barrio,
                      child: Text(barrio),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 20), // Espacio a la derecha
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedBarrio != null) {
                      List<Trabajador> trabajadoresEnBarrio = trabajadores
                          .where((trabajador) =>
                              trabajador.barrio.toLowerCase() ==
                              selectedBarrio!.toLowerCase())
                          .toList();

                      if (trabajadoresEnBarrio.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Trabajadores en el Barrio'),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: trabajadoresEnBarrio.map((trabajador) {
                                  return ListTile(
                                    title: Text(
                                        '${trabajador.nombre} ${trabajador.apellido}',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.lightBlue)),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => WorkerProfileScreen(
                                            workerId: trabajador.id, userId: '',
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Aceptar'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title:
                                  const Text('No hay trabajadores en este barrio'),
                              content:
                                  const Text('Por favor, selecciona otro barrio.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Aceptar'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  child: const Text('Mostrar Trabajadores'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black, // Texto negro
                    side: BorderSide(
                      color: Color.fromRGBO(255, 130, 67, 1), // Borde personalizado
                    ),
                    shadowColor: Colors.black, // Sombreado
                    elevation: 5, // Altura de la sombra
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

