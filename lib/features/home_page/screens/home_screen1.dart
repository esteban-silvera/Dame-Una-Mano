import 'package:flutter/material.dart';
import 'package:dame_una_mano/features/utils/side_bar.dart';
import 'package:dame_una_mano/features/home_page/widgets/widgets_home.dart';
import 'package:dame_una_mano/features/home_page/screens/home_screen2.dart';
import 'package:dame_una_mano/features/authentication/data/icon_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedProfession;
  List<String> searchedProfessions = [];
  List<String> images = [];
  bool showErrorMessage = false;
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
  String _mapProfession(String value) {
    switch (value.toLowerCase()) {
      case 'sanitario':
      case 'fontanero':
        return 'Plomero';
      default:
        return value;
    }
  }

  Future<String> getIconUrl(String iconName) async {
    return IconStorageService.getIconUrl(iconName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xf1f1f1f1),
      appBar: AppBar(
        backgroundColor: const Color(0xf1f1f1f1),
        title: const Text(
          "Dame una mano",
          textAlign: TextAlign.justify,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0), // Altura de la línea
          child: Container(
            color: const Color(0xFF43c7ff).withOpacity(0.5), // Color celeste
            height: 1.0, // Grosor de la línea
          ),
        ),
      ),
      drawer: Sidebar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: CustomSearchBar(
                onChanged: (String value) {
                  setState(() {
                    selectedProfession = _mapProfession(value);
                    if (professions
                        .map((profession) => profession.toLowerCase())
                        .contains(selectedProfession?.toLowerCase())) {
                      showErrorMessage = false;
                    }
                  });
                },
                onSubmitted: (String value) {
                  setState(() {
                    selectedProfession = _mapProfession(value);
                    if (!professions
                        .map((profession) => profession.toLowerCase())
                        .contains(selectedProfession?.toLowerCase())) {
                      showErrorMessage = true;
                      _showDialog('La profesión buscada no está disponible.');
                    } else {
                      showErrorMessage = false;
                      _navigateToScreen(selectedProfession!);
                    }
                  });
                },
                suggestions: professions,
                context: context,
              ),
            ),
            if (showErrorMessage)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'La profesión seleccionada no está disponible.',
                  style: TextStyle(
                    color: Color.fromARGB(2, 54, 181, 244),
                  ),
                ),
              ),
            const SizedBox(height: 70),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '¿Qué servicio necesitas?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  (professions.length / 2).ceil(),
                  (index) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      2,
                      (subIndex) {
                        final professionIndex = index * 2 + subIndex;
                        if (professionIndex < professions.length) {
                          return Expanded(
                            child: _buildIcon(
                              professions[professionIndex],
                              professionIndex,
                            ),
                          );
                        } else {
                          return const SizedBox(width: 50);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(String profession, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedProfession = profession;
        });
        _navigateToScreen(profession);
      },
      child: FutureBuilder<String>(
        future:
            getIconUrl('${IconStorageService.obtenerIconoNombre(profession)}'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return Container();
          } else if (snapshot.hasError) {
            return const Icon(Icons.error);
          } else {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2), blurRadius: 4)
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color.fromARGB(255, 17, 49, 63).withOpacity(0.5)
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      profession,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        shadows: [
                          Shadow(
                            color: const Color.fromARGB(255, 11, 11, 11)
                                .withOpacity(0.7),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _navigateToScreen(String profession) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen2(selectedOption: profession),
      ),
    );
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Profesion no encontrada"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  showErrorMessage = false;
                });
              },
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }
}
