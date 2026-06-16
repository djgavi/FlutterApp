import '../models/reading_stats.dart';

/// Compara el texto original con la transcripción de la lectura y genera
/// las estadísticas de la sesión.
class TextComparator {
  static final RegExp _patronPalabra = RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ]+');

  static List<String> _extraerPalabras(String texto) {
    return _patronPalabra
        .allMatches(texto.toLowerCase())
        .map((m) => m.group(0)!)
        .toList();
  }

  static ReadingStats comparar(String textoOriginal, String transcripcion) {
    final palabrasOriginales = _extraerPalabras(textoOriginal);
    final palabrasTranscritas = _extraerPalabras(transcripcion);

    final letrasLeidas = palabrasTranscritas.fold<int>(
      0,
      (suma, palabra) => suma + palabra.length,
    );

    final disponibles = <String, int>{};
    for (final palabra in palabrasOriginales) {
      disponibles[palabra] = (disponibles[palabra] ?? 0) + 1;
    }

    var coincidentes = 0;
    for (final palabra in palabrasTranscritas) {
      final restantes = disponibles[palabra] ?? 0;
      if (restantes > 0) {
        coincidentes++;
        disponibles[palabra] = restantes - 1;
      }
    }
    final inventadas = palabrasTranscritas.length - coincidentes;

    final parecido = palabrasOriginales.isEmpty
        ? 0.0
        : (coincidentes / palabrasOriginales.length * 100).clamp(0, 100);

    return ReadingStats(
      wordCount: palabrasTranscritas.length,
      letterCount: letrasLeidas,
      matchingWords: coincidentes,
      inventedWords: inventadas,
      similarityPercentage: parecido.toDouble(),
    );
  }
}
