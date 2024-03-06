import 'package:app/src/domain/models/ModifierType.dart';
import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/models/Product.dart';
import 'package:app/src/domain/models/ProductObservationType.dart';
import 'package:app/src/domain/models/ProductVariant.dart';
import 'package:app/src/domain/models/SelectedModifier.dart';
import 'package:app/src/domain/models/SelectedProductObservation.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductPersonalizationPage extends StatefulWidget {
  final Product product;

  const ProductPersonalizationPage({Key? key, required this.product})
      : super(key: key);

  @override
  _ProductPersonalizationPageState createState() =>
      _ProductPersonalizationPageState();
}

class _ProductPersonalizationPageState
    extends State<ProductPersonalizationPage> {
  ProductVariant? selectedVariant;
  List<SelectedModifier> selectedModifiers = [];
  List<SelectedProductObservation> selectedObservations = [];
  String? comments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: selectedVariant != null
                ? _saveOrderItem
                : null, // Habilita el botón solo si se ha seleccionado una variante
          ),
        ],
      ),
      body: ListView(
        children: [
          if (widget.product.productVariants != null)
            _buildVariantSelector(widget.product.productVariants!),
          ...widget.product.modifierTypes!
              .map(_buildModifierTypeSection)
              .toList(),
          ...widget.product.productObservationTypes!
              .map(_buildObservationTypeSection)
              .toList(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Comentarios',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                comments = value; // Actualiza el comentario del usuario
              },
            ),
          ),
        ],
      ),
    );
  }

  void _saveOrderItem() {
    double price = widget.product.price ?? 0.0; // Precio base del producto

    // Si hay una variante seleccionada, usa el precio de la variante
    if (selectedVariant != null) {
      price = selectedVariant!.price;
    }

    // Suma el precio de cada modificador seleccionado
    for (var selectedModifier in selectedModifiers) {
      price += selectedModifier.modifier?.price ?? 0.0;
    }

    // Creación del OrderItem con los datos necesarios, incluyendo el precio calculado
    final orderItem = OrderItem(
      product: widget.product,
      productVariant: selectedVariant,
      selectedModifiers: selectedModifiers
          .map((selectedModifier) =>
              SelectedModifier(modifier: selectedModifier.modifier))
          .toList(),
      selectedProductObservations: selectedObservations
          .map((selectedProductObservation) => SelectedProductObservation(
              productObservation:
                  selectedProductObservation.productObservation))
          .toList(),
      comments: comments,
      id: null,
      status: null,
      order: null,
      pizzaFlavor: null,
      price: price, // Asigna el precio calculado
      orderItemUpdates: [],
    );

    // Obtener el OrderCreationBloc y enviar el evento para añadir el OrderItem
    BlocProvider.of<OrderCreationBloc>(context)
        .add(AddOrderItem(orderItem: orderItem));

    // Muestra un SnackBar de confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Producto añadido con éxito'),
        duration: Duration(milliseconds: 1500),
      ),
    );

    // Opcional: Navegar de regreso o realizar otra acción
    Navigator.pop(context);
  }

  Widget _buildVariantSelector(List<ProductVariant> variants) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Variantes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        for (var variant in variants)
          ListTile(
            title: Text(variant.name),
            trailing: Text('\$${variant.price.toStringAsFixed(2)}'),
            selected: selectedVariant == variant,
            selectedTileColor: Color.fromARGB(255, 33, 66,
                82), // Cambia el color de fondo cuando está seleccionado
            onTap: () {
              setState(() {
                selectedVariant = variant;
              });
            },
          ),
      ],
    );
  }

  Widget _buildModifierTypeSection(ModifierType modifierType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(modifierType.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ...(modifierType.modifiers?.map((modifier) => CheckboxListTile(
                  title: Text(modifier.name),
                  subtitle: Text('\$${modifier.price.toStringAsFixed(2)}'),
                  value: selectedModifiers.any((selectedModifier) =>
                      selectedModifier.modifier == modifier),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        if (!modifierType.acceptsMultiple) {
                          selectedModifiers.removeWhere((selectedModifier) =>
                              modifierType.modifiers!
                                  .contains(selectedModifier.modifier));
                        }
                        selectedModifiers
                            .add(SelectedModifier(modifier: modifier));
                      } else {
                        selectedModifiers.removeWhere((selectedModifier) =>
                            selectedModifier.modifier == modifier);
                      }
                    });
                  },
                )) ??
            []),
      ],
    );
  }

  Widget _buildObservationTypeSection(ProductObservationType observationType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(observationType.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ...(observationType.productObservations?.map((productObservation) =>
                CheckboxListTile(
                  title: Text(productObservation.name),
                  value: selectedObservations.any((selectedObservation) =>
                      selectedObservation.productObservation ==
                      productObservation),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        if (!observationType.acceptsMultiple) {
                          selectedObservations.removeWhere(
                              (selectedObservation) =>
                                  observationType.productObservations!.contains(
                                      selectedObservation.productObservation));
                        }
                        selectedObservations.add(SelectedProductObservation(
                            productObservation: productObservation));
                      } else {
                        selectedObservations.removeWhere(
                            (selectedObservation) =>
                                selectedObservation.productObservation ==
                                productObservation);
                      }
                    });
                  },
                )) ??
            []),
      ],
    );
  }
}
