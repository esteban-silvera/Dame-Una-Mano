import 'package:dame_una_mano/features/authentication/widgets/workers_info.dart';
import 'package:dame_una_mano/features/utils/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:dame_una_mano/features/authentication/widgets/widgets.dart';

class WorkerScreen extends StatelessWidget {
  const WorkerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/fondo2.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Puedes agregar cualquier otro widget aquí, como texto adicional
                const Text(
                  "Por último, complete los siguientes datos",
                  style: TextStyle(
                    color: Color(0xFF43c7ff),
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                    height: 20), // Espacio entre el texto y el formulario
                Container(
                    decoration: BoxDecoration(
                        color: const Color(0xB6F5F4F4),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: WorkerForm(),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
