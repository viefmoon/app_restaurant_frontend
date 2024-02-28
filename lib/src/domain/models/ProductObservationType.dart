import 'package:app/src/domain/models/ProductObservation.dart';

class ProductObservationType {
  final int id;
  final String name;
  List<ProductObservation>? productObservations;

  ProductObservationType({
    required this.id,
    required this.name,
    this.productObservations,
  });

  factory ProductObservationType.fromJson(Map<String, dynamic> json) {
    return ProductObservationType(
      id: json['id'],
      name: json['name'],
      productObservations: json['productObservations'] != null
          ? (json['productObservations'] as List)
              .map((i) => ProductObservation.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'name': name,
    };
    if (productObservations != null) {
      data['productObservations'] =
          productObservations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
