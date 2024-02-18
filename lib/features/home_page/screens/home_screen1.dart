import 'package:flutter/material.dart';
import 'package:dame_una_mano/features/utils/app_bar.dart';
import 'package:dame_una_mano/features/home_page/widgets/widgets_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      'assets/albanil.png',
      'assets/barraca.png',
      'assets/imagen3.png',
      'assets/imagen2.png',
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [const Color(0xFF43c7ff), const Color(0xFFF5f5f5)],
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ImageCarousel(imageAssetPaths: images),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomSearchBar(
                onChanged: (String query) {
                  // Lógica para manejar la búsqueda mientras el usuario escribe
                },
                suggestions: const [
                  "albanil",
                  "electricista",
                  "carpintero"
                ], // Puedes pasar una lista vacía por ahora
              ),
            ),
            const SizedBox(height: 20),
           
          ],
        ),
      ),
    
    );
  }
}
