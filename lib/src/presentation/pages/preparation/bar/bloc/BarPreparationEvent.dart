import 'package:app/src/presentation/pages/preparation/bar/bloc/BarPreparationState.dart';
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
