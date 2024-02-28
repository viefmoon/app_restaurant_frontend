import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/models/Product.dart';

class PizzaFlavor {
  final int id;
  final String name;
  final String description;
  final double additionalCost;
  Product? product;
  List<OrderItem>? orderItems;

  PizzaFlavor({
    required this.id,
    required this.name,
    required this.description,
    this.additionalCost = 0.0,
    this.product,
    this.orderItems,
  });

  factory PizzaFlavor.fromJson(Map<String, dynamic> json) {
    return PizzaFlavor(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      additionalCost: json['additionalCost'] != null
          ? json['additionalCost'].toDouble()
          : 0.0,
      product:
          json['product'] != null ? Product.fromJson(json['product']) : null,
      orderItems: json['orderItems'] != null
          ? (json['orderItems'] as List)
              .map((i) => OrderItem.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['additionalCost'] = additionalCost;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (orderItems != null) {
      data['orderItems'] = orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
