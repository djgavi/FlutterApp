import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/main.dart';

void main() {
  testWidgets('La pantalla de inicio saluda y muestra el botón Empezar',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final saludoEncontrado = find.textContaining('Buenos días').evaluate().isNotEmpty ||
        find.textContaining('Buenas tardes').evaluate().isNotEmpty ||
        find.textContaining('Buenas noches').evaluate().isNotEmpty;

    expect(saludoEncontrado, isTrue);
    expect(find.widgetWithText(ElevatedButton, 'Empezar'), findsOneWidget);
  });
}
