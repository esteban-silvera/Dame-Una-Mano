import 'package:dame_una_mano/features/authentication/providers/edit_user_provider.dart';
import 'package:dame_una_mano/features/authentication/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(userProvider.user.image ??
                  'https://www.example.com/default_profile_image.jpg'),
            ),
            SizedBox(height: 20),
            _buildInfoFormField(
              title: 'Nombre:',
              initialValue: userProvider.user.name ?? '',
              onChanged: (value) => userProvider.user.name = value,
            ),
            SizedBox(height: 20),
            _buildInfoFormField(
              title: 'Apellido:',
              initialValue: userProvider.user.lastname ?? '',
              onChanged: (value) => userProvider.user.lastname = value,
            ),
            SizedBox(height: 20),
            _buildInfoFormField(
              title: 'Email:',
              initialValue: userProvider.user.email ?? '',
              onChanged: (value) => userProvider.user.email = value,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implementa la lógica para guardar los cambios del perfil aquí
                _updateProfile(context);
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                  color: Color.fromARGB(255, 250, 249, 249),
                ),
                backgroundColor: const Color(0xFFFA7701),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoFormField({
    required String title,
    required String initialValue,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _updateProfile(BuildContext context) async {
    // Obtener el proveedor de perfil
    final editprofileProvider =
        Provider.of<EditProfileProvider>(context, listen: false);

    // Obtener los datos del usuario del proveedor
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    // Crear un mapa con los datos actualizados del perfil
    final formData = {
      'name': user.name ?? '',
      'lastname': user.lastname ?? '',
      'email': user.email ?? '',
    };

    // Actualizar el perfil del usuario
    bool success = await editprofileProvider.updateUserProfile(
        formData, user.localId ?? '');

    if (success) {
      // Mostrar un mensaje de éxito o navegar a otra pantalla si es necesario
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Perfil actualizado correctamente'),
      ));
    } else {
      // Mostrar un mensaje de error si la actualización falla
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al actualizar el perfil'),
      ));
    }
  }
}
