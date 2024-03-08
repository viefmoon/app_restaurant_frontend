import 'package:app/src/domain/models/Area.dart';
import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/models/Table.dart' as appModel;
import 'package:app/src/domain/useCases/areas/AreasUseCases.dart';
import 'package:app/src/domain/useCases/orders/OrdersUseCases.dart';
import 'package:app/src/domain/utils/Resource.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_update/bloc/OrderUpdateEvent.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_update/bloc/OrderUpdateState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderUpdateBloc extends Bloc<OrderUpdateEvent, OrderUpdateState> {
  final OrdersUseCases ordersUseCases;
  final AreasUseCases areasUseCases;

  OrderUpdateBloc({required this.ordersUseCases, required this.areasUseCases})
      : super(OrderUpdateState()) {
    on<LoadOrders>(_onLoadOrders);
    on<OrderTypeSelected>(_onOrderTypeSelected);
    on<PhoneNumberEntered>(_onPhoneNumberEntered);
    on<DeliveryAddressEntered>(_onDeliveryAddressEntered);
    on<CustomerNameEntered>(_onCustomerNameEntered);
    on<OrderCommentsEntered>(_onOrderCommentsEntered);
    on<TimeSelected>(_onTimeSelected);
    on<LoadAreas>(_onLoadAreas);
    on<LoadTables>(_onLoadTables);
    on<AreaSelected>(_onAreaSelected);
    on<TableSelected>(_onTableSelected);
    on<OrderSelectedForUpdate>(_onOrderSelectedForUpdate);
    on<ResetOrderUpdateState>(_onResetOrderUpdateState);
  }

  Future<void> _onResetOrderUpdateState(
      ResetOrderUpdateState event, Emitter<OrderUpdateState> emit) async {
    emit(state.copyWith(
      orderIdSelectedForUpdate: null,
      selectedOrderType: null,
      areas: [],
      tables: [],
      selectedAreaId: null,
      selectedAreaName: null,
      selectedTableId: null,
      selectedTableNumber: null,
      phoneNumber: null,
      deliveryAddress: null,
      customerName: null,
      comments: null,
      scheduledDeliveryTime: null,
      totalCost: null,
      orderItems: [],
      errorMessage: null,
      response: null,
    ));
  }

  Future<void> _onLoadOrders(
      LoadOrders event, Emitter<OrderUpdateState> emit) async {
    emit(state.copyWith(response: Loading()));
    try {
      Resource response = await ordersUseCases.getOpenOrders.run();
      if (response is Success<List<Order>>) {
        List<Order> orders = response.data;
        print(orders);
        emit(state.copyWith(orders: orders, response: Success(orders)));
      } else {
        emit(state.copyWith(orders: [], response: response));
      }
    } catch (e) {
      emit(state.copyWith(orders: [], response: Error(e.toString())));
    }
  }

  Future<void> _onOrderTypeSelected(
      OrderTypeSelected event, Emitter<OrderUpdateState> emit) async {
    emit(state.copyWith(selectedOrderType: event.selectedOrderType));
  }

  Future<void> _onOrderSelectedForUpdate(
      OrderSelectedForUpdate event, Emitter<OrderUpdateState> emit) async {
    await _onLoadAreas(LoadAreas(), emit);
    emit(state.copyWith(
      orderIdSelectedForUpdate: event.order.id,
      selectedOrderType: event.order.orderType,
      selectedAreaId: event.order.area?.id,
      selectedTableId: event.order.table?.id,
      phoneNumber: event.order.phoneNumber,
      deliveryAddress: event.order.deliveryAddress,
      customerName: event.order.customerName,
      scheduledDeliveryTime: event.order.scheduledDeliveryTime != null
          ? TimeOfDay(
              hour: event.order.scheduledDeliveryTime!.hour,
              minute: event.order.scheduledDeliveryTime!.minute)
          : null,
      comments: event.order.comments,
      totalCost: event.order.totalCost,
      orderItems: event.order.orderItems,
      // Aquí puedes copiar otros campos relevantes de la orden al estado, si es necesario
    ));
    print(
        'Orden seleccionada para actualizar: ${event.order.scheduledDeliveryTime?.hour}:${event.order.scheduledDeliveryTime?.minute}');
  }

  Future<void> _onPhoneNumberEntered(
      PhoneNumberEntered event, Emitter<OrderUpdateState> emit) async {
    emit(state.copyWith(phoneNumber: event.phoneNumber));
  }

  Future<void> _onDeliveryAddressEntered(
      DeliveryAddressEntered event, Emitter<OrderUpdateState> emit) async {
    emit(state.copyWith(deliveryAddress: event.deliveryAddress));
  }

  Future<void> _onCustomerNameEntered(
      CustomerNameEntered event, Emitter<OrderUpdateState> emit) async {
    emit(state.copyWith(customerName: event.customerName));
  }

  Future<void> _onOrderCommentsEntered(
      OrderCommentsEntered event, Emitter<OrderUpdateState> emit) async {
    emit(state.copyWith(comments: event.comments));
  }

  Future<void> _onTimeSelected(
      TimeSelected event, Emitter<OrderUpdateState> emit) async {
    emit(state.copyWith(scheduledDeliveryTime: event.time));
  }

  Future<void> _onAreaSelected(
      AreaSelected event, Emitter<OrderUpdateState> emit) async {
    emit(state.copyWith(selectedAreaId: event.areaId));
    final areaName =
        state.areas?.firstWhere((area) => area.id == event.areaId).name;
    emit(state.copyWith(selectedAreaName: areaName));
    add(LoadTables(areaId: event.areaId));
  }

  Future<void> _onTableSelected(
      TableSelected event, Emitter<OrderUpdateState> emit) async {
    emit(state.copyWith(selectedTableId: event.tableId));
    final tableNumber =
        state.tables?.firstWhere((table) => table.id == event.tableId).number;
    emit(state.copyWith(selectedTableNumber: tableNumber));
  }

  Future<void> _onLoadAreas(
      LoadAreas event, Emitter<OrderUpdateState> emit) async {
    emit(state.copyWith(response: Loading()));
    try {
      Resource response = await areasUseCases.getAreas.run();
      if (response is Success<List<Area>>) {
        List<Area> areas = response.data;
        emit(state.copyWith(areas: areas, response: Success(areas)));
      } else {
        emit(state.copyWith(areas: [], response: response));
      }
    } catch (e) {
      emit(state.copyWith(areas: [], response: Error(e.toString())));
    }
  }

  Future<void> _onLoadTables(
      LoadTables event, Emitter<OrderUpdateState> emit) async {
    emit(state.copyWith(response: Loading()));
    try {
      Resource response =
          await areasUseCases.getTablesFromArea.run(event.areaId);
      if (response is Success<List<appModel.Table>>) {
        List<appModel.Table> tables = response.data;
        emit(state.copyWith(tables: tables, response: Success(tables)));
      } else {
        emit(state.copyWith(tables: [], response: response));
      }
    } catch (e) {
      emit(state.copyWith(tables: [], response: Error(e.toString())));
    }
  }
}
