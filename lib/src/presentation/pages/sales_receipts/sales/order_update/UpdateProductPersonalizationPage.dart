import 'package:app/src/domain/models/ModifierType.dart';
import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/models/PizzaFlavor.dart';
import 'package:app/src/domain/models/PizzaIngredient.dart';
import 'package:app/src/domain/models/Product.dart';
import 'package:app/src/domain/models/ProductObservationType.dart';
import 'package:app/src/domain/models/ProductVariant.dart';
import 'package:app/src/domain/models/SelectedModifier.dart';
import 'package:app/src/domain/models/SelectedPizzaFlavor.dart';
import 'package:app/src/domain/models/SelectedPizzaIngredient.dart';
import 'package:app/src/domain/models/SelectedProductObservation.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_update/bloc/OrderUpdateBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_update/bloc/OrderUpdateEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class UpdateProductPersonalizationPage extends StatefulWidget {
  final Product product;
  final OrderItem? existingOrderItem;

  const UpdateProductPersonalizationPage(
      {Key? key, required this.product, this.existingOrderItem})
      : super(key: key);

  @override
  _UpdateProductPersonalizationPageState createState() =>
      _UpdateProductPersonalizationPageState();
}

class _UpdateProductPersonalizationPageState
    extends State<UpdateProductPersonalizationPage> {
  ProductVariant? selectedVariant;
  List<SelectedModifier> selectedModifiers = [];
  List<SelectedProductObservation> selectedObservations = [];
  List<SelectedPizzaIngredient> selectedPizzaIngredients = [];
  List<SelectedPizzaFlavor> selectedPizzaFlavors = [];
  String? comments;
  bool _showPizzaIngredients = false;
  bool _showPizzaModifiers = false;
  bool _createTwoHalves = false;

  @override
  void initState() {
    super.initState();

    if (widget.existingOrderItem != null) {
      selectedVariant = widget.existingOrderItem!.productVariant;
      selectedModifiers =
          List.from(widget.existingOrderItem?.selectedModifiers ?? []);
      selectedObservations = List.from(
          widget.existingOrderItem?.selectedProductObservations ?? []);
      selectedPizzaFlavors =
          List.from(widget.existingOrderItem?.selectedPizzaFlavors ?? []);
      selectedPizzaIngredients =
          List.from(widget.existingOrderItem?.selectedPizzaIngredients ?? []);
      comments = widget.existingOrderItem!.comments;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verifica si el producto es una pizza
    bool isPizza = widget.product.pizzaFlavors != null &&
        widget.product.pizzaFlavors!.isNotEmpty &&
        widget.product.pizzaIngredients != null &&
        widget.product.pizzaIngredients!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: selectedVariant != null ? _saveOrderItem : null,
          ),
          if (widget.existingOrderItem != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteOrderItem,
            ),
        ],
      ),
      body: ListView(
        children: [
          // Muestra el switch solo si el producto es una pizza
          if (isPizza)
            SwitchListTile(
              title: Text('Armar pizza',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              value: _showPizzaIngredients,
              onChanged: (bool value) {
                setState(() {
                  _showPizzaIngredients = value;
                  if (value) {
                    _showPizzaModifiers =
                        false; // Desactiva "Modificar sabores"
                    selectedPizzaFlavors
                        .clear(); // Borra los sabores de pizza seleccionados
                    selectedModifiers
                        .clear(); // Borra todos los modificadores seleccionados
                  } else {
                    // Aquí se agrega la lógica para borrar los ingredientes cuando se deselecciona "Armar pizza"
                    selectedPizzaIngredients
                        .clear(); // Borra los ingredientes de pizza seleccionados
                  }
                });
              },
            ),
          if (isPizza && _showPizzaIngredients)
            SwitchListTile(
              title: Text('Crear dos mitades',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              value: _createTwoHalves,
              onChanged: (bool value) {
                setState(() {
                  _createTwoHalves = value;
                  // Al activar o desactivar, reinicia los ingredientes seleccionados
                  selectedPizzaIngredients.clear();
                });
              },
            ),

          if (isPizza && !_showPizzaIngredients)
            SwitchListTile(
              title: Text('Modificar sabores',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              value: _showPizzaModifiers,
              onChanged: (bool value) {
                setState(() {
                  _showPizzaModifiers = value;
                  if (!value) {
                    selectedModifiers.clear(); // Vacía todos los modificadores
                  }
                });
              },
            ),

          if (widget.product.productVariants != null)
            _buildVariantSelector(widget.product.productVariants!),
          // Muestra los sabores de pizza solo si el producto es una pizza y _showPizzaIngredients es falso
          if (!_showPizzaIngredients && isPizza)
            _buildPizzaFlavorSelector(widget.product.pizzaFlavors!),
          // Muestra los ingredientes de pizza solo si el producto es una pizza y _showPizzaIngredients es verdadero
          if (_showPizzaIngredients && isPizza)
            _buildPizzaIngredientSelector(widget.product.pizzaIngredients!),
          if (widget.product.modifierTypes != null)
            ...widget.product.modifierTypes!
                .map(_buildModifierTypeSection)
                .toList(),
          if (widget.product.productObservationTypes != null)
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
              initialValue:
                  comments, // Inicializa con el comentario existente si lo hay
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

    // Genera un nuevo tempId si es un nuevo OrderItem, de lo contrario, usa el existente
    final tempId = widget.existingOrderItem?.tempId ?? Uuid().v4();

    if (widget.existingOrderItem != null) {
      // Actualizar el OrderItem existente
      final updatedOrderItem = widget.existingOrderItem!.copyWith(
        tempId: tempId, // Asegúrate de pasar el tempId existente
        productVariant: selectedVariant,
        selectedModifiers: selectedModifiers,
        selectedProductObservations: selectedObservations,
        selectedPizzaFlavors: selectedPizzaFlavors,
        selectedPizzaIngredients: selectedPizzaIngredients,
        comments: comments,
        price: price,
      );

      // Envía el evento de actualización a tu Bloc
      BlocProvider.of<OrderUpdateBloc>(context)
          .add(UpdateOrderItem(orderItem: updatedOrderItem));
    } else {
      // Creación del OrderItem con los datos necesarios, incluyendo el precio calculado
      final orderItem = OrderItem(
        tempId: tempId, // Usa el nuevo tempId generado
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
        selectedPizzaFlavors: selectedPizzaFlavors
            .map((selectedPizzaFlavor) => SelectedPizzaFlavor(
                pizzaFlavor: selectedPizzaFlavor.pizzaFlavor))
            .toList(),
        selectedPizzaIngredients: selectedPizzaIngredients
            .map((selectedPizzaIngredient) => SelectedPizzaIngredient(
                pizzaIngredient: selectedPizzaIngredient.pizzaIngredient))
            .toList(),
        comments: comments,
        id: null,
        status: OrderItemStatus.created,
        order: null,
        price: price, // Asigna el precio calculado
        orderItemUpdates: [],
      );

      // Obtener el OrderCreationBloc y enviar el evento para añadir el OrderItem
      BlocProvider.of<OrderUpdateBloc>(context)
          .add(AddOrderItem(orderItem: orderItem));
    }

    // Muestra un SnackBar de confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Producto ${widget.existingOrderItem != null ? 'actualizado' : 'añadido'} con éxito'),
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
            selected: selectedVariant?.id ==
                variant.id, // Compara por ID o algún otro campo único
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

  void _deleteOrderItem() {
    // Obtiene el tempId del OrderItem existente
    final String tempId = widget.existingOrderItem!.tempId;

    // Utiliza el Bloc para disparar el evento RemoveOrderItem
    BlocProvider.of<OrderUpdateBloc>(context)
        .add(RemoveOrderItem(tempId: tempId));

    // Muestra un SnackBar como confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Producto eliminado con éxito'),
        duration: Duration(seconds: 1),
      ),
    );

    // Navega de regreso o realiza otra acción después de eliminar el item
    Navigator.pop(context);
  }

  Widget _buildModifierTypeSection(ModifierType modifierType) {
    bool isPizza = widget.product.pizzaFlavors != null &&
        widget.product.pizzaFlavors!.isNotEmpty &&
        widget.product.pizzaIngredients != null &&
        widget.product.pizzaIngredients!.isNotEmpty;

    bool shouldShowModifier = false;
    if (isPizza) {
      if (_showPizzaModifiers) {
        // Asegúrate de que el switch para modificadores esté activado
        if (selectedPizzaFlavors.length == 2) {
          shouldShowModifier = modifierType.name == 'Añadir en mitad 1' ||
              modifierType.name == 'Añadir en mitad 2' ||
              modifierType.name == 'Quitar en mitad 1' ||
              modifierType.name == 'Quitar en mitad 2';
        } else if (selectedPizzaFlavors.length == 1) {
          shouldShowModifier =
              modifierType.name == 'Añadir' || modifierType.name == 'Quitar';
        }
      }
    } else {
      shouldShowModifier = true;
    }

    if (!shouldShowModifier) {
      return Container();
    }

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
                      selectedModifier.modifier?.id ==
                      modifier.id), // Compara por ID
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        if (!modifierType.acceptsMultiple) {
                          // Elimina otros modificadores del mismo tipo si no se aceptan múltiples
                          selectedModifiers.removeWhere((selectedModifier) =>
                              modifierType.modifiers!.any((m) =>
                                  m.id == selectedModifier.modifier?.id));
                        }
                        selectedModifiers
                            .add(SelectedModifier(modifier: modifier));
                      } else {
                        selectedModifiers.removeWhere((selectedModifier) =>
                            selectedModifier.modifier?.id == modifier.id);
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
                ?.map((productObservation) => CheckboxListTile(
                      title: Text(productObservation.name),
                      value: selectedObservations.any((selectedObservation) =>
                          selectedObservation.productObservation?.id ==
                          productObservation.id), // Compara por ID
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            if (!observationType.acceptsMultiple) {
                              // Si no se aceptan múltiples, primero elimina las observaciones existentes del mismo tipo
                              selectedObservations.removeWhere(
                                  (selectedObservation) => observationType
                                      .productObservations!
                                      .any((po) =>
                                          po.id ==
                                          selectedObservation
                                              .productObservation?.id));
                            }
                            selectedObservations.add(SelectedProductObservation(
                                productObservation: productObservation));
                          } else {
                            selectedObservations.removeWhere(
                                (selectedObservation) =>
                                    selectedObservation
                                        .productObservation?.id ==
                                    productObservation.id);
                          }
                        });
                      },
                    )) ??
            []),
      ],
    );
  }

  Widget _buildPizzaFlavorSelector(List<PizzaFlavor> flavors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!_showPizzaIngredients) ...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Sabores de Pizza (2 máximo)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ...flavors.map((flavor) => CheckboxListTile(
                title: Text(flavor.name),
                value: selectedPizzaFlavors.any((selectedFlavor) =>
                    selectedFlavor.pizzaFlavor?.id ==
                    flavor.id), // Compara por ID
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      if (selectedPizzaFlavors.length < 2) {
                        selectedPizzaFlavors
                            .add(SelectedPizzaFlavor(pizzaFlavor: flavor));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Solo puedes seleccionar hasta 2 sabores.'),
                          ),
                        );
                      }
                    } else {
                      selectedPizzaFlavors.removeWhere((selectedFlavor) =>
                          selectedFlavor.pizzaFlavor?.id == flavor.id);
                    }
                    // Reiniciar los modificadores cada vez que se hace una selección de sabores
                    selectedModifiers.clear();
                  });
                },
              )),
        ],
      ],
    );
  }

  Widget _buildPizzaIngredientSelector(List<PizzaIngredient> ingredients) {
    Widget buildIngredientList(PizzaHalf half) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: ingredients
            .map((ingredient) => CheckboxListTile(
                  title: Text(ingredient.name),
                  value: selectedPizzaIngredients.any((selectedIngredient) =>
                      selectedIngredient.pizzaIngredient?.id ==
                          ingredient.id && // Compara por ID
                      selectedIngredient.half == half),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedPizzaIngredients.add(SelectedPizzaIngredient(
                            pizzaIngredient: ingredient, half: half));
                      } else {
                        selectedPizzaIngredients.removeWhere(
                            (selectedIngredient) =>
                                selectedIngredient.pizzaIngredient?.id ==
                                    ingredient.id && // Compara por ID
                                selectedIngredient.half == half);
                      }
                    });
                  },
                ))
            .toList(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Ingredientes de Pizza',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        if (!_createTwoHalves) buildIngredientList(PizzaHalf.none),
        if (_createTwoHalves) ...[
          Text('Primera mitad:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          buildIngredientList(PizzaHalf.left),
          Text('Segunda mitad:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          buildIngredientList(PizzaHalf.right),
        ],
      ],
    );
  }
}
