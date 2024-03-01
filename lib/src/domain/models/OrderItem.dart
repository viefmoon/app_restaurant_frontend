import 'package:app/src/domain/models/OrderItemUpdate.dart';
import 'package:app/src/domain/models/PizzaFlavor.dart';
import 'package:app/src/domain/models/Product.dart';
import 'package:app/src/domain/models/ProductVariant.dart';
import 'package:app/src/domain/models/SelectedModifier.dart';
import 'package:app/src/domain/models/SelectedProductObservation.dart';
import 'package:app/src/domain/models/Order.dart' as OrderModel;

enum OrderItemStatus { creado, enPreparacion, finalizado }

class OrderItem {
  final int? id;
  OrderItemStatus? status;
  String? comments;
  OrderModel.Order? order;
  Product? product;
  ProductVariant? productVariant;
  List<SelectedModifier>? selectedModifiers;
  List<SelectedProductObservation>? selectedProductObservations;
  PizzaFlavor? pizzaFlavor;
  List<OrderItemUpdate>? orderItemUpdates;

  OrderItem({
    this.id,
    this.status,
    this.comments,
    this.order,
    this.product,
    this.productVariant,
    this.selectedModifiers,
    this.selectedProductObservations,
    this.pizzaFlavor,
    this.orderItemUpdates,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      status: OrderItemStatus.values
          .firstWhere((e) => e.toString().split(".").last == json['status']),
      comments: json['comments'],
      // Las siguientes líneas asumen la existencia de métodos fromJson para cada modelo relacionado
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
    if (orderItemUpdates != null) {
      data['orderItemUpdates'] =
          orderItemUpdates!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
