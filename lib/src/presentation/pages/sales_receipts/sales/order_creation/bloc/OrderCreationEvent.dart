import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/models/Product.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationState.dart';
import 'package:equatable/equatable.dart';

abstract class OrderCreationEvent extends Equatable {
  const OrderCreationEvent();
  @override
  List<Object> get props => [];
}

class BackToPreviousStep extends OrderCreationEvent {
  const BackToPreviousStep();
}

class OrderTypeSelected extends OrderCreationEvent {
  final OrderType selectedOrderType;

  const OrderTypeSelected({required this.selectedOrderType});
}

class OrderCreationInitEvent extends OrderCreationEvent {
  const OrderCreationInitEvent();
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

  AddOrderItem({required this.orderItem});

  @override
  List<Object> get props => [orderItem];
}
