import 'package:app/src/domain/models/Area.dart';
import 'package:app/src/domain/models/Category.dart';
import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/models/Subcategory.dart';
import 'package:app/src/domain/models/Table.dart' as appModel;
import 'package:app/src/domain/useCases/areas/AreasUseCases.dart';
import 'package:app/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:app/src/domain/useCases/categories/CategoriesUseCases.dart';
import 'package:app/src/domain/useCases/orders/OrdersUseCases.dart';
import 'package:app/src/domain/utils/Resource.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_update/bloc/OrderUpdateEvent.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_update/bloc/OrderUpdateState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

class OrderUpdateBloc extends Bloc<OrderUpdateEvent, OrderUpdateState> {
  final OrdersUseCases ordersUseCases;
  final AreasUseCases areasUseCases;
  final CategoriesUseCases categoriesUseCases;
  final AuthUseCases authUseCases;

  OrderUpdateBloc({
    required this.ordersUseCases,
    required this.areasUseCases,
    required this.categoriesUseCases,
    required this.authUseCases,
  }) : super(OrderUpdateState()) {
    on<LoadOpenOrders>(_onLoadOpenOrders);
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
    on<AddOrderItem>(_onAddOrderItem);
    on<UpdateOrderItem>(_onUpdateOrderItem);
    on<OrderSelectedForUpdate>(_onOrderSelectedForUpdate);
    on<ResetOrderUpdateState>(_onResetOrderUpdateState);
    on<RemoveOrderItem>(_onRemoveOrderItem);
    on<LoadCategoriesWithProducts>(_onLoadCategoriesWithProducts);
    on<CategorySelected>(_onCategorySelected);
    on<SubcategorySelected>(_onSubcategorySelected);
    on<UpdateOrder>(_onUpdateOrder);
    on<TimePickerEnabled>(_onTimePickerEnabled);
  }

  Future<void> _onResetOrderUpdateState(
      ResetOrderUpdateState event, Emitter<OrderUpdateState> emit) async {
    emit(state.copyWith(
      orders: [],
      orderIdSelectedForUpdate: null,
      selectedOrderType: null,
      areas: [],
      tables: [],
      selectedAreaId: null,
      selectedAreaName: "",
      selectedTableId: null,
      selectedTableNumber: null,
      phoneNumber: "",
      deliveryAddress: "",
      customerName: "",
      comments: "",
      scheduledDeliveryTime: null,
      totalCost: null,
      orderItems: [],
      errorMessage: null,
      response: null,
      categories: [],
      selectedCategoryId: null,
      filteredSubcategories: [],
      selectedSubcategoryId: null,
      filteredProducts: [],
      isTimePickerEnabled: false,
    ));
    await _onLoadOpenOrders(LoadOpenOrders(), emit);
  }

  Future<void> _onTimePickerEnabled(
      TimePickerEnabled event, Emitter<OrderUpdateState> emit) async {
    emit(state.copyWith(isTimePickerEnabled: event.isTimePickerEnabled));
    // Si el TimePicker se deshabilita, también resetea el tiempo seleccionado
    if (!event.isTimePickerEnabled) {
      emit(state.copyWith(scheduledDeliveryTime: null));
    }
  }

  Future<void> _onLoadOpenOrders(
      LoadOpenOrders event, Emitter<OrderUpdateState> emit) async {
    emit(state.copyWith(response: Loading()));
    await _handleLoadingEvent<List<Order>>(
      emit,
      () => ordersUseCases.getOpenOrders.run(),
      (data) => state.copyWith(orders: data, response: Success(data)),
    );
  }

  Future<void> _onOrderSelectedForUpdate(
      OrderSelectedForUpdate event, Emitter<OrderUpdateState> emit) async {
    emit(state.copyWith(
        response:
            Loading())); // Añadir esta línea para manejar el estado de carga
    // Recuperar la orden usando el ID proporcionado
    final Resource<Order> orderResource =
        await ordersUseCases.getOrderForUpdate.run(event.orderId);

    if (orderResource is Success<Order>) {
      final Order order = orderResource.data;

      // Asegúrate de convertir la fecha y hora programadas a la zona horaria local antes de crear TimeOfDay
      final DateTime? localScheduledDeliveryTime =
          order.scheduledDeliveryTime?.toLocal();

      emit(state.copyWith(selectedOrderType: order.orderType));

      emit(state.copyWith(
        orderIdSelectedForUpdate: order.id,
        selectedAreaId: order.area?.id,
        selectedTableId: order.table?.id,
        phoneNumber: order.phoneNumber,
        deliveryAddress: order.deliveryAddress,
        customerName: order.customerName,
        scheduledDeliveryTime: localScheduledDeliveryTime != null
            ? TimeOfDay(
                hour: localScheduledDeliveryTime.hour,
                minute: localScheduledDeliveryTime.minute)
            : null,
        comments: order.comments,
        totalCost: order.totalCost,
        orderItems: order.orderItems,
        isTimePickerEnabled: localScheduledDeliveryTime !=
            null, // Esta línea establece isTimePickerEnabled en true si scheduledDeliveryTime no es null
      ));

      // Emitir el evento AreaSelected solo si hay un área seleccionada y el tipo de orden es DineIn
      if (order.orderType == OrderType.dineIn && state.selectedAreaId != null) {
        await _onLoadAreas(LoadAreas(), emit);
        await Future.doWhile(() async {
          await Future.delayed(Duration(milliseconds: 100));
          return state.areas == null || state.areas!.isEmpty;
        });
        // Cargar las mesas después de seleccionar el área y esperar a que estén listas
        await _onLoadTables(LoadTables(areaId: state.selectedAreaId!), emit);
        await Future.doWhile(() async {
          await Future.delayed(Duration(milliseconds: 100));
          return state.tables == null || state.tables!.isEmpty;
        });
        // Solo asignar la mesa si state.tables no es null
        if (state.tables != null) {
          add(TableSelected(tableId: state.selectedTableId!));
        }
      }
    } else {
      // Manejar el caso de error
      _handleError(emit, orderResource);
    }
  }

  Future<void> _onOrderTypeSelected(
      OrderTypeSelected event, Emitter<OrderUpdateState> emit) async {
    print(event.selectedOrderType);
    emit(state.copyWith(selectedOrderType: event.selectedOrderType));
    if (event.selectedOrderType == OrderType.dineIn) {
      await _onLoadAreas(LoadAreas(), emit);
      await Future.doWhile(() async {
        await Future.delayed(Duration(milliseconds: 100));
        return state.areas == null || state.areas!.isEmpty;
      });
    }
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
    await _handleLoadingEvent<List<Area>>(
      emit,
      () => areasUseCases.getAreas.run(),
      (data) => state.copyWith(areas: data, response: Success(data)),
    );
  }

  Future<void> _onLoadTables(
      LoadTables event, Emitter<OrderUpdateState> emit) async {
    await _handleLoadingEvent<List<appModel.Table>>(
      emit,
      () => areasUseCases.getTablesFromArea.run(event.areaId),
      (data) => state.copyWith(tables: data, response: Success(data)),
    );
  }

  Future<void> _onAddOrderItem(
      AddOrderItem event, Emitter<OrderUpdateState> emit) async {
    final updatedOrderItems = List<OrderItem>.from(state.orderItems ?? [])
      ..add(event.orderItem);
    emit(state.copyWith(orderItems: updatedOrderItems));
  }

  Future<void> _onUpdateOrderItem(
      UpdateOrderItem event, Emitter<OrderUpdateState> emit) async {
    final updatedOrderItems = state.orderItems?.map((orderItem) {
          return orderItem.tempId == event.orderItem.tempId
              ? event.orderItem
              : orderItem;
        }).toList() ??
        [];
    emit(state.copyWith(orderItems: updatedOrderItems));
  }

  Future<void> _onRemoveOrderItem(
      RemoveOrderItem event, Emitter<OrderUpdateState> emit) async {
    final updatedOrderItems = state.orderItems
            ?.where((item) => item.tempId != event.tempId)
            .toList() ??
        [];
    emit(state.copyWith(orderItems: updatedOrderItems));
  }

  Future<void> _onLoadCategoriesWithProducts(
      LoadCategoriesWithProducts event, Emitter<OrderUpdateState> emit) async {
    await _handleLoadingEvent<List<Category>>(
      emit,
      () => categoriesUseCases.getCategoriesWithProducts.run(),
      (data) => state.copyWith(categories: data, response: Success(data)),
    );
  }

  Future<void> _onCategorySelected(
      CategorySelected event, Emitter<OrderUpdateState> emit) async {
    Category? selectedCategory;
    try {
      selectedCategory =
          state.categories?.firstWhere((cat) => cat.id == event.categoryId);
    } catch (e) {
      // If no match is found, selectedCategory remains null.
    }

    final filteredSubcategories = selectedCategory?.subcategories ?? [];

    emit(state.copyWith(
      selectedCategoryId: event.categoryId,
      filteredSubcategories: filteredSubcategories,
      filteredProducts: [],
      selectedSubcategoryId: null,
    ));
  }

  Future<void> _onSubcategorySelected(
      SubcategorySelected event, Emitter<OrderUpdateState> emit) async {
    Subcategory? selectedSubcategory;
    try {
      selectedSubcategory = state.filteredSubcategories
          ?.firstWhere((sub) => sub.id == event.subcategoryId);
    } catch (e) {
      // If no match is found, selectedSubcategory remains null.
    }
    final filteredProducts = selectedSubcategory?.products ?? [];

    emit(state.copyWith(
      selectedSubcategoryId: event.subcategoryId,
      filteredProducts: filteredProducts,
    ));
  }

  Future<void> _onUpdateOrder(
      UpdateOrder event, Emitter<OrderUpdateState> emit) async {
    DateTime? scheduledDeliveryDateTime;
    if (state.isTimePickerEnabled == true &&
        state.scheduledDeliveryTime != null) {
      final now = DateTime.now();
      scheduledDeliveryDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        state.scheduledDeliveryTime!.hour,
        state.scheduledDeliveryTime!.minute,
      );
    }

    // Inicializa los campos comunes para todos los tipos de orden
    Order order = Order(
      id: state.orderIdSelectedForUpdate,
      orderType: state.selectedOrderType,
      status: OrderStatus.created,
      totalCost: state.totalCost,
      comments: state.comments,
      creationDate: DateTime.now(),
      scheduledDeliveryTime: scheduledDeliveryDateTime,
      // Inicializa los campos opcionales como null
      phoneNumber: null,
      deliveryAddress: null,
      customerName: null,
      area: null,
      table: null,
      orderItems: state.orderItems,
    );

    // Asigna los campos específicos según el tipo de orden
    switch (state.selectedOrderType) {
      case OrderType.dineIn:
        order = order.copyWith(
          area: state.areas
              ?.firstWhereOrNull((area) => area.id == state.selectedAreaId),
          table: state.tables
              ?.firstWhereOrNull((table) => table.id == state.selectedTableId),
        );
        break;
      case OrderType.delivery:
        order = order.copyWith(
          phoneNumber: state.phoneNumber,
          deliveryAddress: state.deliveryAddress,
        );
        break;
      case OrderType.pickUpWait:
        order = order.copyWith(
          phoneNumber: state.phoneNumber,
          customerName: state.customerName,
        );
        break;
      default:
        break; // No se requiere acción adicional para otros tipos
    }

    final result = await ordersUseCases.updateOrder.run(order);

    if (result is Success<Order>) {
      // Maneja el éxito, por ejemplo, mostrando un mensaje
      print('Orden creada con éxito: ${result.data.id}');
    } else if (result is Error<Order>) {
      // Maneja el error, por ejemplo, mostrando un mensaje de error
      print('Error al crear la orden: ${result.message}');
    }
    add(ResetOrderUpdateState());
  }

  // High-order function to handle loading events
  Future<void> _handleLoadingEvent<T>(
    Emitter<OrderUpdateState> emit,
    Future<Resource> Function() action,
    OrderUpdateState Function(T data) onSuccess,
  ) async {
    emit(state.copyWith(response: Loading()));
    try {
      final response = await action();
      if (response is Success<T>) {
        emit(onSuccess(response.data));
      } else {
        _handleError(emit, response);
      }
    } catch (e) {
      _handleError(emit, Error(e.toString()));
    }
  }

  // Centralized error handling
  void _handleError(Emitter<OrderUpdateState> emit, Resource response) {
    emit(state.copyWith(response: response));
  }
}
