import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_update/OrderUpdatePage.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_update/bloc/OrderUpdateEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_update/bloc/OrderUpdateBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_update/bloc/OrderUpdateState.dart';
import 'package:app/src/domain/utils/Resource.dart';
import 'package:intl/intl.dart';

class OpenOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final OrderUpdateBloc bloc = BlocProvider.of<OrderUpdateBloc>(context);
    bloc.add(LoadOrders());

    return Scaffold(
      appBar: AppBar(
        title: Text('Órdenes Abiertas'),
      ),
      body: BlocBuilder<OrderUpdateBloc, OrderUpdateState>(
        builder: (context, state) {
          if (state.response is Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.orders?.isNotEmpty ?? false) {
            // Utiliza directamente las órdenes del estado
            return ListView.builder(
              itemCount: state.orders?.length ?? 0,
              itemBuilder: (context, index) {
                final order = state.orders![index];
                String title =
                    'ID: ${order.id ?? ""}'; // Asegura que el ID siempre esté presente

                // Formatea la fecha de creación para mostrarla solo hasta los minutos
                String formattedDate = DateFormat('yyyy-MM-dd HH:mm')
                    .format(order.creationDate ?? DateTime.now());
                String subtitle =
                    formattedDate; // Usa la fecha formateada como subtítulo

                // Agrega el tipo de pedido y detalles específicos según el tipo
                switch (order.orderType) {
                  case OrderType.delivery:
                    title += '';
                    title += order.deliveryAddress != null
                        ? ' - ${order.deliveryAddress}'
                        : '';
                    title += order.phoneNumber != null
                        ? ' - Tel: ${order.phoneNumber}'
                        : '';
                    break;
                  case OrderType.dineIn:
                    title += ' - Dentro';
                    if (order.area != null && order.table != null) {
                      title += ' - ${order.area!.name} ${order.table!.number}';
                    }
                    break;
                  case OrderType.pickUpWait:
                    title += ' - Recoger';
                    title += order.customerName != null
                        ? ' - ${order.customerName}'
                        : '';
                    break;
                  default:
                    // Maneja cualquier otro caso o tipo de pedido no especificado
                    break;
                }

                // Traduce el estado del pedido a español y cambia el color según el estado
                String statusText =
                    ' - Estado: ${_translateOrderStatus(order.status)}';
                Color statusColor = _getStatusColor(order.status);

                return ListTile(
                  title: Text(title),
                  subtitle: Text(subtitle + statusText,
                      style: TextStyle(color: statusColor)),
                  onTap: () {
                    // Emitir el evento al BLoC con la orden seleccionada
                    bloc.add(OrderSelectedForUpdate(order));

                    // Navegar a la página de actualización de la orden sin pasar la orden como parámetro
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderUpdatePage(), // Ahora OrderUpdatePage no necesita parámetros
                      ),
                    );
                  },
                  // Agrega más detalles según sea necesario
                );
              },
            );
          } else if (state.response is Error) {
            final errorMessage = (state.response as Error).message;
            return Center(child: Text('Error: $errorMessage'));
          } else {
            return Center(child: Text('No hay órdenes abiertas.'));
          }
        },
      ),
    );
  }

  // Añade esta función dentro de la clase OpenOrdersPage para determinar el color basado en el estado
  Color _getStatusColor(OrderStatus? status) {
    switch (status) {
      case OrderStatus.created:
        return Colors.blue;
      case OrderStatus.in_preparation:
        return Colors.orange;
      case OrderStatus.prepared:
        return Colors.green;
      case OrderStatus.finished:
        return Colors.grey;
      case OrderStatus.canceled:
        return Colors.red;
      default:
        return Colors
            .black; // Color por defecto si el estado es nulo o no reconocido
    }
  }

  // Añade esta función dentro de la clase OpenOrdersPage para traducir el estado a español
  String _translateOrderStatus(OrderStatus? status) {
    switch (status) {
      case OrderStatus.created:
        return 'Creado';
      case OrderStatus.in_preparation:
        return 'En preparación';
      case OrderStatus.prepared:
        return 'Preparado';
      case OrderStatus.finished:
        return 'Finalizado';
      case OrderStatus.canceled:
        return 'Cancelado';
      default:
        return 'Desconocido'; // Texto por defecto si el estado es nulo o no reconocido
    }
  }
}
