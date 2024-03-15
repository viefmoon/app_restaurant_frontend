import 'package:equatable/equatable.dart';
import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/models/OrderItem.dart';

enum OrderFilter { all, delivery, dineIn, pickUpWait }

class BarPreparationState extends Equatable {
  final bool isConnected;
  final List<Order>? orders;
  final Order? updatedOrder;
  final String? errorMessage;

  const BarPreparationState({
    this.isConnected = false,
    this.orders,
    this.updatedOrder,
    this.errorMessage,
  });

  BarPreparationState copyWith({
    bool? isConnected,
    List<Order>? orders,
    Order? updatedOrder,
    String? errorMessage,
    OrderFilter? filter,
  }) {
    return BarPreparationState(
      isConnected: isConnected ?? this.isConnected,
      orders: orders ?? this.orders,
      updatedOrder: updatedOrder ?? this.updatedOrder,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isConnected, orders, updatedOrder, errorMessage];
}
