import 'dart:convert';

import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/presentation/pages/preparation/bar/bloc/BarPreparationEvent.dart';
import 'package:app/src/presentation/pages/preparation/bar/bloc/BarPreparationState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/domain/models/Order.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class BarPreparationBloc
    extends Bloc<BarPreparationEvent, BarPreparationState> {
  final IO.Socket socket;

  BarPreparationBloc({required this.socket}) : super(BarPreparationState()) {
    on<ConnectToWebSocket>(_onConnectToWebSocket);
    on<WebSocketMessageReceived>(_onWebSocketMessageReceived);
    on<OrderPreparationUpdated>(_onOrderPreparationUpdated);

    socket.on('connect', (_) {
      print('Connected');
    });

    socket.on('disconnect', (_) {
      print('Disconnected');
    });

    socket.on('orderItems', (data) {
      final String dataString = json.encode(data);
      add(WebSocketMessageReceived(dataString));
    });
  }

  void _onConnectToWebSocket(
      ConnectToWebSocket event, Emitter<BarPreparationState> emit) {
    socket.connect();
    emit(state.copyWith(isConnected: true));
  }

  void _onWebSocketMessageReceived(
      WebSocketMessageReceived event, Emitter<BarPreparationState> emit) {
    // Convertir el mensaje recibido en una única orden
    final Order order = _parseOrderFromMessage(event.message);
    print(order);

    // Si el estado actual ya tiene órdenes, queremos añadir o actualizar la orden recibida
    List<Order> updatedOrders = [];
    if (state.orders != null) {
      // Verificar si la orden ya existe en la lista para reemplazarla
      bool orderExists = false;
      updatedOrders = state.orders!.map((existingOrder) {
        if (existingOrder.id == order.id) {
          orderExists = true;
          return order; // Reemplazar la orden existente con la nueva
        }
        return existingOrder;
      }).toList();

      // Si la orden no existía previamente, añadirla a la lista
      if (!orderExists) {
        updatedOrders.add(order);
      }
    } else {
      // Si no hay órdenes existentes, simplemente añadir la nueva orden a la lista
      updatedOrders = [order];
    }

    // Emitir el nuevo estado con la lista actualizada de órdenes
    emit(state.copyWith(orders: updatedOrders));
  }

  void _onOrderPreparationUpdated(
      OrderPreparationUpdated event, Emitter<BarPreparationState> emit) {
    // Actualiza una orden específica basada en el evento
    // Esto es un ejemplo, necesitarás ajustar la lógica según tus necesidades
    final updatedOrders = state.orders?.map((order) {
      if (order.id == event.orderUpdate.id) {
        return event.orderUpdate;
      }
      return order;
    }).toList();
    emit(state.copyWith(orders: updatedOrders as List<Order>));
  }

  @override
  Future<void> close() {
    socket.dispose();
    return super.close();
  }

  Order _parseOrderFromMessage(String message) {
    final data = json.decode(message);
    print("data, $data");
    final orderJson = data['order'];
    final orderItemsJson = data['orderItems'] as List<dynamic>;
    // Suponiendo que la clase Order puede tomar un mapa JSON para su inicialización
    // y que tiene un campo o método para actualizar los items específicos
    var order = Order.fromJson(orderJson);
    order.updateItems(orderItemsJson
        .map((orderItemJson) => OrderItem.fromJson(orderItemJson))
        .toList());

    // Devolver la orden basada en los datos recibidos
    return order;
  }
}
