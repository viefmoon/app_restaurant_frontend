import 'package:app/src/domain/models/Category.dart';
import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/models/Product.dart';
import 'package:app/src/domain/models/Subcategory.dart';
import 'package:equatable/equatable.dart';
import 'package:app/src/domain/models/Area.dart';
import 'package:app/src/domain/models/Table.dart' as TableModel;
import 'package:app/src/domain/utils/Resource.dart';

enum OrderCreationStep {
  orderTypeSelection,
  tableSelection,
  productSelection,
  orderSummary
}

enum OrderType { delivery, takeout, dineIn }

class OrderCreationState extends Equatable {
  final OrderType? selectedOrderType;
  final List<Area>? areas;
  final List<TableModel.Table>? tables;
  final int? selectedAreaId;
  final String? selectedAreaName;
  final int? selectedTableId;
  final int? selectedTableNumber;
  final List<Category>? categories;
  final int? selectedCategoryId;
  final int? selectedSubcategoryId;
  final List<Subcategory>? filteredSubcategories;
  final List<Product>? filteredProducts;
  final Product? selectedProductForPersonalization;
  final List<Product>? productsSelected;
  final List<OrderItem>? orderItems;
  final Order? currentOrder;
  final Resource? response;
  final OrderCreationStep? step;

  const OrderCreationState({
    this.selectedOrderType,
    this.areas,
    this.tables,
    this.selectedAreaId,
    this.selectedAreaName,
    this.selectedTableId,
    this.selectedTableNumber,
    this.categories,
    this.selectedCategoryId,
    this.selectedSubcategoryId,
    this.filteredSubcategories,
    this.filteredProducts,
    this.selectedProductForPersonalization,
    this.productsSelected,
    this.orderItems,
    this.currentOrder,
    this.response,
    this.step,
  });

  OrderCreationState copyWith({
    OrderType? selectedOrderType,
    List<Area>? areas,
    List<TableModel.Table>? tables,
    int? selectedAreaId,
    String? selectedAreaName,
    int? selectedTableId,
    int? selectedTableNumber,
    List<Category>? categories,
    int? selectedCategoryId,
    int? selectedSubcategoryId,
    List<Subcategory>? filteredSubcategories,
    List<Product>? filteredProducts,
    Product? selectedProductForPersonalization,
    List<Product>? productsSelected,
    List<OrderItem>? orderItems,
    Resource? response,
    OrderCreationStep? step,
  }) {
    return OrderCreationState(
      selectedOrderType: selectedOrderType ?? this.selectedOrderType,
      areas: areas ?? this.areas,
      tables: tables ?? this.tables,
      selectedAreaId: selectedAreaId ?? this.selectedAreaId,
      selectedAreaName: selectedAreaName ?? this.selectedAreaName,
      selectedTableId: selectedTableId ?? this.selectedTableId,
      selectedTableNumber: selectedTableNumber ?? this.selectedTableNumber,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedSubcategoryId:
          selectedSubcategoryId ?? this.selectedSubcategoryId,
      filteredSubcategories:
          filteredSubcategories ?? this.filteredSubcategories,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      selectedProductForPersonalization: selectedProductForPersonalization ??
          this.selectedProductForPersonalization,
      productsSelected: productsSelected ?? this.productsSelected,
      orderItems: orderItems ?? this.orderItems,
      currentOrder: currentOrder ?? this.currentOrder,
      response: response ?? this.response,
      step: step ?? this.step,
    );
  }

  @override
  List<Object?> get props => [
        selectedOrderType,
        areas,
        tables,
        selectedAreaId,
        selectedAreaName,
        selectedTableId,
        selectedTableNumber,
        categories,
        selectedCategoryId,
        selectedSubcategoryId,
        filteredSubcategories,
        filteredProducts,
        selectedProductForPersonalization,
        productsSelected,
        orderItems,
        currentOrder,
        response,
        step,
      ];
}
