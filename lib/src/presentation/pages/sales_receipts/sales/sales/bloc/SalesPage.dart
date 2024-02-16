import 'package:flutter/material.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({Key? key}) : super(key: key);

  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // Esto hace que los widgets hijos se agrupen hacia el centro.
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Acción para Crear orden
              },
              child: Text('Crear orden'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(350, 150), // Tamaño específico del botón
              ),
            ),
            SizedBox(height: 20), // Espacio entre botones
            ElevatedButton(
              onPressed: () {
                // Acción para Ordenes abiertas
              },
              child: Text('Ordenes abiertas'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(400, 150), // Tamaño específico del botón
              ),
            ),
          ],
        ),
      ),
    );
  }
}
