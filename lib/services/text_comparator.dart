import '../models/palabra_comparada.dart';
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

  static Map<String, int> _contarPalabras(List<String> palabras) {
    final mapa = <String, int>{};
    for (final p in palabras) {
      mapa[p] = (mapa[p] ?? 0) + 1;
    }
    return mapa;
  }

  static ReadingStats comparar(String textoOriginal, String transcripcion) {
    final palabrasOriginales = _extraerPalabras(textoOriginal);
    final palabrasTranscritas = _extraerPalabras(transcripcion);

    final letrasLeidas = palabrasTranscritas.fold<int>(
      0,
      (suma, palabra) => suma + palabra.length,
    );

    final disponibles = _contarPalabras(palabrasOriginales);

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

  /// Devuelve cada token visible de la transcripción anotado con si coincide
  /// o no con alguna palabra del texto original. Preserva el texto original
  /// de cada token (incluyendo signos de puntuación) para la visualización.
  static List<PalabraComparada> comparacionDetallada(
    String textoOriginal,
    String transcripcion,
  ) {
    final disponibles = _contarPalabras(_extraerPalabras(textoOriginal));
    final tokens = transcripcion.split(RegExp(r'\s+')).where((t) => t.isNotEmpty);

    return tokens.map((token) {
      final normalizada = _patronPalabra.stringMatch(token.toLowerCase()) ?? '';
      final restantes = disponibles[normalizada] ?? 0;
      final coincide = normalizada.isNotEmpty && restantes > 0;
      if (coincide) disponibles[normalizada] = restantes - 1;
      return PalabraComparada(texto: token, coincide: coincide);
    }).toList();
  }
}
