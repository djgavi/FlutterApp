/// Estadísticas resultantes de comparar el texto original con la
/// transcripción de la lectura en voz alta.
class ReadingStats {
  final int wordCount;
  final int letterCount;
  final int matchingWords;
  final int inventedWords;
  final int unreadWords;
  final double similarityPercentage;
  final Duration elapsedTime;

  const ReadingStats({
    required this.wordCount,
    required this.letterCount,
    required this.matchingWords,
    required this.inventedWords,
    required this.unreadWords,
    required this.similarityPercentage,
    required this.elapsedTime,
  });
}
