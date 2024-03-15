import 'package:app/src/domain/models/Area.dart';
import 'package:app/src/domain/models/Category.dart';
import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/models/Subcategory.dart';
import 'package:app/src/domain/models/Table.dart' as appModel;
import 'package:app/src/domain/useCases/areas/AreasUseCases.dart';
import 'package:app/src/domain/useCases/categories/CategoriesUseCases.dart';
import 'package:app/src/domain/useCases/orders/OrdersUseCases.dart';
import 'package:app/src/domain/utils/Resource.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_update/bloc/OrderUpdateEvent.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_update/bloc/OrderUpdateState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderUpdateBloc extends Bloc<OrderUpdateEvent, OrderUpdateState> {
  final OrdersUseCases ordersUseCases;
  final AreasUseCases areasUseCases;
  final CategoriesUseCases categoriesUseCases;

  OrderUpdateBloc(
      {required this.ordersUseCases,
      required this.areasUseCases,
      required this.categoriesUseCases})
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
    on<AddOrderItem>(_onAddOrderItem);
    on<UpdateOrderItem>(_onUpdateOrderItem);
    on<OrderSelectedForUpdate>(_onOrderSelectedForUpdate);
    on<ResetOrderUpdateState>(_onResetOrderUpdateState);
    on<RemoveOrderItem>(_onRemoveOrderItem);
    on<LoadCategoriesWithProducts>(_onLoadCategoriesWithProducts);
    on<CategorySelected>(_onCategorySelected);
    on<SubcategorySelected>(_onSubcategorySelected);
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
    // Wait for areas to be loaded before proceeding
    await Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: 100));
      return state.areas == null || state.areas!.isEmpty;
    });

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

    // Finalmente, emite el evento AreaSelected si hay un área seleccionada
    if (state.selectedAreaId != null) {
      add(AreaSelected(areaId: state.selectedAreaId!));
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

  Future<void> _onAddOrderItem(
      AddOrderItem event, Emitter<OrderUpdateState> emit) async {
    print('event.addorderItem: ${event.orderItem}');
    // Añade el OrderItem proporcionado por el evento al estado actual
    final updatedOrderItems = List<OrderItem>.from(state.orderItems ?? [])
      ..add(event.orderItem);
    emit(state.copyWith(orderItems: updatedOrderItems));
    // Imprime los nombres de todos los OrderItems
    for (var orderItem in updatedOrderItems) {
      print('Nombre del OrderItem: ${orderItem.product?.name}');
    }
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
    // Filtra la lista de OrderItems para excluir el que tiene el tempId proporcionado
    final updatedOrderItems = state.orderItems
            ?.where((item) => item.tempId != event.tempId)
            .toList() ??
        [];

    // Emite un nuevo estado con la lista actualizada de OrderItems
    emit(state.copyWith(orderItems: updatedOrderItems));
  }

  Future<void> _onLoadCategoriesWithProducts(
      LoadCategoriesWithProducts event, Emitter<OrderUpdateState> emit) async {
    emit(state.copyWith(response: Loading()));
    try {
      Resource response =
          await categoriesUseCases.getCategoriesWithProducts.run();
      if (response is Success<List<Category>>) {
        List<Category> categories = response.data;
        emit(state.copyWith(
            categories: categories, response: Success(categories)));
      } else {
        emit(state.copyWith(categories: [], response: response));
      }
    } catch (e) {
      emit(state.copyWith(categories: [], response: Error(e.toString())));
    }
  }

  Future<void> _onCategorySelected(
      CategorySelected event, Emitter<OrderUpdateState> emit) async {
    Category? selectedCategory;
    try {
      selectedCategory =
          state.categories?.firstWhere((cat) => cat.id == event.categoryId);
    } catch (e) {
      // Si no se encuentra ninguna coincidencia, selectedCategory permanecerá como null.
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
      // Si no se encuentra ninguna coincidencia, selectedSubcategory permanecerá como null.
    }
    final filteredProducts = selectedSubcategory?.products ?? [];

    emit(state.copyWith(
      selectedSubcategoryId: event.subcategoryId,
      filteredProducts: filteredProducts,
    ));
  }
}
