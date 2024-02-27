import 'package:flutter/material.dart';
import 'package:dame_una_mano/features/review/functions/save_data.dart';
import 'package:dame_una_mano/features/review/screens/workersrate.dart';

class RateWorkerScreen extends StatelessWidget {
  final String workerId;

  RateWorkerScreen({required this.workerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Por favor califica al trabajador:'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RateWorkerFunction(
                  userId: "uA02wSr9GHSueX0pbqpz9TpwSru2",
                  workerId: workerId,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkerInfoScreen(
                          workerId: workerId,
                        ),
                      ),
                    );
                  },
                  child: Text('Ver Información del Trabajador'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
