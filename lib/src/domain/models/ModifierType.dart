import 'package:app/src/domain/models/Modifier.dart';

class ModifierType {
  final int id;
  final String name;
  List<Modifier>? modifiers;

  ModifierType({
    required this.id,
    required this.name,
    this.modifiers,
  });

  factory ModifierType.fromJson(Map<String, dynamic> json) {
    return ModifierType(
      id: json['id'],
      name: json['name'],
      modifiers: json['modifiers'] != null
          ? (json['modifiers'] as List)
              .map((i) => Modifier.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'name': name,
    };
    if (modifiers != null) {
      data['modifiers'] = modifiers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
