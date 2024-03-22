import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsPage> {
  final TextEditingController _ipController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Añade esta línea

  @override
  void initState() {
    super.initState();
    _loadServerIP();
  }

  _loadServerIP() async {
    final prefs = await SharedPreferences.getInstance();
    String serverIP = prefs.getString('serverIP') ?? '192.168.100.32';
    _ipController.text = serverIP;
  }

  _saveServerIP() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Asume que _ipController.text solo contiene la dirección IP sin el puerto
      await prefs.setString('serverIP', _ipController.text);
      _showSnackBar('Dirección IP guardada con éxito');
    } catch (e) {
      _showSnackBar('Error al guardar la dirección IP');
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Asigna el GlobalKey al Scaffold
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _ipController,
              style: TextStyle(fontSize: 20), // Aumenta el tamaño del texto
              decoration: InputDecoration(
                labelText: 'Dirección IP del Servidor',
                labelStyle: TextStyle(
                    fontSize: 26), // Aumenta el tamaño del texto del label
              ),
            ),
            SizedBox(
                height:
                    20), // Añade una separación entre el campo de texto y el botón
            SizedBox(
              width: double
                  .infinity, // Hace que el botón se expanda a lo largo del ancho disponible
              height: 60, // Aumenta la altura del botón
              child: ElevatedButton(
                onPressed: () {
                  _saveServerIP();
                },
                child: Text('Guardar',
                    style:
                        TextStyle(fontSize: 20)), // Aumenta el tamaño del texto
              ),
            ),
          ],
        ),
      ),
    );
  }
}
