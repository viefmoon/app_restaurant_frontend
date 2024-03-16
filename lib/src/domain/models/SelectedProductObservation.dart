import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/models/ProductObservation.dart';

class SelectedProductObservation {
  final int? id; // 'id' ahora puede ser nulo
  final OrderItem? orderItem;
  final ProductObservation
      productObservation; // 'productObservation' sigue siendo no nulo

  SelectedProductObservation({
    this.id, // 'id' ya no es requerido
    this.orderItem,
    required this.productObservation, // 'productObservation' es requerido
  });

  factory SelectedProductObservation.fromJson(Map<String, dynamic> json) {
    // No es necesario lanzar excepción para 'id' ya que puede ser nulo
    if (json['productObservation'] == null) {
      throw Exception("productObservation is required");
    }
    return SelectedProductObservation(
      id: json['id'],
      orderItem: json['orderItem'] != null
          ? OrderItem.fromJson(json['orderItem'])
          : null,
      productObservation:
          ProductObservation.fromJson(json['productObservation']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      // Incluir 'id' solo si no es nulo
      data['id'] = id;
    }
    // 'productObservation' siempre se incluye ya que es requerido
    data['productObservation'] = productObservation.toJson();
    if (orderItem != null) {
      data['orderItem'] = orderItem!.toJson();
    }
    return data;
  }
}
