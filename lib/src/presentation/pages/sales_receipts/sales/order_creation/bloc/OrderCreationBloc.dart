import 'package:app/src/domain/models/AuthResponse.dart';
import 'package:app/src/domain/models/Category.dart';
import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/models/Product.dart';
import 'package:app/src/domain/models/Subcategory.dart';
import 'package:app/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:app/src/domain/useCases/categories/CategoriesUseCases.dart';
import 'package:app/src/domain/useCases/orders/OrdersUseCases.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationEvent.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/domain/useCases/areas/AreasUseCases.dart';
import 'package:app/src/domain/utils/Resource.dart';
import 'package:app/src/domain/models/Area.dart';
import 'package:app/src/domain/models/Table.dart' as appModel;
import 'package:collection/collection.dart';

class OrderCreationBloc extends Bloc<OrderCreationEvent, OrderCreationState> {
  final AreasUseCases areasUseCases;
  final CategoriesUseCases categoriesUseCases;
  final OrdersUseCases ordersUseCases;
  final AuthUseCases authUseCases;

  OrderCreationBloc(
      {required this.categoriesUseCases,
      required this.areasUseCases,
      required this.ordersUseCases,
      required this.authUseCases})
      : super(OrderCreationState()) {
    on<OrderTypeSelected>(_onOrderTypeSelected);
    on<PhoneNumberEntered>(_onPhoneNumberEntered);
    on<DeliveryAddressEntered>(_onDeliveryAddressEntered);
    on<CustomerNameEntered>(_onCustomerNameEntered);
    on<OrderCommentsEntered>(_onOrderCommentsEntered);
    on<TimeSelected>(_onTimeSelected);
    on<AreaSelected>(_onAreaSelected);
    on<TableSelected>(_onTableSelected);
    on<LoadAreas>(_onLoadAreas);
    on<LoadTables>(_onLoadTables);
    on<TableSelectionContinue>(_onTableSelectionContinue);
    on<LoadCategoriesWithProducts>(_onLoadCategoriesWithProducts);
    on<CategorySelected>(_onCategorySelected);
    on<SubcategorySelected>(_onSubcategorySelected);
    on<ProductSelected>(_onProductSelected);
    on<AddOrderItem>(_onAddOrderItem);
    on<UpdateOrderItem>(_onUpdateOrderItem);
    on<ResetTableSelection>(_onResetTableSelection);
    on<SendOrder>(_onSendOrder);
    on<ResetOrder>(_onResetOrder);
    on<RemoveOrderItem>(_onRemoveOrderItem);
    on<TimePickerEnabled>(_onTimePickerEnabled);
  }

  Future<void> _onResetOrder(
      ResetOrder event, Emitter<OrderCreationState> emit) async {
    emit(OrderCreationState(
      selectedOrderType: null,
      phoneNumber: null,
      areas: const [],
      tables: const [],
      selectedAreaId: null,
      selectedAreaName: null,
      selectedTableId: null,
      selectedTableNumber: null,
      categories: const [],
      selectedCategoryId: null,
      selectedSubcategoryId: null,
      filteredSubcategories: const [],
      filteredProducts: const [],
      orderItems: const [],
      deliveryAddress: null,
      customerName: null,
      comments: null,
      scheduledDeliveryTime: null,
      totalCost: null,
      response: null,
      step: OrderCreationStep.orderTypeSelection,
      isTimePickerEnabled: false,
    ));
    await _onLoadAreas(LoadAreas(), emit);
  }

  Future<void> _onTimePickerEnabled(
      TimePickerEnabled event, Emitter<OrderCreationState> emit) async {
    emit(state.copyWith(isTimePickerEnabled: event.isTimePickerEnabled));
    // Si el TimePicker se deshabilita, también resetea el tiempo seleccionado
    if (!event.isTimePickerEnabled) {
      emit(state.copyWith(scheduledDeliveryTime: null));
    }
  }

  Future<void> _onOrderTypeSelected(
      OrderTypeSelected event, Emitter<OrderCreationState> emit) async {
    OrderCreationStep nextStep;
    switch (event.selectedOrderType) {
      case OrderType.delivery:
        nextStep = OrderCreationStep.phoneNumberInput;
        break;
      case OrderType.dineIn:
        nextStep = OrderCreationStep.tableSelection;
        break;
      case OrderType.pickUpWait:
        nextStep = OrderCreationStep.productSelection;
        add(LoadCategoriesWithProducts());
        break;
      default:
        nextStep = OrderCreationStep.orderTypeSelection;
        break;
    }

    emit(state.copyWith(
        selectedOrderType: event.selectedOrderType, step: nextStep));
  }

  Future<void> _onPhoneNumberEntered(
      PhoneNumberEntered event, Emitter<OrderCreationState> emit) async {
    emit(state.copyWith(phoneNumber: event.phoneNumber));
    emit(state.copyWith(step: OrderCreationStep.productSelection));
    add(LoadCategoriesWithProducts());
  }

  Future<void> _onDeliveryAddressEntered(
      DeliveryAddressEntered event, Emitter<OrderCreationState> emit) async {
    emit(state.copyWith(deliveryAddress: event.deliveryAddress));
  }

  Future<void> _onCustomerNameEntered(
      CustomerNameEntered event, Emitter<OrderCreationState> emit) async {
    emit(state.copyWith(customerName: event.customerName));
  }

  Future<void> _onOrderCommentsEntered(
      OrderCommentsEntered event, Emitter<OrderCreationState> emit) async {
    emit(state.copyWith(comments: event.comments));
  }

  Future<void> _onTimeSelected(
      TimeSelected event, Emitter<OrderCreationState> emit) async {
    emit(state.copyWith(scheduledDeliveryTime: event.time));
  }

  Future<void> _onAreaSelected(
      AreaSelected event, Emitter<OrderCreationState> emit) async {
    emit(state.copyWith(selectedAreaId: event.areaId));
    final areaName =
        state.areas?.firstWhere((area) => area.id == event.areaId).name;
    emit(state.copyWith(selectedAreaName: areaName));

    add(ResetTableSelection());
    add(LoadTables(areaId: event.areaId));
  }

  Future<void> _onResetTableSelection(
      ResetTableSelection event, Emitter<OrderCreationState> emit) async {
    emit(state.copyWith(
        tables: const [], selectedTableId: null, selectedTableNumber: null));
  }

  Future<void> _onTableSelected(
      TableSelected event, Emitter<OrderCreationState> emit) async {
    emit(state.copyWith(selectedTableId: event.tableId));
    final tableNumber =
        state.tables?.firstWhere((table) => table.id == event.tableId).number;
    emit(state.copyWith(selectedTableNumber: tableNumber));
  }

  Future<void> _onLoadAreas(
      LoadAreas event, Emitter<OrderCreationState> emit) async {
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
      LoadTables event, Emitter<OrderCreationState> emit) async {
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

  void _onTableSelectionContinue(
      TableSelectionContinue event, Emitter<OrderCreationState> emit) {
    emit(state.copyWith(step: OrderCreationStep.productSelection));
    add(LoadCategoriesWithProducts());
  }

  Future<void> _onLoadCategoriesWithProducts(LoadCategoriesWithProducts event,
      Emitter<OrderCreationState> emit) async {
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
      CategorySelected event, Emitter<OrderCreationState> emit) async {
    Category? selectedCategory;
    try {
      // Intenta encontrar la categoría correspondiente. Esto lanzará una excepción si no se encuentra ninguna coincidencia.
      selectedCategory =
          state.categories?.firstWhere((cat) => cat.id == event.categoryId);
    } catch (e) {
      // Si no se encuentra ninguna coincidencia, selectedCategory permanecerá como null.
    }

    // Filtrar subcategorías basadas en la categoría seleccionada.
    // Si selectedCategory es null, filteredSubcategories será una lista vacía.
    // De lo contrario, será igual a las subcategorías de la categoría seleccionada.
    final filteredSubcategories = selectedCategory?.subcategories ?? [];

    emit(state.copyWith(
      selectedCategoryId: event.categoryId,
      filteredSubcategories: filteredSubcategories,
      // Restablecer los productos filtrados y la subcategoría seleccionada porque la categoría ha cambiado
      filteredProducts: [],
      selectedSubcategoryId: null,
    ));
  }

  Future<void> _onSubcategorySelected(
      SubcategorySelected event, Emitter<OrderCreationState> emit) async {
    Subcategory? selectedSubcategory;
    try {
      // Intenta encontrar la subcategoría correspondiente. Esto lanzará una excepción si no se encuentra ninguna coincidencia.
      selectedSubcategory = state.filteredSubcategories
          ?.firstWhere((sub) => sub.id == event.subcategoryId);
    } catch (e) {
      // Si no se encuentra ninguna coincidencia, selectedSubcategory permanecerá como null.
    }

    // Si selectedSubcategory es null, filteredProducts será una lista vacía.
    // De lo contrario, será igual a los productos de la subcategoría seleccionada.
    final filteredProducts = selectedSubcategory?.products ?? [];

    emit(state.copyWith(
      selectedSubcategoryId: event.subcategoryId,
      filteredProducts: filteredProducts,
    ));
  }

  Future<void> _onProductSelected(
      ProductSelected event, Emitter<OrderCreationState> emit) async {
    // Encuentra el producto seleccionado basado en event.productId
    // Esto puede requerir cargar el producto o tener una lista de productos disponible para buscar
    Product? selectedProduct = state.filteredProducts
        ?.firstWhereOrNull((product) => product.id == event.productId);
    // Construye un nuevo OrderItem basado en el producto seleccionado y cualquier detalle adicional
    OrderItem newOrderItem = OrderItem(
      // Genera o asigna un ID único
      product: selectedProduct,
      // Inicializa otros campos como null o basado en eventos adicionales para variantes, modificadores, etc.
    );
    // Añade el nuevo OrderItem a la lista existente en el estado
    List<OrderItem> updatedOrderItems = List.from(state.orderItems ?? []);
    updatedOrderItems.add(newOrderItem);

    emit(state.copyWith(orderItems: updatedOrderItems));
  }

  Future<void> _onAddOrderItem(
      AddOrderItem event, Emitter<OrderCreationState> emit) async {
    // Añade el OrderItem proporcionado por el evento al estado actual
    final updatedOrderItems = List<OrderItem>.from(state.orderItems ?? [])
      ..add(event.orderItem);
    emit(state.copyWith(orderItems: updatedOrderItems));
  }

  Future<void> _onUpdateOrderItem(
      UpdateOrderItem event, Emitter<OrderCreationState> emit) async {
    final updatedOrderItems = state.orderItems?.map((orderItem) {
          return orderItem.tempId == event.orderItem.tempId
              ? event.orderItem
              : orderItem;
        }).toList() ??
        [];
    emit(state.copyWith(orderItems: updatedOrderItems));
  }

  Future<void> _onRemoveOrderItem(
      RemoveOrderItem event, Emitter<OrderCreationState> emit) async {
    // Filtra la lista de OrderItems para excluir el que tiene el tempId proporcionado
    final updatedOrderItems = state.orderItems
            ?.where((item) => item.tempId != event.tempId)
            .toList() ??
        [];

    // Emite un nuevo estado con la lista actualizada de OrderItems
    emit(state.copyWith(orderItems: updatedOrderItems));
  }

  Future<void> _onSendOrder(
      SendOrder event, Emitter<OrderCreationState> emit) async {
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

    AuthResponse? userSession = await authUseCases.getUserSession.run();
    String? createdBy = userSession?.user.name;

    // Inicializa los campos comunes para todos los tipos de orden
    Order order = Order(
      orderType: state.selectedOrderType,
      status: OrderStatus.created,
      totalCost: state.totalCost,
      comments: state.comments,
      creationDate: DateTime.now(),
      scheduledDeliveryTime: scheduledDeliveryDateTime,
      createdBy: createdBy,
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

    final result = await ordersUseCases.createOrder.run(order);

    if (result is Success<Order>) {
      // Maneja el éxito, por ejemplo, mostrando un mensaje
      print('Orden creada con éxito: ${result.data.id}');
    } else if (result is Error<Order>) {
      // Maneja el error, por ejemplo, mostrando un mensaje de error
      print('Error al crear la orden: ${result.message}');
    }
  }
}
