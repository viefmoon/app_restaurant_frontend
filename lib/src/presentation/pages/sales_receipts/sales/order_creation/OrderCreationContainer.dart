import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/OrderSummaryPage.dart'; // Asegúrate de importar OrderSummaryPage
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/OrderTypeSelectionPage.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/PhoneNumberInputPage.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/ProductSelectionPage.dart';
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
        leading: _customBackButton(context),
        title: BlocBuilder<OrderCreationBloc, OrderCreationState>(
          builder: (context, state) {
            // Cambia el título según el paso en el proceso de creación de la orden
            switch (state.step) {
              case OrderCreationStep.orderTypeSelection:
                return Text('Selecciona el tipo de orden',
                    style: TextStyle(fontSize: 26));
              case OrderCreationStep.phoneNumberInput:
                return Text('Ingresa tu número de teléfono',
                    style: TextStyle(fontSize: 26));
              case OrderCreationStep.tableSelection:
                return Text('Selecciona una mesa',
                    style: TextStyle(fontSize: 26));
              case OrderCreationStep.productSelection:
                if (state.selectedOrderType == OrderType.dineIn) {
                  String area = state.selectedAreaName ?? 'N/A';
                  String table = state.selectedTableNumber?.toString() ?? 'N/A';
                  return Text('$area: $table', style: TextStyle(fontSize: 26));
                } else if (state.selectedOrderType == OrderType.delivery) {
                  String phoneNumber = state.phoneNumber ?? 'N/A';
                  return Text('Teléfono: $phoneNumber',
                      style: TextStyle(fontSize: 26));
                }
                break;
              case OrderCreationStep.orderSummary:
                return Text('Resumen de la orden',
                    style: TextStyle(fontSize: 26));
              default:
                // Maneja el caso null y cualquier otro no contemplado
                return Text('Crear orden', style: TextStyle(fontSize: 26));
            }
            // Retorno por defecto para manejar cualquier caso no contemplado
            return Text('Pasan/Esperan', style: TextStyle(fontSize: 26));
          },
        ),
        actions: <Widget>[
          BlocBuilder<OrderCreationBloc, OrderCreationState>(
            builder: (context, state) {
              if (state.step == OrderCreationStep.productSelection) {
                // Solo muestra el botón en el paso de selección de productos
                return IconButton(
                  icon: Icon(Icons.shopping_cart,
                      size: 40), // Tamaño del icono aumentado
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

  Widget _customBackButton(BuildContext context) {
    return BlocBuilder<OrderCreationBloc, OrderCreationState>(
      builder: (context, state) {
        if (state.step == OrderCreationStep.productSelection) {
          return IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => _showExitConfirmationDialog(context),
          );
        }
        // Si no estás en la página de selección de productos, devuelve un SizedBox para no mostrar nada o manejar según sea necesario.
        return SizedBox.shrink();
      },
    );
  }

  Future<void> _showExitConfirmationDialog(BuildContext context) async {
    final bool? shouldPop = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmación'),
        content: Text(
            '¿Estás seguro de que deseas salir? Los cambios no guardados se perderán.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Cierra el diálogo
              Navigator.popUntil(
                  context,
                  ModalRoute.withName(
                      'salesHome')); // Lleva al usuario a salesHome
            },
            child: Text('Salir'),
          ),
        ],
      ),
    );

    if (shouldPop == true) {
      Navigator.popUntil(
          context,
          ModalRoute.withName(
              'salesHome')); // Asegúrate de que esta línea solo se ejecute si el usuario confirma que quiere salir
    }
  }
}
