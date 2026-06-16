import 'package:flutter/material.dart';
import '../models/reading_stats.dart';

class StatsScreen extends StatelessWidget {
  final ReadingStats stats;

  const StatsScreen({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultados de la lectura')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Estadistica(
              etiqueta: 'Palabras leídas',
              valor: '${stats.wordCount}',
            ),
            _Estadistica(
              etiqueta: 'Letras leídas',
              valor: '${stats.letterCount}',
            ),
            _Estadistica(
              etiqueta: 'Palabras coincidentes',
              valor: '${stats.matchingWords}',
            ),
            _Estadistica(
              etiqueta: 'Palabras inventadas',
              valor: '${stats.inventedWords}',
            ),
            _Estadistica(
              etiqueta: 'Porcentaje de parecido',
              valor: '${stats.similarityPercentage.toStringAsFixed(1)} %',
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Estadistica extends StatelessWidget {
  final String etiqueta;
  final String valor;

  const _Estadistica({required this.etiqueta, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(etiqueta),
        trailing: Text(
          valor,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
