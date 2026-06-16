import 'package:flutter/material.dart';
import 'reading_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _obtenerSaludo() {
    final hora = DateTime.now().hour;
    if (hora >= 6 && hora < 12) {
      return 'Buenos días';
    } else if (hora >= 12 && hora < 20) {
      return 'Buenas tardes';
    } else {
      return 'Buenas noches';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lee que te cuento')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_obtenerSaludo()}!',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ReadingScreen()),
                );
              },
              child: const Text('Empezar'),
            ),
          ],
        ),
      ),
    );
  }
}
