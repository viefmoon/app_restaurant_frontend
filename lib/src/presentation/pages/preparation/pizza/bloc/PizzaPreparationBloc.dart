import 'dart:convert';
import 'package:app/src/data/api/ApiConfig.dart';
import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/models/OrderItemSummary.dart';
import 'package:app/src/domain/useCases/orders/OrdersUseCases.dart';
import 'package:app/src/domain/utils/Resource.dart';
import 'package:app/src/presentation/pages/preparation/pizza/bloc/PizzaPreparationEvent.dart';
import 'package:app/src/presentation/pages/preparation/pizza/bloc/PizzaPreparationState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/domain/models/Order.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PizzaPreparationBloc
    extends Bloc<PizzaPreparationEvent, PizzaPreparationState> {
  final OrdersUseCases orderUseCases;
  IO.Socket? socket;

  PizzaPreparationBloc({required this.orderUseCases})
      : super(PizzaPreparationState.initial()) {
    initialize();
  }

  Future<void> initialize() async {
    print('initialize');
    final ip = await ApiConfig.getApiEcommerce();
    print('ip: $ip');
    socket = IO.io('http://$ip', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'query': {'screenType': 'pizzaScreen'}
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
    socket?.on('newOrderItems', _handleSocketData);
    socket?.on('orderUpdated', _handleSocketData);
  }

  void _handleSocketData(data) {
    final String dataString = json.encode(data);
    add(WebSocketMessageReceived(dataString));
  }

  void _registerEventHandlers() {
    on<ConnectToWebSocket>(_onConnectToWebSocket);
    on<WebSocketMessageReceived>(_onWebSocketMessageReceived);
    on<OrderPreparationUpdated>(_onOrderPreparationUpdated);
    on<UpdateOrderPreparationStatusEvent>(_onUpdateOrderPreparationStatusEvent);
    on<UpdateOrderItemStatusEvent>(_onUpdateOrderItemStatusEvent);
    on<SynchronizeOrdersEvent>(_onSynchronizeOrdersEvent);
    on<FetchOrderItemsSummaryEvent>(
        _onFetchOrderItemsSummaryEvent); // Nuevo manejador
  }

  void _onConnectToWebSocket(
      ConnectToWebSocket event, Emitter<PizzaPreparationState> emit) {
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
      WebSocketMessageReceived event, Emitter<PizzaPreparationState> emit) {
    final data = json.decode(event.message);
    print('data: $data');
    final messageType = data['messageType'];

    switch (messageType) {
      case 'orderItemStatusUpdated':
        _handleOrderItemStatusUpdate(data, emit);
        break;
      case 'orderStatusUpdated':
        _handleOrderStatusUpdate(data, emit);
        break;
      case 'newOrderItems':
        _handleNewOrder(data, emit);
        break;
      case 'pendingOrderItems':
        _handleNewOrder(data, emit);
        break;
      case 'orderUpdated':
        _handleNewOrder(data, emit);
        break;
      default:
        print('Tipo de mensaje desconocido: $messageType');
    }
  }

  void _handleOrderStatusUpdate(
      Map<String, dynamic> data, Emitter<PizzaPreparationState> emit) {
    final orderId = data['orderId'];
    final newStatus = _parseOrderStatus(data['pizzaPreparationStatus']);
    bool orderExists = false;
    final updatedOrders = state.orders?.map((existingOrder) {
      if (existingOrder.id == orderId) {
        orderExists = true;
        final updatedOrderItems = existingOrder.orderItems?.map((existingItem) {
          final updateInfo = data['orderItems'].firstWhere(
              (item) => item['id'] == existingItem.id,
              orElse: () => null);
          return updateInfo != null
              ? existingItem.copyWith(
                  status: _parseOrderItemStatus(updateInfo['status']))
              : existingItem;
        }).toList();
        return existingOrder.copyWith(
            pizzaPreparationStatus: newStatus, orderItems: updatedOrderItems);
      }
      return existingOrder;
    }).toList();

    if (orderExists && updatedOrders != null) {
      emit(state.copyWith(orders: updatedOrders));
    }
  }

  void _handleOrderItemStatusUpdate(
      Map<String, dynamic> data, Emitter<PizzaPreparationState> emit) {
    final orderId = data['orderId'];
    final orderItemId = data['orderItemId'];
    final newStatus = _parseOrderItemStatus(data['status']);

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
      Map<String, dynamic> data, Emitter<PizzaPreparationState> emit) {
    final order = _parseOrderFromMessage(data);
    List<Order> updatedOrders = List<Order>.from(state.orders ?? []);
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
      OrderPreparationUpdated event, Emitter<PizzaPreparationState> emit) {
    final updatedOrders = state.orders
        ?.map((order) =>
            order.id == event.orderUpdate.id ? event.orderUpdate : order)
        .toList();
    emit(state.copyWith(orders: updatedOrders as List<Order>));
  }

  Future<void> _onUpdateOrderPreparationStatusEvent(
      UpdateOrderPreparationStatusEvent event,
      Emitter<PizzaPreparationState> emit) async {
    try {
      Order orderToUpdate = Order(
        id: event.orderId,
        pizzaPreparationStatus: event.newStatus,
      );

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
      SynchronizeOrdersEvent event, Emitter<PizzaPreparationState> emit) async {
    try {
      final orders = await orderUseCases.synchronizeData.run();
      emit(state.copyWith(orders: orders));
    } catch (e) {
      emit(
          state.copyWith(errorMessage: "Error al sincronizar los pedidos: $e"));
    }
  }

  Future<void> _onFetchOrderItemsSummaryEvent(
    FetchOrderItemsSummaryEvent event,
    Emitter<PizzaPreparationState> emit,
  ) async {
    print("fetching summary");
    try {
      // Asegúrate de que el tipo de retorno aquí sea correcto, es decir, Resource<List<OrderItemSummary>>
      final Resource<List<OrderItemSummary>> result =
          await orderUseCases.findOrderItemsWithCounts.run(
        subcategories: ["Entradas", "Pizzas"],
        ordersLimit: 10,
      );

      // Manejo basado en el tipo de resultado (éxito o error)
      if (result is Success<List<OrderItemSummary>>) {
        // Aquí manejas el caso de éxito
        List<OrderItemSummary> summaries = result.data;
        // Emites un estado con la lista de resmenes obtenida
        print("Resmenes de OrderItems por Preparar: $summaries");
        emit(state.copyWith(orderItemsSummary: summaries));
      } else if (result is Error) {
        // Aquí manejas el caso de error
        //emit(state.copyWith(errorMessage: result.message));
      }
    } catch (e) {
      // Manejo de errores inesperados
      emit(state.copyWith(
          errorMessage: "Error al obtener el resumen de OrderItems: $e"));
    }
  }

  void _onUpdateOrderItemStatusEvent(UpdateOrderItemStatusEvent event,
      Emitter<PizzaPreparationState> emit) async {
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

  OrderPreparationStatus _parseOrderStatus(String status) {
    return OrderPreparationStatus.values.firstWhere(
      (e) => e.toString().split(".").last == status,
      orElse: () => OrderPreparationStatus.not_required, // Valor por defecto
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
