import 'package:flutter/material.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/OrderCreationContainer.dart';

class SalesOptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // Navega a OrderCreationContainer
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OrderCreationContainer()),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 70, vertical: 20),
            ),
            child: Text('Crear orden', style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 20), // Espacio entre botones
          ElevatedButton(
            onPressed: () {
              // Acción para "Órdenes abiertas" aún no definida
              // Navigator.pushNamed(context, 'ruta_a_definir');
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 70, vertical: 20),
            ),
            child: Text('Órdenes abiertas', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
