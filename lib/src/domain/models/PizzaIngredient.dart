import 'package:app/src/domain/models/Product.dart';

class PizzaIngredient {
  final int id;
  final String name;
  final double? price; // 'price' ahora puede ser nulo

  PizzaIngredient({
    required this.id,
    required this.name,
    this.price, // 'price' ya no es requerido
  });

  factory PizzaIngredient.fromJson(Map<String, dynamic> json) {
    return PizzaIngredient(
      id: json['id'],
      name: json['name'],
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null, // Manejo seguro de 'price'
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'name': name,
      'price':
          price, // 'price' puede ser nulo, así que está bien incluirlo directamente
    };
    return data;
  }
}
