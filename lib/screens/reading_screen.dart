import 'package:flutter/material.dart';
import '../data/sample_texts.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  late final String _textoOriginal = obtenerTextoAleatorio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lee que te cuento')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lee el siguiente texto en voz alta:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _textoOriginal,
                  style: const TextStyle(fontSize: 20, height: 1.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
