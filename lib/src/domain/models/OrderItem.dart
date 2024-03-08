import 'package:app/src/domain/models/OrderItemUpdate.dart';
import 'package:app/src/domain/models/PizzaFlavor.dart';
import 'package:app/src/domain/models/Product.dart';
import 'package:app/src/domain/models/ProductVariant.dart';
import 'package:app/src/domain/models/SelectedModifier.dart';
import 'package:app/src/domain/models/SelectedProductObservation.dart';
import 'package:app/src/domain/models/Order.dart' as OrderModel;
import 'package:uuid/uuid.dart';

enum OrderItemStatus { created, inPreparation, finished }

class OrderItem {
  final int? id;
  final String tempId;
  OrderItemStatus? status;
  String? comments;
  OrderModel.Order? order;
  Product? product;
  ProductVariant? productVariant;
  List<SelectedModifier>? selectedModifiers;
  List<SelectedProductObservation>? selectedProductObservations;
  PizzaFlavor? pizzaFlavor;
  double? price;
  List<OrderItemUpdate>? orderItemUpdates;

  OrderItem({
    this.id,
    String? tempId,
    this.status,
    this.comments,
    this.order,
    this.product,
    this.productVariant,
    this.selectedModifiers,
    this.selectedProductObservations,
    this.pizzaFlavor,
    this.price,
    this.orderItemUpdates,
  }) : this.tempId = tempId ?? Uuid().v4();

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      status: OrderItemStatus.values
          .firstWhere((e) => e.toString().split(".").last == json['status']),
      comments: json['comments'],
      order: json['order'] != null
          ? OrderModel.Order.fromJson(json['order'])
          : null,
      product:
          json['product'] != null ? Product.fromJson(json['product']) : null,
      productVariant: json['productVariant'] != null
          ? ProductVariant.fromJson(json['productVariant'])
          : null,
      selectedModifiers: json['selectedModifiers'] != null
          ? (json['selectedModifiers'] as List)
              .map((i) => SelectedModifier.fromJson(i))
              .toList()
          : null,
      selectedProductObservations: json['selectedProductObservations'] != null
          ? (json['selectedProductObservations'] as List)
              .map((i) => SelectedProductObservation.fromJson(i))
              .toList()
          : null,
      pizzaFlavor: json['pizzaFlavor'] != null
          ? PizzaFlavor.fromJson(json['pizzaFlavor'])
          : null,
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
      orderItemUpdates: json['orderItemUpdates'] != null
          ? (json['orderItemUpdates'] as List)
              .map((i) => OrderItemUpdate.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['status'] = status.toString().split(".").last;
    data['comments'] = comments;
    if (order != null) data['order'] = order!.toJson();
    if (product != null) data['product'] = product!.toJson();
    if (productVariant != null) {
      data['productVariant'] = productVariant!.toJson();
    }
    if (selectedModifiers != null) {
      data['selectedModifiers'] =
          selectedModifiers!.map((v) => v.toJson()).toList();
    }
    if (selectedProductObservations != null) {
      data['selectedProductObservations'] =
          selectedProductObservations!.map((v) => v.toJson()).toList();
    }
    if (pizzaFlavor != null) {
      data['pizzaFlavor'] = pizzaFlavor!.toJson();
    }
    if (price != null) {
      data['price'] = price;
    }
    if (orderItemUpdates != null) {
      data['orderItemUpdates'] =
          orderItemUpdates!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  OrderItem copyWith({
    int? id,
    String? tempId,
    OrderItemStatus? status,
    String? comments,
    OrderModel.Order? order,
    Product? product,
    ProductVariant? productVariant,
    List<SelectedModifier>? selectedModifiers,
    List<SelectedProductObservation>? selectedProductObservations,
    PizzaFlavor? pizzaFlavor,
    double? price,
    List<OrderItemUpdate>? orderItemUpdates,
  }) {
    return OrderItem(
      id: id ?? this.id,
      tempId: tempId ?? this.tempId,
      status: status ?? this.status,
      comments: comments ?? this.comments,
      order: order ?? this.order,
      product: product ?? this.product,
      productVariant: productVariant ?? this.productVariant,
      selectedModifiers: selectedModifiers ?? this.selectedModifiers,
      selectedProductObservations:
          selectedProductObservations ?? this.selectedProductObservations,
      pizzaFlavor: pizzaFlavor ?? this.pizzaFlavor,
      price: price ?? this.price,
      orderItemUpdates: orderItemUpdates ?? this.orderItemUpdates,
    );
  }
}
