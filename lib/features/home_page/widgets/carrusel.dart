import 'package:dame_una_mano/features/authentication/data/icon_storage.dart';
import 'package:flutter/material.dart';

class ProfessionCarousel extends StatelessWidget {
  final String selectedProfession;
  final void Function(String) onProfessionSelected;

  ProfessionCarousel({
    required this.selectedProfession,
    required this.onProfessionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _loadProfessionImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(
            color: Color(0XFF43C7FF).withOpacity(0.5),
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No se encontraron imágenes de profesiones');
        }
        return SizedBox(
          height: 170, // Altura del carrusel
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final professionImage = snapshot.data![index];
              return GestureDetector(
                onTap: () => onProfessionSelected(professionImage),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          professionImage,
                          width: 120, // Ancho de la imagen
                          height: 120, // Alto de la imagen
                          fit: BoxFit.cover, // Ajuste de la imagen
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<List<String>> _loadProfessionImages() async {
    List<String> professionImages = [];
    try {
      // Cargar las imágenes de las profesiones desde Firebase Storage
      for (String profession in _getProfessions()) {
        final iconName = IconStorageService.obtenerIconoNombre(profession);
        final iconUrl = await IconStorageService.getIconUrl(iconName);
        professionImages.add(iconUrl);
      }
    } catch (e) {
      print('Error al cargar las imágenes de las profesiones: $e');
    }
    return professionImages;
  }

  List<String> _getProfessions() {
    // Lista de profesiones disponibles
    return [
      'electricista',
      'jardinero',
      'plomero',
      'carpintero',
      'mecanico',
      'albañil',
      'pintor',
      'cerrajero',
    ];
  }
}
