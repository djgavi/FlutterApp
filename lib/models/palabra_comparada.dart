/// Representa una palabra de la transcripción junto con si coincide o no
/// con alguna palabra del texto original.
class PalabraComparada {
  final String texto;
  final bool coincide;

  const PalabraComparada({required this.texto, required this.coincide});
}
