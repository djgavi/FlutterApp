import 'dart:math';

/// Banco de textos de nivel de educación primaria para el ejercicio de lectura.
const List<String> textosPrimaria = [
  'El sol brilla en el cielo azul. Los pájaros cantan en los árboles del '
      'parque. Un perro corre detrás de una pelota roja mientras los niños '
      'juegan y se ríen.',
  'María tiene un gato muy juguetón. Le gusta dormir en la ventana y '
      'perseguir las mariposas del jardín. Por la noche se acurruca junto a '
      'la chimenea.',
  'En el bosque vivía un conejo curioso. Cada mañana salía a explorar entre '
      'los árboles y buscaba zanahorias frescas para desayunar con sus '
      'amigos.',
  'Pablo y Lucía construyeron un castillo de arena en la playa. Usaron '
      'cubos y palas de colores. Cuando llegó la marea, las olas se llevaron '
      'el castillo poco a poco.',
  'La abuela cuenta historias maravillosas junto a la chimenea. Habla de '
      'piratas, princesas y dragones que vivían en tierras muy lejanas hace '
      'muchos años.',
  'El tren salió de la estación muy temprano. Atravesó montañas, túneles y '
      'puentes hasta llegar a un pueblo pequeño rodeado de campos verdes.',
  'En la granja hay vacas, gallinas y un caballo blanco. Todas las mañanas '
      'el granjero les da de comer y recoge los huevos frescos para el '
      'desayuno.',
  'Ana aprendió a montar en bicicleta este verano. Al principio se caía '
      'mucho, pero con paciencia y práctica consiguió pedalear sin ayuda de '
      'nadie.',
];

/// Devuelve un texto aleatorio del banco de lecturas de primaria.
String obtenerTextoAleatorio({Random? random}) {
  final generador = random ?? Random();
  return textosPrimaria[generador.nextInt(textosPrimaria.length)];
}
