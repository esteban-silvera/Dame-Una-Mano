import 'package:dame_una_mano/features/home_page/widgets/barrios.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dame_una_mano/features/perfil/sceens/wokers_profile.dart';
import 'package:dame_una_mano/features/home_page/widgets/widgets_home.dart';
import 'package:dame_una_mano/features/utils/side_bar.dart';
import 'package:dame_una_mano/features/authentication/widgets/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
      backgroundColor: const Color(0xf1f1f1f1),
      appBar: AppBar(
        backgroundColor: const Color(0xf1f1f1f1),
        title: Text(widget.selectedProfession),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0), // Altura de la línea
          child: Container(
            color: const Color(0xFF43c7ff).withOpacity(0.5), // Color celeste
            height: 1.0, // Grosor de la línea
          ),
        ),
      ),
      drawer: Sidebar(),
      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xedededed),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        margin: const EdgeInsets.fromLTRB(30, 100, 30, 70),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Texto "Dame una mano" con icono de handshake
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Dame una mano',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: "Monserrat",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.handshake,
                      color: Colors.black,
                      size: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFF43c7ff)), // Borde celeste
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                icon: const Icon(
                                  Icons.search,
                                  color: Color(0xFFFa7701), // Color naranja
                                  size: 24, // Tamaño del icono
                                ),
                                hint: const Text(
                                  'Seleccionar Barrio',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black, // Texto negro
                                  ),
                                ),
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
                          ],
                        ),
                      ),
                      const SizedBox(
                          height:
                              40), // Espacio entre el texto y el DropdownButton
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(0.8), // Espacio a la derecha
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedBarrio == null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("No se ha seleccionado un barrio"),
                              content: const Text(
                                'Por favor, selecciona uno para continuar.',
                                style: TextStyle(fontSize: 16),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Aceptar',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
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
                                title: const Text('Trabajadores cercanos'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        trabajadoresEnBarrio.map((trabajador) {
                                      return ListTile(
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${trabajador.nombre} ${trabajador.apellido}',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Color.fromARGB(
                                                    239, 0, 0, 0),
                                              ),
                                            ),
                                            FutureBuilder<QuerySnapshot>(
                                              future: FirebaseFirestore.instance
                                                  .collection('professionals')
                                                  .doc(trabajador
                                                      .id) // Usar la ID del trabajador
                                                  .collection('ratings')
                                                  .get(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return CircularProgressIndicator(
                                                    color: Color(0xFF43c7ff)
                                                        .withOpacity(0.8),
                                                  );
                                                }
                                                if (snapshot.hasError) {
                                                  return const Text(
                                                      'Error al cargar los datos del trabajador');
                                                }

                                                var ratings = snapshot
                                                    .data!.docs
                                                    .map((doc) =>
                                                        (doc["rating"] as num)
                                                            .toDouble())
                                                    .toList();
                                                double averageRating = ratings
                                                        .isEmpty
                                                    ? 0.0
                                                    : ratings.reduce(
                                                            (a, b) => a + b) /
                                                        ratings.length;

                                                return Row(
                                                  children: [
                                                    RatingBarIndicator(
                                                      rating: averageRating,
                                                      itemBuilder:
                                                          (context, index) =>
                                                              const Icon(
                                                        Icons.star,
                                                        color:
                                                            Color(0xFFFA7701),
                                                      ),
                                                      itemCount: 5,
                                                      itemSize: 20.0,
                                                      direction:
                                                          Axis.horizontal,
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  WorkerProfileScreen(
                                                workerId: trabajador.id,
                                                userId: '',
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                    'No hay trabajadores en este barrio'),
                                content: const Text(
                                    'Por favor, selecciona otro barrio.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Aceptar',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Encuentra!',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      foregroundColor: Colors.black, // Texto negro
                      side: const BorderSide(
                        color: Color(0xffFA7701),
                      ),
                      shadowColor: Colors.black, // Sombreado
                      elevation: 5, // Altura de la sombra
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
