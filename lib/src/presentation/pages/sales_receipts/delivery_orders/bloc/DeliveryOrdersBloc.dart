import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/useCases/orders/OrdersUseCases.dart';
import 'package:app/src/domain/utils/Resource.dart';
import 'package:app/src/presentation/pages/sales_receipts/delivery_orders/bloc/DeliveryOrdersEvent.dart';
import 'package:app/src/presentation/pages/sales_receipts/delivery_orders/bloc/DeliveryOrdersState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryOrdersBloc
    extends Bloc<DeliveryOrdersEvent, DeliveryOrdersState> {
  final OrdersUseCases ordersUseCases;

  DeliveryOrdersBloc({required this.ordersUseCases})
      : super(DeliveryOrdersState()) {
    on<LoadDeliveryOrders>(_onLoadDeliveryOrders);
    on<MarkOrdersAsInDelivery>(_onMarkOrdersAsInDelivery);
    on<MarkOrderAsDelivered>(_onMarkOrderAsDelivered);
  }

  Future<void> _onLoadDeliveryOrders(
      LoadDeliveryOrders event, Emitter<DeliveryOrdersState> emit) async {
    emit(state.copyWith(response: Loading()));
    Resource<List<Order>> response =
        await ordersUseCases.getDeliveryOrders.run();
    if (response is Success<List<Order>>) {
      List<Order> orders = response.data;
      emit(state.copyWith(orders: orders, response: Initial()));
    } else {
      emit(state.copyWith(orders: [], response: Initial()));
    }
  }

  Future<void> _onMarkOrdersAsInDelivery(
      MarkOrdersAsInDelivery event, Emitter<DeliveryOrdersState> emit) async {
    emit(state.copyWith(response: Loading()));
    await ordersUseCases.markOrdersAsInDelivery.run(event.orders);
    Resource<List<Order>> response =
        await ordersUseCases.getDeliveryOrders.run();
    if (response is Success<List<Order>>) {
      List<Order> orders = response.data;
      emit(state.copyWith(orders: orders, response: Initial()));
    } else {
      emit(state.copyWith(orders: [], response: Initial()));
    }
  }

  Future<void> _onMarkOrderAsDelivered(
      MarkOrderAsDelivered event, Emitter<DeliveryOrdersState> emit) async {
    emit(state.copyWith(response: Loading()));
    await ordersUseCases.completeOrder.run(event.order.id!);
    Resource<List<Order>> response =
        await ordersUseCases.getDeliveryOrders.run();
    if (response is Success<List<Order>>) {
      List<Order> orders = response.data;
      emit(state.copyWith(orders: orders, response: Initial()));
    } else {
      emit(state.copyWith(orders: [], response: Initial()));
    }
  }
}
