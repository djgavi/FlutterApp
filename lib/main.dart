import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saludo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const SaludoPage(),
    );
  }
}

class SaludoPage extends StatefulWidget {
  const SaludoPage({super.key});

  @override
  State<SaludoPage> createState() => _SaludoPageState();
}

class _SaludoPageState extends State<SaludoPage> {
  static const String _textoInicial = 'Pulsa aquí para saludarte';

  String _texto = _textoInicial;
  bool _saludado = false;

  String _obtenerSaludo() {
    final hora = DateTime.now().hour;
    if (hora >= 6 && hora < 12) {
      return 'Buenos días';
    } else if (hora >= 12 && hora < 20) {
      return 'Buenas tardes';
    } else {
      return 'Buenas noches';
    }
  }

  void _alPulsar() {
    setState(() {
      if (_saludado) {
        _texto = _textoInicial;
        _saludado = false;
      } else {
        _texto = _obtenerSaludo();
        _saludado = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saludo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_texto, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _alPulsar,
              child: Text(_saludado ? 'Volver' : 'Saludar'),
            ),
          ],
        ),
      ),
    );
  }
}
