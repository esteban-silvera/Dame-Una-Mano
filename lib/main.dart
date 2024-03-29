import 'package:dame_una_mano/features/first_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/config/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:dame_una_mano/features/authentication/providers/providers.dart';
import 'package:dame_una_mano/features/authentication/screens/screens.dart';

void main() async {
  // Inicializa Firebase antes de ejecutar runApp
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => EditProfileProvider()),
        // Aquí puedes agregar más providers si es necesario
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner:
            false, // Aquí eliminas la franja de depuración
        title: 'Tu Aplicación',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FirstScreen(),
      ),
    );
  }
}
