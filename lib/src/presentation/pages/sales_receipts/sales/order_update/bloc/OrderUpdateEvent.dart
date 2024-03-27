import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/models/OrderItem.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class OrderUpdateEvent extends Equatable {
  const OrderUpdateEvent();

  @override
  List<Object> get props => [];
}

class LoadOpenOrders extends OrderUpdateEvent {
  const LoadOpenOrders();

  @override
  List<Object> get props => [];
}

class ResetResponseEvent extends OrderUpdateEvent {
  const ResetResponseEvent();
}

class TimePickerEnabled extends OrderUpdateEvent {
  final bool isTimePickerEnabled;

  const TimePickerEnabled({required this.isTimePickerEnabled});

  @override
  List<Object> get props => [isTimePickerEnabled];
}

class OrderSelectedForUpdate extends OrderUpdateEvent {
  final int orderId;

  const OrderSelectedForUpdate(this.orderId);

  @override
  List<Object> get props => [orderId];
}

class OrderTypeSelected extends OrderUpdateEvent {
  final OrderType selectedOrderType;

  const OrderTypeSelected({required this.selectedOrderType});
}

class LoadAreas extends OrderUpdateEvent {
  const LoadAreas();
}

class LoadTables extends OrderUpdateEvent {
  final int areaId;
  const LoadTables({required this.areaId});
  @override
  List<Object> get props => [areaId];
}

class UpdateOrder extends OrderUpdateEvent {
  const UpdateOrder();

  @override
  List<Object> get props => [];
}

class PhoneNumberEntered extends OrderUpdateEvent {
  final String phoneNumber;

  const PhoneNumberEntered({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

class DeliveryAddressEntered extends OrderUpdateEvent {
  final String deliveryAddress;

  const DeliveryAddressEntered({required this.deliveryAddress});

  @override
  List<Object> get props => [deliveryAddress];
}

class CustomerNameEntered extends OrderUpdateEvent {
  final String customerName;

  const CustomerNameEntered({required this.customerName});

  @override
  List<Object> get props => [customerName];
}

class OrderCommentsEntered extends OrderUpdateEvent {
  final String comments;

  const OrderCommentsEntered({required this.comments});

  @override
  List<Object> get props => [comments];
}

class TimeSelected extends OrderUpdateEvent {
  final TimeOfDay time;

  const TimeSelected({required this.time});

  @override
  List<Object> get props => [time];
}

class AreaSelected extends OrderUpdateEvent {
  final int areaId;
  const AreaSelected({required this.areaId});
  @override
  List<Object> get props => [areaId];
}

class TableSelected extends OrderUpdateEvent {
  final int tableId;
  const TableSelected({required this.tableId});
  @override
  List<Object> get props => [tableId];
}

class ResetOrderUpdateState extends OrderUpdateEvent {
  const ResetOrderUpdateState();

  @override
  List<Object> get props => [];
}

class UpdateOrderItem extends OrderUpdateEvent {
  final OrderItem orderItem;

  const UpdateOrderItem({required this.orderItem});

  @override
  List<Object> get props => [orderItem];
}

class AddOrderItem extends OrderUpdateEvent {
  final OrderItem orderItem;

  const AddOrderItem({required this.orderItem});

  @override
  List<Object> get props => [orderItem];
}

class RemoveOrderItem extends OrderUpdateEvent {
  final String tempId;

  const RemoveOrderItem({required this.tempId});

  @override
  List<Object> get props => [tempId];
}

class LoadCategoriesWithProducts extends OrderUpdateEvent {
  const LoadCategoriesWithProducts();
}

class CategorySelected extends OrderUpdateEvent {
  final int categoryId;
  const CategorySelected({required this.categoryId});
  @override
  List<Object> get props => [categoryId];
}

class SubcategorySelected extends OrderUpdateEvent {
  final int subcategoryId;
  const SubcategorySelected({required this.subcategoryId});
  @override
  List<Object> get props => [subcategoryId];
}

class CancelOrder extends OrderUpdateEvent {
  const CancelOrder();
}
