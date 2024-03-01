import 'package:app/src/domain/models/ProductObservation.dart';

class ProductObservationType {
  final int id;
  final String name;
  final bool acceptsMultiple;
  List<ProductObservation>? productObservations;

  ProductObservationType({
    required this.id,
    required this.name,
    required this.acceptsMultiple,
    this.productObservations,
  });

  factory ProductObservationType.fromJson(Map<String, dynamic> json) {
    return ProductObservationType(
      id: json['id'],
      name: json['name'],
      acceptsMultiple: json['acceptsMultiple'],
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
      'acceptsMultiple': acceptsMultiple,
    };
    if (productObservations != null) {
      data['productObservations'] =
          productObservations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
