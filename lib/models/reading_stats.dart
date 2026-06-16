/// Estadísticas resultantes de comparar el texto original con la
/// transcripción de la lectura en voz alta.
class ReadingStats {
  final int wordCount;
  final int letterCount;
  final int matchingWords;
  final int inventedWords;
  final double similarityPercentage;

  const ReadingStats({
    required this.wordCount,
    required this.letterCount,
    required this.matchingWords,
    required this.inventedWords,
    required this.similarityPercentage,
  });
}
