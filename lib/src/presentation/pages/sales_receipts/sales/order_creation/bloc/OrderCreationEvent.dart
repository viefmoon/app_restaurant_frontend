import 'package:app/src/domain/models/Product.dart';
import 'package:equatable/equatable.dart';

abstract class OrderCreationEvent extends Equatable {
  const OrderCreationEvent();
  @override
  List<Object> get props => [];
}

class OrderCreationInitEvent extends OrderCreationEvent {
  const OrderCreationInitEvent();
}

class LoadAreas extends OrderCreationEvent {
  const LoadAreas();
}

class LoadTables extends OrderCreationEvent {
  final int areaId; // Cambiado para manejar directamente el ID como int.
  const LoadTables({required this.areaId});
  @override
  List<Object> get props => [areaId];
}

class AreaSelected extends OrderCreationEvent {
  final int areaId; // Cambiado para manejar directamente el ID como int.
  const AreaSelected({required this.areaId});
  @override
  List<Object> get props => [areaId];
}

class TableSelected extends OrderCreationEvent {
  final int tableId; // Cambiado para manejar directamente el ID como int.
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

// class ProductCustomized extends OrderCreationEvent {
//   final ProductCustomization customization;
//   const ProductCustomized({required this.customization});
//   @override
//   List<Object> get props => [customization];
// }

class AddProductToOrder extends OrderCreationEvent {
  final Product product;
  const AddProductToOrder({required this.product});
  @override
  List<Object> get props => [product];
}

class TableSelectionContinue extends OrderCreationEvent {
  const TableSelectionContinue();
}
