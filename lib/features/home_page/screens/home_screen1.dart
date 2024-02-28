import 'package:flutter/material.dart';
import 'package:dame_una_mano/features/utils/app_bar.dart';
import 'package:dame_una_mano/features/authentication/data/storage_image.dart';
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
  bool showErrorMessage =
      false; // Nuevo booleano para controlar la visibilidad del mensaje de error

  @override
  void initState() {
    super.initState();
    loadImagesFromStorage();
  }

  Future<void> loadImagesFromStorage() async {
    // Obtener las URL de las imágenes desde Firebase Storage
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
                  child: images.isEmpty
                      ? Placeholder() // Muestra un Placeholder si no hay imágenes cargadas
                      : ImageCarousel(
                          imageUrls:
                              images), // Muestra el carrusel de imágenes si hay imágenes cargadas
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CustomSearchBar(
                onSubmitted: (String value) {
                  setState(() {
                    searchedProfessions = professions
                        .where((profession) => profession
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                    selectedProfession = searchedProfessions.isNotEmpty
                        ? searchedProfessions.first
                        : null; // Establece la profesión seleccionada
                    // Verificar si la profesión buscada está en la lista de sugerencias
                    if (!professions.contains(value)) {
                      showErrorMessage =
                          true; // Mostrar mensaje de error si la profesión no está en la lista de sugerencias
                    } else {
                      showErrorMessage =
                          false; // Ocultar mensaje de error si la profesión está en la lista de sugerencias
                    }
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BarrioScreen(
                        selectedProfession: selectedProfession!,
                      ),
                    ),
                  );
                },
                suggestions: professions,
                onChanged: (String value) {
                  setState(() {
                    selectedProfession = value.isNotEmpty
                        ? value
                        : null; // Actualiza la profesión seleccionada
                    // Ocultar el mensaje de error al cambiar el texto
                    if (professions.contains(value)) {
                      showErrorMessage = false;
                    }
                  });
                },
              ),
            ),
            // Mostrar mensaje de error si la profesión buscada no está en la lista de sugerencias
            Visibility(
              visible: showErrorMessage,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'La profesión buscada no está disponible',
                  style: TextStyle(color: Color(0xFF43c7ff)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  (professions.length / 4).ceil(), // Cambiado a 3
                  (index) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      4, // Cambiado a 3
                      (subIndex) {
                        final professionIndex =
                            index * 4 + subIndex; // Cambiado a 3
                        if (professionIndex < professions.length) {
                          return Expanded(
                            child: _buildIcon(
                                professions[professionIndex], professionIndex),
                          );
                        } else {
                          return const SizedBox(width: 50); // Espacio vacío
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                // Reducido el ancho del contenedor
                child: TextButton(
                  onPressed: () {
                    print(searchedProfessions);
                    if (selectedProfession != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BarrioScreen(
                            selectedProfession: selectedProfession!,
                          ),
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.all(
                          1.0), // Esto agregará un espacio de 16.0 en todos los lados
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF43c7ff)),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 248, 248, 249)),
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

  Widget _buildIcon(String profession, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedProfession = profession; // Almacena la profesión seleccionada
        });
      },
      child: FutureBuilder<String>(
        future:
            getIconUrl('${IconStorageService.obtenerIconoNombre(profession)}'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return Container();
          } else if (snapshot.hasError) {
            return Icon(
                Icons.error); // Muestra un ícono de error si ocurre un error
          } else {
            return Column(
              children: [
                Container(
                  width: 75, // Reducido el ancho del contenedor
                  height: 80, // Ajusta la altura para que se vean mejor
                  margin: const EdgeInsets.all(
                      4.0), // Añade un margen entre los iconos
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: profession.toLowerCase() ==
                              selectedProfession?.toLowerCase()
                          ? Colors.orange
                          : const Color(
                              0xFF43c7ff), // Cambia el color del borde si la profesión está seleccionada
                      width: 1.5, // Aumenta el grosor del borde
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        snapshot.data!,
                        width:
                            40, // Ajusta el ancho de la imagen para evitar el desbordamiento
                      ), // Muestra el icono utilizando la URL de descarga
                      const SizedBox(height: 4),
                      Text(
                        profession,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w200), // Color del texto
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
}
