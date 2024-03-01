import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationEvent.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationState.dart';

class OrderTypeSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final OrderCreationBloc bloc = BlocProvider.of<OrderCreationBloc>(context);

    // Estilo personalizado para los botones
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      textStyle: TextStyle(fontSize: 35), // Tamaño de letra más grande
      padding: EdgeInsets.symmetric(
          horizontal: 50,
          vertical: 20), // Padding para hacer el botón más grande
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Bordes rectangulares
      ),
    );

    return Scaffold(
      body: Center(
        // Centrar los botones en la pantalla
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                bloc.add(
                    OrderTypeSelected(selectedOrderType: OrderType.delivery));
                // Navigator.pushNamed(context, 'order/delivery/add_phone_number');
              },
              style: buttonStyle, // Aplicar el estilo personalizado
              child: Text('Para llevar'),
            ),
            SizedBox(height: 20), // Espacio entre botones
            ElevatedButton(
              onPressed: () {
                bloc.add(
                    OrderTypeSelected(selectedOrderType: OrderType.takeout));
                // Navigator.pushNamed(context, 'order/table_selection');
              },
              style: buttonStyle, // Aplicar el estilo personalizado
              child: Text('Pasan/Esperan'),
            ),
            SizedBox(height: 20), // Espacio entre botones
            ElevatedButton(
              onPressed: () {
                bloc.add(
                    OrderTypeSelected(selectedOrderType: OrderType.dineIn));
                // Navigator.pushNamed(context, 'order/create');
              },
              style: buttonStyle, // Aplicar el estilo personalizado
              child: Text('Comer dentro'),
            ),
          ],
        ),
      ),
    );
  }
}
