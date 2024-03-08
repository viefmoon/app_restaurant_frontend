import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/models/Product.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class OrderCreationEvent extends Equatable {
  const OrderCreationEvent();
  @override
  List<Object> get props => [];
}

class OrderTypeSelected extends OrderCreationEvent {
  final OrderType selectedOrderType;

  const OrderTypeSelected({required this.selectedOrderType});
}

class ResetTableSelection extends OrderCreationEvent {
  const ResetTableSelection();

  @override
  List<Object> get props => [];
}

class UpdateOrderItem extends OrderCreationEvent {
  final OrderItem orderItem;

  const UpdateOrderItem({required this.orderItem});

  @override
  List<Object> get props => [orderItem];
}

class PhoneNumberEntered extends OrderCreationEvent {
  final String phoneNumber;

  const PhoneNumberEntered({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

class DeliveryAddressEntered extends OrderCreationEvent {
  final String deliveryAddress;

  const DeliveryAddressEntered({required this.deliveryAddress});

  @override
  List<Object> get props => [deliveryAddress];
}

class CustomerNameEntered extends OrderCreationEvent {
  final String customerName;

  const CustomerNameEntered({required this.customerName});

  @override
  List<Object> get props => [customerName];
}

class OrderCommentsEntered extends OrderCreationEvent {
  final String comments;

  const OrderCommentsEntered({required this.comments});

  @override
  List<Object> get props => [comments];
}

class TimeSelected extends OrderCreationEvent {
  final TimeOfDay time;

  const TimeSelected({required this.time});

  @override
  List<Object> get props => [time];
}

class LoadAreas extends OrderCreationEvent {
  const LoadAreas();
}

class ResetOrder extends OrderCreationEvent {
  const ResetOrder();
}

class LoadTables extends OrderCreationEvent {
  final int areaId;
  const LoadTables({required this.areaId});
  @override
  List<Object> get props => [areaId];
}

class AreaSelected extends OrderCreationEvent {
  final int areaId;
  const AreaSelected({required this.areaId});
  @override
  List<Object> get props => [areaId];
}

class TableSelected extends OrderCreationEvent {
  final int tableId;
  const TableSelected({required this.tableId});
  @override
  List<Object> get props => [tableId];
}

class LoadCategoriesWithProducts extends OrderCreationEvent {
  const LoadCategoriesWithProducts();
}

class CategorySelected extends OrderCreationEvent {
  final int categoryId;
  const CategorySelected({required this.categoryId});
  @override
  List<Object> get props => [categoryId];
}

class SubcategorySelected extends OrderCreationEvent {
  final int subcategoryId;
  const SubcategorySelected({required this.subcategoryId});
  @override
  List<Object> get props => [subcategoryId];
}

class ProductSelected extends OrderCreationEvent {
  final int productId;
  const ProductSelected({required this.productId});
  @override
  List<Object> get props => [productId];
}

class AddProductToOrder extends OrderCreationEvent {
  final Product product;
  const AddProductToOrder({required this.product});
  @override
  List<Object> get props => [product];
}

class TableSelectionContinue extends OrderCreationEvent {
  const TableSelectionContinue();
}

class AddOrderItem extends OrderCreationEvent {
  final OrderItem orderItem;

  const AddOrderItem({required this.orderItem});

  @override
  List<Object> get props => [orderItem];
}

class SendOrder extends OrderCreationEvent {
  const SendOrder();

  @override
  List<Object> get props => [];
}
