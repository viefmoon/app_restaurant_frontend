import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/presentation/pages/preparation/burger/bloc/BurgerPreparationBloc.dart';
import 'package:app/src/presentation/pages/preparation/burger/bloc/BurgerPreparationEvent.dart';
import 'package:app/src/presentation/pages/preparation/burger/bloc/BurgerPreparationState.dart';
import 'package:app/src/presentation/pages/preparation/burger/home/bloc/BurgerHomeState.dart';
import 'package:app/src/presentation/widgets/OrderBurgerPreparationWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

class BurgerPreparationPage extends StatefulWidget {
  final OrderFilterType filterType;
  final bool filterByPrepared;
  final bool filterByScheduledDelivery; // Nuevo parámetro

  const BurgerPreparationPage(
      {Key? key,
      required this.filterType,
      this.filterByPrepared = false,
      this.filterByScheduledDelivery = false}) // Nuevo parámetro
      : super(key: key);

  @override
  _BurgerPreparationPageState createState() => _BurgerPreparationPageState();
}

class _BurgerPreparationPageState extends State<BurgerPreparationPage> {
  BurgerPreparationBloc? bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<BurgerPreparationBloc>(context, listen: false);
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
    final bloc = BlocProvider.of<BurgerPreparationBloc>(context);
    switch (gesture) {
      case 'swipe_left':
        bloc.add(UpdateOrderPreparationStatusEvent(
            order.id!,
            OrderPreparationStatus.in_preparation,
            PreparationStatusType.burgerPreparationStatus));
        break;
      case 'swipe_right':
        bloc.add(UpdateOrderPreparationStatusEvent(
            order.id!,
            OrderPreparationStatus.created,
            PreparationStatusType.burgerPreparationStatus));
        // Cambia el estado de todos los OrderItems visibles a creado
        order.orderItems?.forEach((orderItem) {
          bloc.add(UpdateOrderItemStatusEvent(
              orderId: order.id!,
              orderItemId: orderItem.id!,
              newStatus: OrderItemStatus.created));
        });
        break;
      case 'swipe_to_prepared':
        bloc.add(UpdateOrderPreparationStatusEvent(
            order.id!,
            OrderPreparationStatus.prepared,
            PreparationStatusType.burgerPreparationStatus));
        // Cambia el estado de todos los OrderItems visibles a preparado
        order.orderItems?.forEach((orderItem) {
          bloc.add(UpdateOrderItemStatusEvent(
              orderId: order.id!,
              orderItemId: orderItem.id!,
              newStatus: OrderItemStatus.prepared));
        });
        break;
      case 'swipe_to_in_preparation':
        bloc.add(UpdateOrderPreparationStatusEvent(
            order.id!,
            OrderPreparationStatus.in_preparation,
            PreparationStatusType.burgerPreparationStatus));
        // No cambia el estado de los OrderItems aquí
        break;
    }
  }

  void _handleOrderItemTap(Order order, OrderItem orderItem) {
    final bloc = BlocProvider.of<BurgerPreparationBloc>(context);
    // Verifica si el OrderItem ya está preparado
    if (orderItem.status == OrderItemStatus.prepared) {
      // Decide el nuevo estado basado en el estado de la Order
      final newStatus = order.status == OrderStatus.in_preparation
          ? OrderItemStatus.in_preparation
          : OrderItemStatus.created;
      bloc.add(UpdateOrderItemStatusEvent(
          orderId: order.id!,
          orderItemId: orderItem.id!,
          newStatus: newStatus));
    } else {
      // Si el OrderItem no está preparado, procede como antes
      bloc.add(UpdateOrderItemStatusEvent(
          orderId: order.id!,
          orderItemId: orderItem.id!,
          newStatus: OrderItemStatus.prepared));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BurgerPreparationBloc, BurgerPreparationState>(
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
              matchesPreparedStatus = order.burgerPreparationStatus ==
                  OrderPreparationStatus.prepared;
            } else {
              // Si el filtro por preparados está desactivado, excluye los pedidos que están preparados.
              matchesPreparedStatus = order.burgerPreparationStatus !=
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
              return OrderBurgerPreparationWidget(
                order: order,
                onOrderGesture: _handleOrderGesture,
                onOrderItemTap: _handleOrderItemTap,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final bloc = BlocProvider.of<BurgerPreparationBloc>(context);
          bloc.add(SynchronizeOrdersEvent());
        },
        child: Icon(Icons.sync),
      ),
    );
  }
}
