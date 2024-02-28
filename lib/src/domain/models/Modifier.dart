import 'package:app/src/domain/models/ModifierType.dart';

class Modifier {
  final int id;
  final String name;
  final double price;
  ModifierType? modifierType;

  Modifier({
    required this.id,
    required this.name,
    required this.price,
    this.modifierType,
  });

  factory Modifier.fromJson(Map<String, dynamic> json) {
    return Modifier(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      modifierType: json['modifierType'] != null
          ? ModifierType.fromJson(json['modifierType'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
    };
    if (modifierType != null) {
      data['modifierType'] = modifierType!.toJson();
    }
    return data;
  }
}
