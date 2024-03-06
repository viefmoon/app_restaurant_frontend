import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/OrderSummaryPage.dart'; // Asegúrate de importar OrderSummaryPage
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/OrderTypeSelectionPage.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/PhoneNumberInputPage.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/ProducSelectionPage.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/TableSelectionPage.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderCreationContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<OrderCreationBloc, OrderCreationState>(
          builder: (context, state) {
            // Cambia el título según el paso en el proceso de creación de la orden
            switch (state.step) {
              case OrderCreationStep.orderTypeSelection:
                return Text('Selecciona el tipo de orden');
              case OrderCreationStep.phoneNumberInput:
                return Text('Ingresa tu número de teléfono');
              case OrderCreationStep.tableSelection:
                return Text('Selecciona una mesa');
              case OrderCreationStep.productSelection:
                if (state.selectedOrderType == OrderType.dineIn) {
                  String area = state.selectedAreaName ?? 'N/A';
                  String table = state.selectedTableNumber?.toString() ?? 'N/A';
                  return Text('$area: $table');
                } else if (state.selectedOrderType == OrderType.delivery) {
                  String phoneNumber = state.phoneNumber ?? 'N/A';
                  return Text('Teléfono: $phoneNumber');
                }
                break;
              case OrderCreationStep.orderSummary:
                return Text('Resumen de la orden');
              default:
                // Maneja el caso null y cualquier otro no contemplado
                return Text('Selecciona el tipo de orden');
            }
            // Retorno por defecto para manejar cualquier caso no contemplado
            return Text('Selecciona el tipo de orden');
          },
        ),
        actions: <Widget>[
          BlocBuilder<OrderCreationBloc, OrderCreationState>(
            builder: (context, state) {
              if (state.step == OrderCreationStep.productSelection) {
                // Solo muestra el botón en el paso de selección de productos
                return IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderSummaryPage()),
                    );
                  },
                );
              } else {
                return Container(); // No muestra ningún botón en otros pasos
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<OrderCreationBloc, OrderCreationState>(
        builder: (context, state) {
          // Lógica para mostrar el contenido basado en el estado actual, como antes
          switch (state.step) {
            case OrderCreationStep.orderTypeSelection:
              return OrderTypeSelectionPage();
            case OrderCreationStep.phoneNumberInput:
              return PhoneNumberInputPage();
            case OrderCreationStep.tableSelection:
              return TableSelectionPage();
            case OrderCreationStep.productSelection:
              return ProductSelectionPage();
            case OrderCreationStep.orderSummary:
              return OrderSummaryPage();
            default:
              return OrderTypeSelectionPage();
          }
        },
      ),
    );
  }
}
