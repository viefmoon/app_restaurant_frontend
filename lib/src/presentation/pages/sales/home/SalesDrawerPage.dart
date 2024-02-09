import 'package:flutter/material.dart';
import 'bloc/SalesDrawerBloc.dart';
import 'bloc/SalesDrawerEvent.dart';
import 'bloc/SalesDrawerState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesDrawerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Aquí se podría obtener el estado actual del Bloc para personalizar el contenido del drawer
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            // Estos valores deberían ser dinámicos, basados en el estado del usuario
            accountName: Text("Nombre del Usuario"),
            accountEmail: Text("Rol del Usuario"),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Ventas'),
            onTap: () {
              // Navegar a la pantalla de Ventas
            },
          ),
          ListTile(
            leading: Icon(Icons.receipt),
            title: Text('Recibos'),
            onTap: () {
              // Navegar a la pantalla de Recibos
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Cerrar sesión'),
            onTap: () {
              // Mostrar diálogo de confirmación y cerrar sesión
            },
          ),
        ],
      ),
    );
  }
}
