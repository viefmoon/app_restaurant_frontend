import 'package:app/src/domain/models/Area.dart';
import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/models/Table.dart' as TableModel;
import 'package:equatable/equatable.dart';
import 'package:app/src/domain/utils/Resource.dart';
import 'package:flutter/material.dart';

class OrderUpdateState extends Equatable {
  final List<Order>? orders;
  final int? orderIdSelectedForUpdate;
  final OrderType? selectedOrderType;
  final List<Area>? areas;
  final List<TableModel.Table>? tables;
  final int? selectedAreaId;
  final String? selectedAreaName;
  final int? selectedTableId;
  final int? selectedTableNumber;
  final String? phoneNumber;
  final String? deliveryAddress;
  final String? customerName;
  final String? comments;
  final TimeOfDay? scheduledDeliveryTime;
  final double? totalCost;
  final List<OrderItem>? orderItems;
  final String? errorMessage;
  final Resource? response;

  const OrderUpdateState({
    this.orders,
    this.orderIdSelectedForUpdate,
    this.selectedOrderType,
    this.areas,
    this.tables,
    this.selectedAreaId,
    this.selectedAreaName,
    this.selectedTableId,
    this.selectedTableNumber,
    this.phoneNumber,
    this.deliveryAddress,
    this.customerName,
    this.comments,
    this.scheduledDeliveryTime,
    this.totalCost,
    this.orderItems,
    this.errorMessage,
    this.response,
  });

  OrderUpdateState copyWith({
    List<Order>? orders,
    int? orderIdSelectedForUpdate,
    OrderType? selectedOrderType,
    List<Area>? areas,
    List<TableModel.Table>? tables,
    int? selectedAreaId,
    String? selectedAreaName,
    int? selectedTableId,
    int? selectedTableNumber,
    String? phoneNumber,
    String? deliveryAddress,
    String? customerName,
    String? comments,
    TimeOfDay? scheduledDeliveryTime,
    double? totalCost,
    List<OrderItem>? orderItems,
    String? errorMessage,
    Resource? response,
    bool? updateSuccess,
  }) {
    return OrderUpdateState(
      orders: orders ?? this.orders,
      orderIdSelectedForUpdate: orderIdSelectedForUpdate ??
          this.orderIdSelectedForUpdate, // Asignar el nuevo parámetro
      selectedOrderType: selectedOrderType ?? this.selectedOrderType,
      areas: areas ?? this.areas,
      tables: tables ?? this.tables,
      selectedAreaId: selectedAreaId ?? this.selectedAreaId,
      selectedAreaName: selectedAreaName ?? this.selectedAreaName,
      selectedTableId: selectedTableId ?? this.selectedTableId,
      selectedTableNumber: selectedTableNumber ?? this.selectedTableNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      customerName: customerName ?? this.customerName,
      comments: comments ?? this.comments,
      scheduledDeliveryTime:
          scheduledDeliveryTime ?? this.scheduledDeliveryTime,
      totalCost: totalCost ?? this.totalCost,
      orderItems: orderItems ?? this.orderItems,
      errorMessage: errorMessage ?? this.errorMessage,
      response: response ?? this.response,
    );
  }

  @override
  List<Object?> get props => [
        orders,
        orderIdSelectedForUpdate, // Añadir el nuevo parámetro a props
        selectedOrderType,
        areas,
        tables,
        selectedAreaId,
        selectedAreaName,
        selectedTableId,
        selectedTableNumber,
        phoneNumber,
        deliveryAddress,
        customerName,
        comments,
        scheduledDeliveryTime,
        totalCost,
        orderItems,
        errorMessage,
        response,
      ];
}
