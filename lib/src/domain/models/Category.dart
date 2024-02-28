import 'package:app/src/domain/models/Subcategory.dart';

class Category {
  final int id;
  final String name;
  List<Subcategory>? subcategories;

  Category({
    required this.id,
    required this.name,
    this.subcategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      subcategories: json['subcategories'] != null
          ? (json['subcategories'] as List)
              .map((i) => Subcategory.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'name': name,
    };
    if (subcategories != null) {
      data['subcategories'] = subcategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
