import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/models/OrderItem.dart';
import 'package:equatable/equatable.dart';

abstract class BarPreparationEvent extends Equatable {
  const BarPreparationEvent();

  @override
  List<Object> get props => [];
}

class ConnectToWebSocket extends BarPreparationEvent {}

class WebSocketMessageReceived extends BarPreparationEvent {
  final String message;

  const WebSocketMessageReceived(this.message);

  @override
  List<Object> get props => [message];
}

class OrderPreparationUpdated extends BarPreparationEvent {
  final dynamic orderUpdate; // Considera usar un tipo más específico

  const OrderPreparationUpdated(this.orderUpdate);

  @override
  List<Object> get props => [orderUpdate];
}

class UpdateOrderStatusEvent extends BarPreparationEvent {
  final int orderId;
  final OrderStatus newStatus;

  const UpdateOrderStatusEvent(this.orderId, this.newStatus);

  @override
  List<Object> get props => [orderId, newStatus];
}

class UpdateOrderItemStatusEvent extends BarPreparationEvent {
  final int orderId;
  final int orderItemId;
  final OrderItemStatus newStatus;

  const UpdateOrderItemStatusEvent(
      {required this.orderId,
      required this.orderItemId,
      required this.newStatus});
}

class SynchronizeOrdersEvent extends BarPreparationEvent {}
