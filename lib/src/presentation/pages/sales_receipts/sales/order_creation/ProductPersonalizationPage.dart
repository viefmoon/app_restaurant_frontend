import 'package:app/src/domain/models/Category.dart';
import 'package:app/src/domain/models/Modifier.dart';
import 'package:app/src/domain/models/ModifierType.dart';
import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/models/Product.dart';
import 'package:app/src/domain/models/ProductObservation.dart';
import 'package:app/src/domain/models/ProductObservationType.dart';
import 'package:app/src/domain/models/ProductVariant.dart';
import 'package:app/src/domain/models/SelectedModifier.dart';
import 'package:app/src/domain/utils/Resource.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductPersonalizationPage extends StatefulWidget {
  final Product product;

  ProductPersonalizationPage({Key? key, required this.product})
      : super(key: key);

  @override
  _ProductPersonalizationPageState createState() =>
      _ProductPersonalizationPageState();
}

class _ProductPersonalizationPageState
    extends State<ProductPersonalizationPage> {
  ProductVariant? selectedVariant;
  List<Modifier> selectedModifiers = [];
  List<ProductObservation> selectedObservations = [];
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
    if (selectedVariant == null) {
      // Muestra un mensaje de error o realiza alguna acción si la variante no está seleccionada
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Por favor, selecciona una variante del producto')),
      );
      return;
    }

    // Creación del OrderItem con los datos necesarios, incluyendo variantes, modificadores, observaciones y comentarios
    final orderItem = OrderItem(
      product: widget.product,
      productVariant: selectedVariant,
      selectedModifiers: selectedModifiers
          .map((modifier) =>
              SelectedModifier(modifierId: modifier.id, name: modifier.name))
          .toList(),
      selectedProductObservations: selectedObservations
          .map((observation) => SelectedProductObservation(
              observationId: observation.id, name: observation.name))
          .toList(),
      comments: comments,
      // Añade los demás campos necesarios
      id: null,
      status: null,
      order: null,
      pizzaFlavor: null,
      orderItemUpdates: [],
    );

    // Obtener el OrderCreationBloc y enviar el evento para añadir el OrderItem
    BlocProvider.of<OrderCreationBloc>(context)
        .add(AddOrderItem(orderItem: orderItem));

    // Opcional: Navegar de regreso o mostrar un mensaje de confirmación
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
                  value: selectedModifiers.contains(modifier),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        if (!modifierType.acceptsMultiple) {
                          selectedModifiers.removeWhere(
                              (m) => modifierType.modifiers!.contains(m));
                        }
                        selectedModifiers.add(modifier);
                      } else {
                        selectedModifiers.remove(modifier);
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
        ...(observationType.productObservations
                ?.map((observation) => CheckboxListTile(
                      title: Text(observation.name),
                      value: selectedObservations.contains(observation),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            if (!observationType.acceptsMultiple) {
                              selectedObservations.removeWhere((m) =>
                                  observationType.productObservations!
                                      .contains(m));
                            }
                            selectedObservations.add(observation);
                          } else {
                            selectedObservations.remove(observation);
                          }
                        });
                      },
                    )) ??
            []),
      ],
    );
  }
}
