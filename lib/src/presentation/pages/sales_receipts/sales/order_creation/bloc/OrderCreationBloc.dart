import 'package:app/src/domain/models/Category.dart';
import 'package:app/src/domain/models/Product.dart';
import 'package:app/src/domain/models/Subcategory.dart';
import 'package:app/src/domain/useCases/categories/CategoriesUseCases.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationEvent.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/domain/useCases/areas/AreasUseCases.dart';
import 'package:app/src/domain/utils/Resource.dart';

import 'package:app/src/domain/models/Area.dart';
import 'package:app/src/domain/models/Table.dart' as appModel;

class OrderCreationBloc extends Bloc<OrderCreationEvent, OrderCreationState> {
  final AreasUseCases areasUseCases;
  final CategoriesUseCases categoriesUseCases;

  OrderCreationBloc(
      {required this.categoriesUseCases, required this.areasUseCases})
      : super(OrderCreationState()) {
    on<OrderCreationInitEvent>(_onInitEvent);
    on<AreaSelected>(_onAreaSelected);
    on<TableSelected>(_onTableSelected);
    on<LoadAreas>(_onLoadAreas);
    on<LoadTables>(_onLoadTables);
    on<LoadCategoriesWithProducts>(_onLoadCategoriesWithProducts);
    on<CategorySelected>(_onCategorySelected);
    on<SubcategorySelected>(_onSubcategorySelected);
    // on<ProductSelected>(_onProductSelected);
    // on<ProductCustomized>(_onProductCustomized);
    //on<AddProductToOrder>(_onAddProductToOrder);
  }
  Future<void> _onInitEvent(
      OrderCreationInitEvent event, Emitter<OrderCreationState> emit) async {
    await _onLoadAreas(LoadAreas(), emit);
  }

  Future<void> _onAreaSelected(
      AreaSelected event, Emitter<OrderCreationState> emit) async {
    emit(state.copyWith(selectedAreaId: event.areaId));
    await _onLoadTables(LoadTables(areaId: event.areaId), emit);
  }

  Future<void> _onTableSelected(
      TableSelected event, Emitter<OrderCreationState> emit) async {
    emit(state.copyWith(selectedTableId: event.tableId));
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

  // Future<void> _onProductSelected(
  //     ProductSelected event, Emitter<OrderCreationState> emit) async {
  //   // Aquí agregarías el producto seleccionado a la lista de productos seleccionados en el estado
  //   List<Product> updatedSelectedProducts =
  //       List.from(state.selectedProducts ?? []);
  //   updatedSelectedProducts.add(
  //       /* Producto seleccionado basado en event.productId */);
  //   emit(state.copyWith(selectedProducts: updatedSelectedProducts));
  // }

  // Future<void> _onProductCustomized(
  //     ProductCustomized event, Emitter<OrderCreationState> emit) async {
  //   // Aquí actualizarías el producto personalizado en la lista de productos seleccionados
  //   // Esto podría requerir identificar el producto específico por su ID y actualizar su personalización
  // }
}
