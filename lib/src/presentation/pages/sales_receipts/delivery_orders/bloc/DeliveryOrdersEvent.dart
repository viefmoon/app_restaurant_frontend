import 'package:app/src/domain/models/Order.dart';
import 'package:equatable/equatable.dart';

abstract class DeliveryOrdersEvent extends Equatable {
  const DeliveryOrdersEvent();

  @override
  List<Object> get props => [];
}

class LoadDeliveryOrders extends DeliveryOrdersEvent {
  const LoadDeliveryOrders();
}

class MarkOrdersAsInDelivery extends DeliveryOrdersEvent {
  final List<Order> orders;

  const MarkOrdersAsInDelivery(this.orders);

  @override
  List<Object> get props => [orders];
}

class MarkOrderAsDelivered extends DeliveryOrdersEvent {
  final Order order;

  const MarkOrderAsDelivered(this.order);

  @override
  List<Object> get props => [order];
}
