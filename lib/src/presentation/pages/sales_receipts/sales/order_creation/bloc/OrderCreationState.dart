import 'package:app/src/domain/models/Category.dart';
import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/models/Product.dart';
import 'package:app/src/domain/models/Subcategory.dart';
import 'package:equatable/equatable.dart';
import 'package:app/src/domain/models/Area.dart';
import 'package:app/src/domain/models/Table.dart' as TableModel;
import 'package:app/src/domain/utils/Resource.dart';
import 'package:flutter/material.dart';

enum OrderCreationStep {
  orderTypeSelection,
  phoneNumberInput,
  tableSelection,
  productSelection,
  orderSummary
}

enum OrderType { delivery, pickUpWait, dineIn }

class OrderCreationState extends Equatable {
  final OrderType? selectedOrderType;
  final String? phoneNumber;
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
  final List<OrderItem>? orderItems;
  final String? deliveryAddress;
  final String? customerName;
  final String? comments;
  final TimeOfDay? selectedTime;
  final Resource? response;
  final OrderCreationStep? step;

  const OrderCreationState({
    this.selectedOrderType,
    this.phoneNumber,
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
    this.orderItems,
    this.deliveryAddress,
    this.customerName,
    this.comments,
    this.selectedTime,
    this.response,
    this.step,
  });

  OrderCreationState copyWith({
    OrderType? selectedOrderType,
    String? phoneNumber,
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
    List<OrderItem>? orderItems,
    String? deliveryAddress,
    String? customerName,
    String? comments,
    TimeOfDay? selectedTime,
    Resource? response,
    OrderCreationStep? step,
  }) {
    return OrderCreationState(
      selectedOrderType: selectedOrderType ?? this.selectedOrderType,
      phoneNumber: phoneNumber ?? this.phoneNumber,
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
      orderItems: orderItems ?? this.orderItems,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      customerName: customerName ?? this.customerName,
      comments: comments ?? this.comments,
      selectedTime: selectedTime ?? this.selectedTime,
      response: response ?? this.response,
      step: step ?? this.step,
    );
  }

  @override
  List<Object?> get props => [
        selectedOrderType,
        phoneNumber,
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
        orderItems,
        deliveryAddress,
        customerName,
        comments,
        selectedTime,
        response,
        step,
      ];
}
