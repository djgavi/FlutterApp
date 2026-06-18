import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/services/text_comparator.dart';

void main() {
  test('detecta palabras coincidentes e inventadas', () {
    const original = 'El sol brilla en el cielo azul';
    const transcripcion = 'El sol brilla en el cielo morado';

    final stats = TextComparator.comparar(original, transcripcion);

    expect(stats.wordCount, 7);
    expect(stats.matchingWords, 6);
    expect(stats.inventedWords, 1);
    expect(stats.similarityPercentage, closeTo(85.7, 0.1));
  });

  test('una transcripcion vacia no tiene coincidencias', () {
    final stats = TextComparator.comparar('Hola mundo', '');

    expect(stats.wordCount, 0);
    expect(stats.matchingWords, 0);
    expect(stats.similarityPercentage, 0);
  });

  test('comparacionDetallada marca en rojo solo las palabras no coincidentes', () {
    const original = 'El sol brilla en el cielo azul';
    const transcripcion = 'El sol brilla en el cielo morado';

    final resultado = TextComparator.comparacionDetallada(original, transcripcion);

    expect(resultado.length, 7);
    final coincidentes = resultado.where((p) => p.coincide).toList();
    final noCoincidentes = resultado.where((p) => !p.coincide).toList();
    expect(coincidentes.length, 6);
    expect(noCoincidentes.length, 1);
    expect(noCoincidentes.first.texto, 'morado');
  });
}
