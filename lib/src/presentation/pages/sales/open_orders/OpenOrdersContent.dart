import 'bloc/OpenOrdersBloc.dart';
import 'bloc/OpenOrdersEvent.dart';
import 'bloc/OpenOrdersState.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OpenOrdersContent extends StatelessWidget {
  final OpenOrdersBloc? bloc;
  final OpenOrdersState state;

  OpenOrdersContent(this.bloc, this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Aquí construirías el contenido específico de las órdenes abiertas
        ],
      ),
    );
  }
}
