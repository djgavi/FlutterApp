import 'package:flutter/material.dart';
import '../models/reading_stats.dart';
import '../services/text_comparator.dart';

class StatsScreen extends StatelessWidget {
  final ReadingStats stats;
  final String textoOriginal;
  final String textoTranscrito;

  const StatsScreen({
    super.key,
    required this.stats,
    required this.textoOriginal,
    required this.textoTranscrito,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultados de la lectura')),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.landscape
              ? _VistaHorizontal(
                  stats: stats,
                  textoOriginal: textoOriginal,
                  textoTranscrito: textoTranscrito,
                )
              : _VistaVertical(stats: stats);
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Vista vertical: solo estadísticas
// ---------------------------------------------------------------------------

class _VistaVertical extends StatelessWidget {
  final ReadingStats stats;
  const _VistaVertical({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Estadistica(etiqueta: 'Tiempo empleado',        valor: _formatearTiempo(stats.elapsedTime)),
          _Estadistica(etiqueta: 'Palabras leídas',        valor: '${stats.wordCount}'),
          _Estadistica(etiqueta: 'Letras leídas',          valor: '${stats.letterCount}'),
          _Estadistica(etiqueta: 'Palabras coincidentes',  valor: '${stats.matchingWords}'),
          _Estadistica(etiqueta: 'Palabras inventadas',    valor: '${stats.inventedWords}'),
          _Estadistica(etiqueta: 'Palabras no leídas',     valor: '${stats.unreadWords}'),
          _Estadistica(
            etiqueta: 'Porcentaje de parecido',
            valor: '${stats.similarityPercentage.toStringAsFixed(1)} %',
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text('Volver al inicio'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Vista horizontal: comparación en dos columnas
// ---------------------------------------------------------------------------

class _VistaHorizontal extends StatelessWidget {
  final ReadingStats stats;
  final String textoOriginal;
  final String textoTranscrito;

  const _VistaHorizontal({
    required this.stats,
    required this.textoOriginal,
    required this.textoTranscrito,
  });

  @override
  Widget build(BuildContext context) {
    final palabras = TextComparator.comparacionDetallada(
      textoOriginal,
      textoTranscrito,
    );

    final spanTranscripcion = palabras.isEmpty
        ? [const TextSpan(text: '(sin transcripción)')]
        : palabras
            .map(
              (p) => TextSpan(
                text: '${p.texto} ',
                style: TextStyle(
                  color: p.coincide ? null : Colors.red,
                  fontWeight: p.coincide ? null : FontWeight.bold,
                ),
              ),
            )
            .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Columna izquierda: texto original
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Texto original',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      textoOriginal,
                      style: const TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 24),
          // Columna derecha: transcripción con errores en rojo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Transcripción',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context)
                            .style
                            .copyWith(fontSize: 15, height: 1.5),
                        children: spanTranscripcion,
                      ),
                    ),
                  ),
                ),
                const Divider(),
                Text(
                  '${_formatearTiempo(stats.elapsedTime)}  •  '
                  'Parecido: ${stats.similarityPercentage.toStringAsFixed(1)} %  •  '
                  '${stats.matchingWords} correctas  •  '
                  '${stats.inventedWords} inventadas  •  '
                  '${stats.unreadWords} no leídas',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

String _formatearTiempo(Duration d) {
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$m:$s';
}

// ---------------------------------------------------------------------------
// Widget auxiliar
// ---------------------------------------------------------------------------

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
