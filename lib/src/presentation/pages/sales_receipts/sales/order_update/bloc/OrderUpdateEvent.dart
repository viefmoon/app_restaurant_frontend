import 'package:app/src/domain/models/Order.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class OrderUpdateEvent extends Equatable {
  const OrderUpdateEvent();

  @override
  List<Object> get props => [];
}

class LoadOrders extends OrderUpdateEvent {
  const LoadOrders();

  @override
  List<Object> get props => [];
}

class OrderSelectedForUpdate extends OrderUpdateEvent {
  final Order order;

  const OrderSelectedForUpdate(this.order);

  @override
  List<Object> get props => [order];
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
  final Order order;

  const UpdateOrder(this.order);

  @override
  List<Object> get props => [order];
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
