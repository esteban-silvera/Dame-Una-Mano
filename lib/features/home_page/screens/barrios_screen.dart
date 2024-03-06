import 'package:dame_una_mano/features/home_page/screens/home_screen3.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dame_una_mano/features/perfil/screens/wokers_profile.dart';
import 'package:dame_una_mano/features/home_page/widgets/widgets_home.dart';
import 'package:dame_una_mano/features/utils/side_bar.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dame_una_mano/features/controllers/location_controller.dart';

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
  final LocationController _locationController = LocationController();
  bool _isLocationLoaded = false;

  Future<void> _getLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      try {
        var position = await _locationController.getCurrentLocation();
        await _locationController.updateCurrentLocationInFirestore();
        setState(() {
          _isLocationLoaded = true;
        });
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapScreen(
              selectedOption: widget.selectedProfession,
              currentAddress: position.address,
              initialCameraPosition: position.position,
              isLocationLoaded: _isLocationLoaded,
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error obteniendo la ubicación.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Se requiere permiso de ubicación.'),
        ),
      );
    }
  }

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
          id: doc.id,
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double iconSize = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: const Color(0xf1f1f1f1),
      appBar: AppBar(
        backgroundColor: Color(0xFF43c7ff).withOpacity(0.9),
        title: Text(widget.selectedProfession,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 0, 0, 0),
            )),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            color: const Color(0xFF43c7ff).withOpacity(0.5),
            height: 1.0,
          ),
        ),
      ),
      drawer: Sidebar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ProfessionCarousel(
              selectedProfession: widget.selectedProfession,
              onProfessionSelected: (String profession) {},
            ),
            const SizedBox(height: 40),
            Container(
              margin: EdgeInsets.fromLTRB(30, 0, 30, 70),
              padding: EdgeInsets.fromLTRB(20, 50, 10, 0),
              decoration: BoxDecoration(
                color: const Color(0xff1f1f1f1),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 39, 38, 38).withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Dame una mano',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: "Montserrat",
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF43c7ff)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            scrollbarTheme: ScrollbarThemeData(
                              thumbColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered)) {
                                    return const Color(0xFF43c7ff);
                                  }
                                  return const Color(0xFF43c7ff)
                                      .withOpacity(0.7);
                                },
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    icon: Icon(
                                      Icons.search,
                                      color: Color(0xFFFa7701),
                                      size:
                                          iconSize, // Usando el tamaño del icono calculado
                                    ),
                                    hint: Text(
                                      'Seleccionar Barrio',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                    onChanged: (String? barrio) {
                                      setState(() {
                                        selectedBarrio = barrio;
                                      });
                                    },
                                    items:
                                        barriosMontevideo.map((String barrio) {
                                      return DropdownMenuItem<String>(
                                        value: barrio,
                                        child: Text(barrio),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    // Espacio a la derecha
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedBarrio == null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                    "No se ha seleccionado un barrio"),
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
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 2, 2, 2),
                                      ),
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
                                      children: trabajadoresEnBarrio
                                          .map((trabajador) {
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
                                                future: FirebaseFirestore
                                                    .instance
                                                    .collection('professionals')
                                                    .doc(trabajador
                                                        .id) // Usar la ID del trabajador
                                                    .collection('ratings')
                                                    .get(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return CircularProgressIndicator(
                                                      color: const Color(
                                                              0xFF43c7ff)
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6f6f6f6),
                        foregroundColor: Colors.black, // Texto negro
                        side: const BorderSide(
                          color: Color(0xffFA7701),
                        ),
                        shadowColor: Colors.black,
                        elevation: 5,
                      ),
                      child: const Text(
                        'Encuentra!',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: _getLocation, // Ejecutar la función _getLocation
                  child: const Text(
                    'Cambiar a ubicación actual',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w200,
                      color: Color.fromARGB(255, 0, 0, 0), // Color del texto
                      decoration: TextDecoration.underline, // Subrayado
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
