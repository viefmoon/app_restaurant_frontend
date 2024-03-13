class PizzaFlavor {
  final int id;
  final String name;
  final double price;

  PizzaFlavor({
    required this.id,
    required this.name,
    required this.price,
  });

  factory PizzaFlavor.fromJson(Map<String, dynamic> json) {
    return PizzaFlavor(
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
