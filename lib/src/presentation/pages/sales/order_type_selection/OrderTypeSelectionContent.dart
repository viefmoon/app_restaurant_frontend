import 'bloc/OrderTypeSelectionBloc.dart';
import 'bloc/OrderTypeSelectionEvent.dart';
import 'bloc/OrderTypeSelectionState.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderTypeSelectionContent extends StatelessWidget {
  final OrderTypeSelectionBloc? bloc;
  final OrderTypeSelectionState state;

  OrderTypeSelectionContent(this.bloc, this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Aquí construirías el contenido específico de la selección del tipo de orden
        ],
      ),
    );
  }
}
