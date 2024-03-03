import 'package:flutter/material.dart';
import 'package:dame_una_mano/features/utils/app_bar.dart';
import 'package:dame_una_mano/features/authentication/data/storage_image.dart';
import 'package:dame_una_mano/features/home_page/widgets/widgets_home.dart';
import 'package:dame_una_mano/features/home_page/screens/home_screen2.dart'; // Importar HomeScreen2 desde home_screen2.dart
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

  @override
  void initState() {
    super.initState();
    loadImagesFromStorage();
  }

  Future<void> loadImagesFromStorage() async {
    List<String> storageImages = await Future.wait([
      StorageService.getImageUrl('images/albanil.png'),
      StorageService.getImageUrl('images/barraca.png'),
      StorageService.getImageUrl('images/imagen3.png'),
      StorageService.getImageUrl('images/imagen2.png'),
    ]);
    setState(() {
      images = storageImages;
    });
  }

  Future<String> getIconUrl(String iconName) async {
    return IconStorageService.getIconUrl(iconName);
  }

  @override
  Widget build(BuildContext context) {
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
                  child: images.isEmpty
                      ? Placeholder()
                      : ImageCarousel(
                          imageUrls: images,
                        ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CustomSearchBar(
                onChanged: (String value) {
                  setState(() {
                    selectedProfession = value.isNotEmpty ? value : null;
                    if (professions
                        .map((profession) => profession.toLowerCase())
                        .contains(value.toLowerCase())) {
                      showErrorMessage = false;
                    }
                  });
                },
                onSubmitted: (String value) {
                  setState(() {
                    selectedProfession = value.isNotEmpty ? value : null;
                    if (!professions
                        .map((profession) => profession.toLowerCase())
                        .contains(value.toLowerCase())) {
                      showErrorMessage = true;
                      _showDialog(
                          'La profesión buscada no está disponible.');
                    } else {
                      showErrorMessage = false;
                      _navigateToScreen(value); // Pasar el parámetro directamente
                    }
                  });
                },
                suggestions: professions,
                context: context, // Se pasa el BuildContext al widget CustomSearchBar
              ),
            ),
            if (showErrorMessage)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'La profesión seleccionada no está disponible.',
                  style: TextStyle(color: Color.fromARGB(2, 54, 181, 244)),
                ),
              ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  (professions.length / 4).ceil(),
                  (index) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      4,
                      (subIndex) {
                        final professionIndex = index * 4 + subIndex;
                        if (professionIndex < professions.length) {
                          return Expanded(
                            child: _buildIcon(
                                professions[professionIndex], professionIndex, context), // Pasar el contexto
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
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(String profession, int index, BuildContext context) { // Agregar BuildContext aquí
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedProfession = profession;
        });
        _navigateToScreen(profession); // Pasar el parámetro directamente
      },
      child: FutureBuilder<String>(
        future: getIconUrl(
            '${IconStorageService.obtenerIconoNombre(profession)}'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return Container();
          } else if (snapshot.hasError) {
            return Icon(Icons.error);
          } else {
            return Column(
              children: [
                Container(
                  width: 75,
                  height: 80,
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: profession.toLowerCase() ==
                              selectedProfession?.toLowerCase()
                          ? Colors.orange
                          : const Color(0xFF43c7ff),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        snapshot.data!,
                        width: 40,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profession,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w200),
                      ),
                    ],
                  ),
                ),
              ],
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
        builder: (context) =>
            BarrioScreen(selectedOption: profession),
      ),
    );
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Profesion no encontrada"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  showErrorMessage = false;
                });
              },
              child: Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }
}
