import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/utils/Resource.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/ProductPersonalizationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationEvent.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationState.dart';
import 'package:uuid/uuid.dart';

class ProductSelectionPage extends StatelessWidget {
  const ProductSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderCreationBloc bloc = BlocProvider.of<OrderCreationBloc>(context);

    return Scaffold(
      body: BlocBuilder<OrderCreationBloc, OrderCreationState>(
        builder: (context, state) {
          if (state.categories != null && state.categories!.isNotEmpty) {
            return Column(
              children: [
                Expanded(
                  flex: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: state.categories!.map((category) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: AspectRatio(
                            aspectRatio: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                bloc.add(
                                    CategorySelected(categoryId: category.id));
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(category.name,
                                  style: TextStyle(fontSize: 40)),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: state.selectedCategoryId != null
                      ? _buildContentBasedOnSelection(bloc, state)
                      : Container(),
                ),
              ],
            );
          } else if (state.response is Loading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(child: Text('No se encontraron categorías'));
          }
        },
      ),
    );
  }

  Widget _buildContentBasedOnSelection(
      OrderCreationBloc bloc, OrderCreationState state) {
    if (state.selectedSubcategoryId != null &&
        state.filteredProducts != null &&
        state.filteredProducts!.isNotEmpty) {
      // Muestra productos si una subcategoría está seleccionada y hay productos disponibles
      return _buildProductButtons(bloc, state);
    } else {
      // De lo contrario, muestra subcategorías
      return _buildSubcategoryButtons(bloc, state);
    }
  }

  Widget _buildSubcategoryButtons(
      OrderCreationBloc bloc, OrderCreationState state) {
    if (state.filteredSubcategories != null &&
        state.filteredSubcategories!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 20,
          ),
          itemCount: state.filteredSubcategories!.length,
          itemBuilder: (context, index) {
            final subcategory = state.filteredSubcategories![index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  bloc.add(SubcategorySelected(subcategoryId: subcategory.id));
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(subcategory.name, style: TextStyle(fontSize: 26)),
              ),
            );
          },
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildProductButtons(
      OrderCreationBloc bloc, OrderCreationState state) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: state.filteredProducts!.length,
      itemBuilder: (context, index) {
        final product = state.filteredProducts![index];
        final hasImage =
            product.imageUrl != null && product.imageUrl!.isNotEmpty;

        return InkWell(
          onTap: () {
            bool requiresPersonalization =
                (product.productVariants?.isNotEmpty ?? false) ||
                    (product.modifierTypes?.isNotEmpty ?? false) ||
                    (product.productObservationTypes?.isNotEmpty ?? false) ||
                    (product.pizzaFlavors?.isNotEmpty ?? false) ||
                    (product.pizzaIngredients?.isNotEmpty ?? false);
            print(product.subcategory?.name);
            if (!requiresPersonalization) {
              final tempId = Uuid().v4();

              final orderItem = OrderItem(
                tempId: tempId, // Asigna el nuevo tempId generado
                product: product,
                id: null,
                status: OrderItemStatus.created,
                comments: null,
                order: null,
                productVariant: null,
                selectedModifiers: [],
                selectedProductObservations: [],
                selectedPizzaFlavors: [],
                selectedPizzaIngredients: [],
                price: product.price,
                orderItemUpdates: [],
              );

              bloc.add(AddOrderItem(orderItem: orderItem));

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Producto agregado'),
                  duration: Duration(milliseconds: 300),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProductPersonalizationPage(product: product)),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200], // Fondo para productos sin imagen
            ),
            child: Stack(
              alignment: Alignment
                  .bottomCenter, // Alinea el texto en la parte inferior de la imagen
              children: [
                if (hasImage)
                  Image.asset(
                    product.imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback al nombre del producto si la imagen no se puede cargar
                      return Center(
                        child: Text(
                          product.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color.fromARGB(221, 112, 71, 71),
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                Container(
                  // Agrega un degradado para mejorar la legibilidad del texto sobre la imagen
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(
                      8.0), // Un poco de padding para el texto
                  child: Text(
                    product.name,
                    style: TextStyle(
                      color: Colors.white, // Color blanco para contraste
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow
                        .ellipsis, // Asegura que el texto no sobrepase el espacio disponible
                  ),
                ),
              ],
            ),
          ),
        );
      },
      shrinkWrap: true,
    );
  }
}
