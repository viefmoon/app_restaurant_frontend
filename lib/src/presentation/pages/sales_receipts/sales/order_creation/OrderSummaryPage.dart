import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationState.dart';

class OrderSummaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen de la Orden'),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text('Eliminar Orden'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
          // Contenido existente...
          ),
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        // Disparar el evento para reiniciar la orden
        BlocProvider.of<OrderCreationBloc>(context).add(ResetOrder());
        // Opcionalmente, navegar de regreso a la pantalla inicial después de reiniciar
        Navigator.popUntil(context, ModalRoute.withName('salesHome'));
        break;
    }
  }
}
