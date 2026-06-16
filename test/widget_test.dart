import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/main.dart';

void main() {
  testWidgets('Saludo cambia al pulsar el botón', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Pulsa aquí para saludarte'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Saludar'), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Pulsa aquí para saludarte'), findsNothing);
    expect(find.widgetWithText(ElevatedButton, 'Volver'), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Pulsa aquí para saludarte'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Saludar'), findsOneWidget);
  });
}
