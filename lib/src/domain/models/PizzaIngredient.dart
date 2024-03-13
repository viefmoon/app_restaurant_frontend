import 'package:app/src/domain/models/Product.dart';

class PizzaIngredient {
  final int id;
  final String name;
  final double price;

  PizzaIngredient({
    required this.id,
    required this.name,
    required this.price,
  });

  factory PizzaIngredient.fromJson(Map<String, dynamic> json) {
    return PizzaIngredient(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price']!),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
    };
    return data;
  }
}
