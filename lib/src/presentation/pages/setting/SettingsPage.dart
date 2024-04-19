import 'package:app/src/domain/repositories/OrdersRepository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/src/domain/utils/Resource.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsPage> {
  final TextEditingController _ipController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Añade esta línea
  late OrdersRepository ordersRepository;

  @override
  void initState() {
    super.initState();
    ordersRepository = GetIt.instance
        .get<OrdersRepository>(); // Utiliza getIt para obtener la instancia
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
      _showSnackBar('Dirección IP guardada con éxito', true);
    } catch (e) {
      _showSnackBar('Error al guardar la dirección IP', false);
    }
  }

  void _showSnackBar(String message, bool isSuccess) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
    );
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
            SizedBox(height: 20), // Espacio adicional para el nuevo botón
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () async {
                  // Asegúrate de que ordersRepository está inicializado
                  var result = await ordersRepository.resetDatabase();
                  if (result is Success) {
                    // Asegúrate de que Success está definido
                    _showSnackBar('La base de datos ha sido reseteada.', true);
                  } else {
                    _showSnackBar('Error al resetear la base de datos.', false);
                  }
                },
                child: Text('Resetear Base de Datos',
                    style: TextStyle(fontSize: 20)),
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red), // Cambiado 'primary' a 'backgroundColor'
              ),
            ),
          ],
        ),
      ),
    );
  }
}
