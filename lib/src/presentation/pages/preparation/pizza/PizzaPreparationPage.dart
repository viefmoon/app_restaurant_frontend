import 'dart:async';

import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/models/OrderItemSummary.dart';
import 'package:app/src/domain/models/Product.dart';
import 'package:app/src/presentation/pages/preparation/pizza/bloc/PizzaPreparationEvent.dart';
import 'package:app/src/presentation/pages/preparation/pizza/bloc/PizzaPreparationState.dart';
import 'package:app/src/presentation/pages/preparation/pizza/bloc/PizzaPreparationBloc.dart';
import 'package:app/src/presentation/pages/preparation/pizza/home/bloc/PizzaHomeState.dart';
import 'package:app/src/presentation/widgets/OrderPizzaPreparationWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

class PizzaPreparationPage extends StatefulWidget {
  final OrderFilterType filterType;
  final bool filterByPrepared;
  final bool filterByScheduledDelivery; // Nuevo parámetro

  const PizzaPreparationPage(
      {Key? key,
      required this.filterType,
      this.filterByPrepared = false,
      this.filterByScheduledDelivery = false}) // Nuevo parámetro
      : super(key: key);

  @override
  _PizzaPreparationPageState createState() => _PizzaPreparationPageState();
}

class _PizzaPreparationPageState extends State<PizzaPreparationPage> {
  PizzaPreparationBloc? bloc;
  bool _isDialogShown =
      false; // Añade esta variable para rastrear si el diálogo está abierto

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<PizzaPreparationBloc>(context, listen: false);
    // Establece la orientación preferida a horizontal al entrar a la página
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    bloc?.disconnectWebSocket();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  void synchronizeOrders() {
    bloc?.add(SynchronizeOrdersEvent());
  }

  void _handleOrderGesture(Order order, String gesture) {
    final bloc = BlocProvider.of<PizzaPreparationBloc>(context);
    switch (gesture) {
      case 'swipe_left':
        if (order.pizzaPreparationStatus != OrderPreparationStatus.prepared &&
            order.pizzaPreparationStatus !=
                OrderPreparationStatus.in_preparation) {
          bloc.add(UpdateOrderPreparationStatusEvent(
              order.id!,
              OrderPreparationStatus.in_preparation,
              PreparationStatusType.pizzaPreparationStatus));
        }
        break;
      case 'swipe_right':
        if (order.pizzaPreparationStatus != OrderPreparationStatus.prepared &&
            order.pizzaPreparationStatus != OrderPreparationStatus.created) {
          bloc.add(UpdateOrderPreparationStatusEvent(
              order.id!,
              OrderPreparationStatus.created,
              PreparationStatusType.pizzaPreparationStatus));
        }
        break;
      case 'swipe_to_prepared':
        bloc.add(UpdateOrderPreparationStatusEvent(
            order.id!,
            OrderPreparationStatus.prepared,
            PreparationStatusType.pizzaPreparationStatus));
        // Cambia el estado de todos los OrderItems visibles a preparado
        break;
      case 'swipe_to_in_preparation':
        bloc.add(UpdateOrderPreparationStatusEvent(
            order.id!,
            OrderPreparationStatus.in_preparation,
            PreparationStatusType.pizzaPreparationStatus));
        // No cambia el estado de los OrderItems aquí
        break;
    }
  }

  void _handleOrderItemTap(Order order, OrderItem orderItem) {
    Product? product =
        orderItem.product; // Asume que tienes acceso al producto aquí.
    if (order.pizzaPreparationStatus == OrderPreparationStatus.in_preparation &&
        product?.subcategory?.name == "Pizzas") {
      // Verifica si es de la subcategoría "Pizzas"
      final bloc = BlocProvider.of<PizzaPreparationBloc>(context);
      final newStatus = orderItem.status == OrderItemStatus.prepared
          ? OrderItemStatus.in_preparation
          : OrderItemStatus.prepared;
      bloc.add(UpdateOrderItemStatusEvent(
          orderId: order.id!,
          orderItemId: orderItem.id!,
          newStatus: newStatus));
    }
  }

  void _fetchAndShowOrderItemsSummary() {
    final currentState = BlocProvider.of<PizzaPreparationBloc>(context).state;
    if (currentState.orderItemsSummary != null &&
        currentState.orderItemsSummary!.isNotEmpty) {
      // Si ya hay datos disponibles, muestra el diálogo directamente
      _showOrderItemsSummaryDialog(currentState.orderItemsSummary!);
    } else {
      // Si no hay datos, dispara el evento para obtenerlos
      final bloc = BlocProvider.of<PizzaPreparationBloc>(context);
      bloc.add(FetchOrderItemsSummaryEvent());

      StreamSubscription<PizzaPreparationState>? subscription;
      // Escucha solo una vez al Bloc para obtener el nuevo estado con los datos
      subscription = bloc.stream.listen((state) {
        if (state.orderItemsSummary != null &&
            state.orderItemsSummary!.isNotEmpty) {
          _showOrderItemsSummaryDialog(state.orderItemsSummary!);
          subscription?.cancel(); // No olvides cancelar la suscripción
        }
      });
    }
  }

  void _showOrderItemsSummaryDialog(List<OrderItemSummary> summaries) {
    if (!_isDialogShown) {
      _isDialogShown = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // Construcción de tu diálogo...
          return AlertDialog(
            title: Text('Proximos a preparar',
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: ListBody(
                children: summaries
                    .map((summary) => ExpansionTile(
                          title: Text(summary.subcategoryName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22)),
                          children: summary.products
                              .map((product) => ListTile(
                                    title: Text(
                                      product.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    trailing: Text('${product.count}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                  ))
                              .toList(),
                        ))
                    .toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cerrar',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(context).pop();
                  _isDialogShown = false; // Marca que el diálogo se ha cerrado
                },
              ),
            ],
          );
        },
      ).then((_) => _isDialogShown =
          false); // Restablece _isDialogShown cuando el diálogo se cierra
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PizzaPreparationBloc, PizzaPreparationState>(
        builder: (context, state) {
          final orders = state.orders ?? [];
          final filteredOrders = orders.where((order) {
            bool matchesType;
            switch (widget.filterType) {
              case OrderFilterType.delivery:
                matchesType = order.orderType == OrderType.delivery;
                break;
              case OrderFilterType.dineIn:
                matchesType = order.orderType == OrderType.dineIn;
                break;
              case OrderFilterType.pickUpWait:
                matchesType = order.orderType == OrderType.pickUpWait;
                break;
              case OrderFilterType.all:
              default:
                matchesType = true;
                break;
            }

            bool matchesPreparedStatus =
                true; // Inicializa como true para incluir todos los pedidos por defecto.
            if (widget.filterByPrepared) {
              // Si el filtro por preparados está activo, solo incluye los pedidos que están preparados.
              matchesPreparedStatus = order.pizzaPreparationStatus ==
                  OrderPreparationStatus.prepared;
            } else {
              // Si el filtro por preparados está desactivado, excluye los pedidos que están preparados.
              matchesPreparedStatus = order.pizzaPreparationStatus !=
                  OrderPreparationStatus.prepared;
            }

            bool matchesScheduledDelivery = true; // Por defecto, mostrar todos
            if (widget.filterByScheduledDelivery) {
              matchesScheduledDelivery = order.scheduledDeliveryTime == null;
            }

            return matchesType &&
                matchesPreparedStatus &&
                matchesScheduledDelivery;
          }).toList();

          if (filteredOrders.isEmpty) {
            return Center(child: Text('No hay pedidos para mostrar.'));
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              final order = filteredOrders[index];
              if (order.pizzaPreparationStatus !=
                  OrderPreparationStatus.not_required) {
                return OrderPizzaPreparationWidget(
                  order: order,
                  onOrderGesture: _handleOrderGesture,
                  onOrderItemTap: _handleOrderItemTap,
                );
              } else {
                return SizedBox.shrink();
              }
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _fetchAndShowOrderItemsSummary();
            },
            child: Icon(Icons.list),
            heroTag: 'orderItemsSummary',
          ),
          SizedBox(height: 10), // Espacio entre botones
          FloatingActionButton(
            onPressed: () {
              final bloc = BlocProvider.of<PizzaPreparationBloc>(context);
              bloc.add(SynchronizeOrdersEvent());
            },
            child: Icon(Icons.sync),
            heroTag: 'synchronizeOrders',
          ),
        ],
      ),
    );
  }
}
