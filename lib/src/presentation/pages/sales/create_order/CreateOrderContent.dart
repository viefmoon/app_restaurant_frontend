import 'bloc/CreateOrderBloc.dart';
import 'bloc/CreateOrderEvent.dart';
import 'bloc/CreateOrderState.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateOrderContent extends StatelessWidget {
  final CreateOrderBloc? bloc;
  final CreateOrderState state;

  CreateOrderContent(this.bloc, this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      // Aquí usarías la clave del formulario si es necesario
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Aquí construirías el contenido específico de la creación de órdenes
        ],
      ),
    );
  }

  // Aquí agregarías los widgets específicos para la creación de órdenes
}
