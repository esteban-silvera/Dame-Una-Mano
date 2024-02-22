import 'package:dame_una_mano/features/authentication/widgets/widgets.dart';
import 'package:dame_una_mano/features/home_page/screens/home_screen2.dart';

import 'package:flutter/material.dart';
import 'package:dame_una_mano/features/utils/app_bar.dart';
import 'package:dame_una_mano/features/home_page/widgets/widgets_home.dart';
// Importa la pantalla de los trabajadores

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedProfession;
  List<String> searchedProfessions = [];

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      'assets/albanil.png',
      'assets/barraca.png',
      'assets/imagen3.png',
      'assets/imagen2.png',
    ];

    List<String> professions = [
      "Carpintero",
      "Electricista",
      "Plomero",
      "Albañil",
      "Jardinero",
      "Pintor",
      "Mecanico",
      "Cerrajero"
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5f5f5),
      appBar: CustomAppBar(
        onProfilePressed: () {
          // Acción al presionar el icono de perfil
        },
        onNotificationPressed: () {
          // Acción al presionar el icono de notificaciones
        },
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF43c7ff), Color(0xFFF5f5f5)],
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ImageCarousel(
                    imageAssetPaths: images,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CustomSearchBar(
                onSubmitted: (String value) {
                  // Filtrar la lista de profesiones cuando se presione enter
                  setState(() {
                    searchedProfessions = professions
                        .where((profession) => profession
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  });

                  // Navegar a la siguiente pantalla (BarrioScreen) con el valor ingresado
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BarrioScreen(
                        selectedProfession: value,
                      ),
                    ),
                  );
                },
                suggestions: professions,
                onChanged: (String value) {},
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  (professions.length / 2).ceil(),
                  (index) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      4,
                      (subIndex) {
                        final professionIndex = index * 4 + subIndex;
                        if (professionIndex < professions.length) {
                          return _buildIcon(professions[professionIndex]);
                        } else {
                          return const SizedBox(width: 60); // Espacio vacío
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 100,
                child: TextButton(
                  onPressed: () {
                    print(searchedProfessions);
                    if (selectedProfession != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BarrioScreen(
                            selectedProfession: selectedProfession!,
                            // Asegúrate de tener esta lista
                          ),
                        ),
                      );
                    }
                  },
                  style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Color(0xFF43c7ff)),
                    foregroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 248, 248, 249)),
                  ),
                  child: const Text('Siguiente'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(String profession) {
    IconData iconData = obtenerIcono(profession);

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedProfession = profession; // Almacena la profesión seleccionada
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF43c7ff)), // Borde celeste
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFF5f5f5), // Fondo blanco
                borderRadius: BorderRadius.circular(10), // Borde redondeado
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconData,
                    color: const Color.fromARGB(
                        255, 243, 152, 33), // Color del icono
                    size: 24, // Tamaño del icono
                  ),
                  const SizedBox(height: 6),
                  Text(
                    profession,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
