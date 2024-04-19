import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/utils/Resource.dart';
import 'package:app/src/presentation/pages/sales_receipts/delivery_orders/bloc/DeliveryOrdersBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/delivery_orders/bloc/DeliveryOrdersEvent.dart';
import 'package:app/src/presentation/pages/sales_receipts/delivery_orders/bloc/DeliveryOrdersState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryOrdersPage extends StatefulWidget {
  @override
  _DeliveryOrdersPageState createState() => _DeliveryOrdersPageState();
}

class _DeliveryOrdersPageState extends State<DeliveryOrdersPage> {
  List<Order> selectedOrders = [];

  @override
  void initState() {
    super.initState();
    final DeliveryOrdersBloc bloc =
        BlocProvider.of<DeliveryOrdersBloc>(context, listen: false);
    bloc.add(LoadDeliveryOrders());
  }

  double getTotalCostOfSelectedOrders() {
    return selectedOrders.fold(
        0.0, (sum, order) => sum + (order.totalCost ?? 0.0));
  }

  @override
  Widget build(BuildContext context) {
    final DeliveryOrdersBloc bloc =
        BlocProvider.of<DeliveryOrdersBloc>(context);
    double totalCost = getTotalCostOfSelectedOrders();

    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos para Llevar'),
        actions: <Widget>[
          if (selectedOrders.isNotEmpty)
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                // Asegurarse de enviar las órdenes seleccionadas antes de limpiar la lista
                bloc.add(MarkOrdersAsInDelivery(List.from(selectedOrders)));
                setState(() {
                  selectedOrders.clear();
                });
              },
            ),
          if (selectedOrders.isNotEmpty &&
              selectedOrders
                  .any((order) => order.status == OrderStatus.in_delivery))
            IconButton(
              icon: Icon(Icons.check_circle),
              onPressed: () {
                // Marcar la primera orden seleccionada como entregada
                bloc.add(MarkOrderAsDelivered(selectedOrders.firstWhere(
                    (order) => order.status == OrderStatus.in_delivery)));
                setState(() {
                  selectedOrders.removeWhere(
                      (order) => order.status == OrderStatus.in_delivery);
                });
              },
            ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: Text(
                'Total: \$${totalCost.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<DeliveryOrdersBloc, DeliveryOrdersState>(
        builder: (context, state) {
          if (state.response is Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.orders?.isNotEmpty ?? false) {
            return ListView.builder(
              itemCount: state.orders!.length,
              itemBuilder: (context, index) {
                final order = state.orders![index];
                String statusText;
                Color textColor;
                switch (order.status) {
                  case OrderStatus.prepared:
                    statusText = 'Preparado';
                    textColor = Colors.green;
                    break;
                  case OrderStatus.in_delivery:
                    statusText = 'En reparto';
                    textColor = Colors.blue;
                    break;
                  default:
                    statusText = 'Desconocido';
                    textColor = Colors.grey;
                }
                return CheckboxListTile(
                  title: Text(
                    '#${order.id} - ${order.deliveryAddress}, Tel: ${order.phoneNumber}',
                    style: TextStyle(color: textColor),
                  ),
                  subtitle: Text(
                    'Total: \$${order.totalCost?.toStringAsFixed(2) ?? ''} - Estado: $statusText',
                    style: TextStyle(color: textColor),
                  ),
                  value: selectedOrders.contains(order),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value ?? false) {
                        selectedOrders.add(order);
                      } else {
                        selectedOrders.remove(order);
                      }
                      getTotalCostOfSelectedOrders();
                    });
                  },
                  activeColor: Colors.green,
                  checkColor: Colors.blue,
                );
              },
            );
          } else if (state.response is Error) {
            final errorMessage = (state.response as Error).message;
            return Center(child: Text('Error: $errorMessage'));
          } else {
            return Center(
                child: Text('No hay pedidos para llevar listos para entrega.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bloc.add(LoadDeliveryOrders());
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
