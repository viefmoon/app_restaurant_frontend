import 'package:app/src/domain/models/Category.dart';
import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/models/Product.dart';
import 'package:app/src/domain/models/Subcategory.dart';
import 'package:equatable/equatable.dart';
import 'package:app/src/domain/models/Area.dart';
import 'package:app/src/domain/models/Table.dart' as TableModel;
import 'package:app/src/domain/utils/Resource.dart';

class OrderCreationState extends Equatable {
  final List<Area>? areas;
  final List<TableModel.Table>? tables;
  final int? selectedAreaId;
  final int? selectedTableId;
  final List<Category>? categories;
  final int? selectedCategoryId;
  final int? selectedSubcategoryId;
  final List<Subcategory>?
      filteredSubcategories; // Nuevo campo para subcategorías filtradas
  final List<Product>? filteredProducts; // Nuevo campo para productos filtrados
  final List<Product>? selectedProducts; // Para productos seleccionados
  final Order? currentOrder; // Para manejar el carrito y el resumen
  final Resource? response;

  const OrderCreationState({
    this.areas,
    this.tables,
    this.selectedAreaId,
    this.selectedTableId,
    this.categories,
    this.selectedCategoryId,
    this.selectedSubcategoryId,
    this.filteredSubcategories, // Inicializa el nuevo campo
    this.filteredProducts, // Inicializa el nuevo campo
    this.selectedProducts,
    this.currentOrder,
    this.response,
  });

  OrderCreationState copyWith({
    List<Area>? areas,
    List<TableModel.Table>? tables,
    int? selectedAreaId,
    int? selectedTableId,
    List<Category>? categories,
    int? selectedCategoryId,
    int? selectedSubcategoryId,
    List<Subcategory>? filteredSubcategories, // Nuevo campo
    List<Product>? filteredProducts, // Nuevo campo
    List<Product>? selectedProducts,
    Order? currentOrder,
    Resource? response,
  }) {
    return OrderCreationState(
      areas: areas ?? this.areas,
      tables: tables ?? this.tables,
      selectedAreaId: selectedAreaId ?? this.selectedAreaId,
      selectedTableId: selectedTableId ?? this.selectedTableId,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedSubcategoryId:
          selectedSubcategoryId ?? this.selectedSubcategoryId,
      filteredSubcategories:
          filteredSubcategories ?? this.filteredSubcategories,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      selectedProducts: selectedProducts ?? this.selectedProducts,
      currentOrder: currentOrder ?? this.currentOrder,
      response: response ?? this.response,
    );
  }

  @override
  List<Object?> get props => [
        areas,
        tables,
        selectedAreaId,
        selectedTableId,
        categories,
        selectedCategoryId,
        selectedSubcategoryId,
        filteredSubcategories, // Añade el nuevo campo a la lista de props
        filteredProducts, // Añade el nuevo campo a la lista de props
        selectedProducts,
        currentOrder,
        response,
      ];
}
