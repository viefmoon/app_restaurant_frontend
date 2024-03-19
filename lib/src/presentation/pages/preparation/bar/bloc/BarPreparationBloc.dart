import 'dart:convert';
import 'package:app/src/data/api/ApiConfig.dart';
import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/useCases/orders/OrdersUseCases.dart';
import 'package:app/src/domain/utils/Resource.dart';
import 'package:app/src/presentation/pages/preparation/bar/bloc/BarPreparationEvent.dart';
import 'package:app/src/presentation/pages/preparation/bar/bloc/BarPreparationState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/domain/models/Order.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class BarPreparationBloc
    extends Bloc<BarPreparationEvent, BarPreparationState> {
  final OrdersUseCases orderUseCases;
  IO.Socket? socket;

  BarPreparationBloc({required this.orderUseCases})
      : super(BarPreparationState.initial()) {
    initialize();
  }

  Future<void> initialize() async {
    print('initialize');
    final ip = await ApiConfig.getApiEcommerce();
    print('ip: $ip');
    socket = IO.io('http://$ip', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'query': {'screenType': 'barScreen'}
    });

    _connectToWebSocket();
    _registerSocketEvents();
    _registerEventHandlers();
  }

  void _connectToWebSocket() {
    socket?.connect();
  }

  void _registerSocketEvents() {
    socket?.on('connect', (_) => print('Connected'));
    socket?.on('disconnect', (_) => print('Disconnected'));
    socket?.on('pendingOrderItems', _handleSocketData);
    socket?.on('orderStatusUpdated', _handleSocketData);
    socket?.on('orderItemStatusUpdated', _handleSocketData);
  }

  void _handleSocketData(data) {
    final String dataString = json.encode(data);
    add(WebSocketMessageReceived(dataString));
  }

  void _registerEventHandlers() {
    on<ConnectToWebSocket>(_onConnectToWebSocket);
    on<WebSocketMessageReceived>(_onWebSocketMessageReceived);
    on<OrderPreparationUpdated>(_onOrderPreparationUpdated);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatusEvent);
    on<UpdateOrderItemStatusEvent>(_onUpdateOrderItemStatusEvent);
    on<SynchronizeOrdersEvent>(_onSynchronizeOrdersEvent);
  }

  void _onConnectToWebSocket(
      ConnectToWebSocket event, Emitter<BarPreparationState> emit) {
    socket?.connect();
    emit(state.copyWith(isConnected: true));
  }

  void disconnectWebSocket() {
    print('disconnect');
    print('socket: $socket');
    if (socket?.connected ?? false) {
      socket?.disconnect();
      print('WebSocket Disconnected');
    }
  }

  void _onWebSocketMessageReceived(
      WebSocketMessageReceived event, Emitter<BarPreparationState> emit) {
    final data = json.decode(event.message);
    print('data: $data');
    // Verifica si es una actualización de estado de un ítem de orden
    if (data.containsKey('orderId') &&
        data.containsKey('orderItemId') &&
        data.containsKey('status')) {
      _handleOrderItemStatusUpdate(data, emit);
    } else if (data.containsKey('orderId') && data.containsKey('status')) {
      // Verifica si es una actualización de estado de una orden
      _handleOrderStatusUpdate(data, emit);
    } else {
      // Maneja la recepción de una nueva orden
      _handleNewOrder(data, emit);
    }
  }

  void _handleOrderStatusUpdate(
      Map<String, dynamic> data, Emitter<BarPreparationState> emit) {
    final orderId = data['orderId'];
    final newStatus = _parseOrderStatus(data['status']);
    bool orderExists = false;
    final updatedOrders = state.orders?.map((existingOrder) {
      if (existingOrder.id == orderId) {
        orderExists = true;
        return existingOrder.copyWith(status: newStatus);
      }
      return existingOrder;
    }).toList();

    if (orderExists && updatedOrders != null) {
      emit(state.copyWith(orders: updatedOrders));
    }
  }

  void _handleOrderItemStatusUpdate(
      Map<String, dynamic> data, Emitter<BarPreparationState> emit) {
    final orderId = data['orderId'];
    final orderItemId = data['orderItemId'];
    final newStatus = _parseOrderItemStatus(
        data['status']); // Asegúrate de tener esta función implementada

    bool orderItemUpdated = false;
    final updatedOrders = state.orders?.map((existingOrder) {
      if (existingOrder.id == orderId) {
        final updatedOrderItems = existingOrder.orderItems?.map((existingItem) {
              if (existingItem.id == orderItemId) {
                orderItemUpdated = true;
                return existingItem.copyWith(status: newStatus);
              }
              return existingItem;
            }).toList() ??
            [];
        return existingOrder.copyWith(orderItems: updatedOrderItems);
      }
      return existingOrder;
    }).toList();

    if (orderItemUpdated && updatedOrders != null) {
      emit(state.copyWith(orders: updatedOrders));
    }
  }

  void _handleNewOrder(
      Map<String, dynamic> data, Emitter<BarPreparationState> emit) {
    final order = _parseOrderFromMessage(data);
    List<Order> updatedOrders = state.orders ?? [];
    bool orderExists =
        updatedOrders.any((existingOrder) => existingOrder.id == order.id);

    if (!orderExists) {
      updatedOrders.add(order);
    } else {
      updatedOrders = updatedOrders
          .map((existingOrder) =>
              existingOrder.id == order.id ? order : existingOrder)
          .toList();
    }

    emit(state.copyWith(orders: updatedOrders));
  }

  void _onOrderPreparationUpdated(
      OrderPreparationUpdated event, Emitter<BarPreparationState> emit) {
    final updatedOrders = state.orders
        ?.map((order) =>
            order.id == event.orderUpdate.id ? event.orderUpdate : order)
        .toList();
    emit(state.copyWith(orders: updatedOrders as List<Order>));
  }

  Future<void> _onUpdateOrderStatusEvent(
      UpdateOrderStatusEvent event, Emitter<BarPreparationState> emit) async {
    try {
      final orderToUpdate = Order(id: event.orderId, status: event.newStatus);
      final result = await orderUseCases.updateOrderStatus.run(orderToUpdate);
      if (result is Success<Order>) {
        // Opcional: Emitir un estado de éxito
      } else {
        // Opcional: Manejo de casos de fallo
      }
    } catch (e) {
      emit(state.copyWith(
          errorMessage: "Error actualizando el estado de la orden: $e"));
    }
  }

  Future<void> _onSynchronizeOrdersEvent(
      SynchronizeOrdersEvent event, Emitter<BarPreparationState> emit) async {
    try {
      // Aquí va tu lógica para solicitar los pedidos al servidor
      // Por ejemplo, una llamada a una función que obtiene los pedidos desde una API REST
      final orders = await orderUseCases.synchronizeData.run();
      emit(state.copyWith(orders: orders));
    } catch (e) {
      // Manejo de errores
      emit(
          state.copyWith(errorMessage: "Error al sincronizar los pedidos: $e"));
    }
  }

  void _onUpdateOrderItemStatusEvent(UpdateOrderItemStatusEvent event,
      Emitter<BarPreparationState> emit) async {
    try {
      final orderItemToUpdate = OrderItem(
          id: event.orderItemId,
          order: Order(id: event.orderId),
          status: event.newStatus);
      final result =
          await orderUseCases.updateOrderItemStatus.run(orderItemToUpdate);
      if (result is Success<OrderItem>) {
        // Opcional: Emitir un estado de éxito
      } else {
        // Opcional: Manejo de casos de fallo
      }
    } catch (e) {
      emit(state.copyWith(
          errorMessage:
              "Error actualizando el estado del item de la orden: $e"));
    }
  }

  OrderStatus _parseOrderStatus(String status) {
    return OrderStatus.values.firstWhere(
      (e) => e.toString().split(".").last == status,
      orElse: () => OrderStatus.created, // Valor por defecto
    );
  }

  OrderItemStatus _parseOrderItemStatus(String status) {
    return OrderItemStatus.values.firstWhere(
      (e) => e.toString().split(".").last == status,
      orElse: () => OrderItemStatus.created, // Valor por defecto
    );
  }

  Order _parseOrderFromMessage(Map<String, dynamic> data) {
    final orderJson = data['order'];
    final orderItemsJson = data['orderItems'] as List<dynamic>;
    var order = Order.fromJson(orderJson);
    order.updateItems(orderItemsJson
        .map((orderItemJson) => OrderItem.fromJson(orderItemJson))
        .toList());
    return order;
  }
}
