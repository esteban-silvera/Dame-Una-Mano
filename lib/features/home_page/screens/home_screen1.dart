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
                  child: ImageCarousel(
                    imageUrls: images,
                  ),
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
                  });
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
    return FutureBuilder<String>(
      future: IconStorageService.obtenerIconoUrl(profession), // Obtén la URL de descarga del icono según la profesión
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras se obtiene la URL del icono
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Si hay un error al obtener la URL del icono, muestra un icono predeterminado
          return Icon(Icons.error); // Puedes personalizar el icono de error según tus necesidades
        } else {
          // Si se obtiene la URL del icono exitosamente, muestra el icono
          return InkWell(
            onTap: () {
              // Acción al presionar el servicio
              print("Servicio seleccionado: $profession");
              // Puedes realizar la búsqueda u otras acciones aquí
            },
            splashColor: Colors.lightBlueAccent.withOpacity(0.5),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.lightBlue.shade300),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Image.network(snapshot.data!), // Muestra el icono utilizando la URL de descarga
            ),
          );
        }
      },
    );
  }
}
