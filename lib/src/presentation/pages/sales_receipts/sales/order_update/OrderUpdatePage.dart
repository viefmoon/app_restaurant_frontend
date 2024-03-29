import 'package:app/src/domain/models/OrderAdjustment.dart';
import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/models/Product.dart';
import 'package:app/src/domain/models/SelectedPizzaIngredient.dart';
import 'package:app/src/domain/utils/Resource.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_update/AddProductPage.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_update/UpdateProductPersonalizationPage.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_update/bloc/OrderUpdateState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_update/bloc/OrderUpdateBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_update/bloc/OrderUpdateEvent.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class OrderUpdatePage extends StatefulWidget {
  const OrderUpdatePage({Key? key}) : super(key: key);

  @override
  _OrderUpdatePageState createState() => _OrderUpdatePageState();
}

final Map<OrderType, String> _orderTypeTranslations = {
  OrderType.dineIn: 'Comer Dentro',
  OrderType.delivery: 'Entrega a domicilio',
  OrderType.pickUpWait: 'Llevar/Esperar',
};

class _OrderUpdatePageState extends State<OrderUpdatePage> {
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _customerNameController;
  late TextEditingController _commentsController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: "");
    _addressController = TextEditingController(text: "");
    _customerNameController = TextEditingController(text: "");
    _commentsController = TextEditingController(text: "");

    // Emitir el evento para cargar las categorías al iniciar la página
    BlocProvider.of<OrderUpdateBloc>(context, listen: false)
        .add(LoadCategoriesWithProducts());
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    _customerNameController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        // Si didPop es true, significa que el sistema está intentando hacer pop de la página.
        if (didPop) {
          // No se necesita hacer nada aquí si didPop es true, porque el pop ya está en proceso.
          return;
        }

        // Mostrar el diálogo de confirmación solo si didPop es false, es decir, cuando el pop no se ha iniciado aún.
        final bool? shouldPop = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirmación', style: TextStyle(fontSize: 24)),
            content: Text(
                '¿Estás seguro de que deseas salir? Si hay cambios no guardados se perderán.',
                style: TextStyle(fontSize: 20)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancelar', style: TextStyle(fontSize: 18)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Salir', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        );
        // Si el usuario confirma que quiere salir, permitir el pop.
        if (shouldPop == true) {
          BlocProvider.of<OrderUpdateBloc>(context)
              .add(ResetOrderUpdateState());
          Navigator.of(context).pop();
        }
      },
      child: BlocListener<OrderUpdateBloc, OrderUpdateState>(
        listener: (context, state) {
          if (state.response is Success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Orden actualizada con éxito',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.green,
                duration: Duration(milliseconds: 800),
              ),
            );
            BlocProvider.of<OrderUpdateBloc>(context)
              ..add(ResetResponseEvent())
              ..add(ResetOrderUpdateState());
          } else if (state.response is Error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  (state.response as Error).message,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
            BlocProvider.of<OrderUpdateBloc>(context)
              ..add(ResetResponseEvent())
              ..add(ResetOrderUpdateState());
          }
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: BlocBuilder<OrderUpdateBloc, OrderUpdateState>(
              builder: (context, state) {
                return _buildAppBar(context, state);
              },
            ),
          ),
          body: BlocBuilder<OrderUpdateBloc, OrderUpdateState>(
            builder: (context, state) {
              if (state.response is Loading) {
                return Center(child: CircularProgressIndicator());
              } else {
                return _buildBody(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, OrderUpdateState state) {
    return AppBar(
      title: Text('Resumen Orden #${state.orderIdSelectedForUpdate ?? ''}'),
      actions: [
        IconButton(
          icon: Icon(Icons.near_me, size: 30),
          onPressed: () => _selectPrinter(context),
        ),
        IconButton(
          icon: Icon(Icons.print, size: 30),
          onPressed: () => _printTicket(context, state),
        ),
        SizedBox(width: 30), // Añade un espaciado aquí
        IconButton(
          icon: Icon(Icons.save, size: 30),
          onPressed: () => _updateOrder(context, state),
        ),
        PopupMenuButton<String>(
          onSelected: (String result) {
            if (result == 'cancel_order') {
              _cancelOrder(context, state);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'cancel_order',
              child: Text('Cancelar Orden'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<OrderUpdateBloc, OrderUpdateState>(
      builder: (context, state) {
        _phoneController.text = state.phoneNumber ?? "";
        _addressController.text = state.deliveryAddress ?? "";
        _customerNameController.text = state.customerName ?? "";
        _commentsController.text = state.comments ?? "";

        List<Widget> headerDetails = [];
        headerDetails.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Tipo de Pedido',
              contentPadding:
                  EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.green, width: 2.0),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<OrderType>(
                value: state.selectedOrderType,
                isExpanded: true,
                onChanged: (OrderType? newValue) {
                  if (newValue != null) {
                    BlocProvider.of<OrderUpdateBloc>(context)
                        .add(OrderTypeSelected(selectedOrderType: newValue));
                  }
                },
                items: OrderType.values.map((OrderType type) {
                  return DropdownMenuItem<OrderType>(
                    value: type,
                    child:
                        Text(_orderTypeTranslations[type] ?? type.toString()),
                  );
                }).toList(),
              ),
            ),
          ),
        ));

        switch (state.selectedOrderType) {
          case OrderType.dineIn:
            if (state.selectedOrderType == OrderType.dineIn &&
                state.areas != null) {
              headerDetails.add(_buildAreaDropdown(context, state));
            }

            // Añadir Dropdown para Mesa si el área está seleccionada
            if (state.selectedOrderType == OrderType.dineIn &&
                state.selectedAreaId != null &&
                state.tables != null) {
              headerDetails.add(_buildTableDropdown(context, state));
            }
            break;
          case OrderType.delivery:
            // Usar el _phoneController para el campo de teléfono
            headerDetails.add(Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical:
                      10.0), // Reducir el margen vertical para hacerlo menos ancho
              child: TextField(
                controller:
                    _phoneController, // Usar el controlador inicializado
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  hintText: 'Ingresa el número de teléfono',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.green,
                      width: 2.0,
                    ),
                  ),
                ),
                onChanged: (value) {
                  BlocProvider.of<OrderUpdateBloc>(context).add(
                    PhoneNumberEntered(phoneNumber: value),
                  );
                },
              ),
            ));
            headerDetails.add(Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Dirección',
                  hintText: 'Ingresa la dirección de entrega',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                ),
                onChanged: (value) {
                  BlocProvider.of<OrderUpdateBloc>(context)
                      .add(DeliveryAddressEntered(deliveryAddress: value));
                },
              ),
            ));
            break;
          case OrderType.pickUpWait:
            headerDetails.add(Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: TextField(
                controller: _customerNameController,
                decoration: InputDecoration(
                  labelText: 'Nombre del Cliente',
                  hintText: 'Ingresa el nombre del cliente',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.green,
                      width: 2.0,
                    ),
                  ),
                ),
                onChanged: (value) {
                  BlocProvider.of<OrderUpdateBloc>(context).add(
                    CustomerNameEntered(customerName: value),
                  );
                },
              ),
            ));
            headerDetails.add(Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical:
                      10.0), // Reducir el margen vertical para hacerlo menos ancho
              child: TextField(
                controller:
                    _phoneController, // Usar el controlador inicializado
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  hintText: 'Ingresa el número de teléfono',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.green,
                      width: 2.0,
                    ),
                  ),
                ),
                onChanged: (value) {
                  BlocProvider.of<OrderUpdateBloc>(context).add(
                    PhoneNumberEntered(phoneNumber: value),
                  );
                },
              ),
            ));
            break;
          default:
            break;
        }
        // Añadir campo de comentarios debajo de todos los detalles de la cabecera
        headerDetails.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: TextField(
            controller: _commentsController,
            decoration: InputDecoration(
              labelText: 'Comentarios',
              hintText: 'Ingresa comentarios sobre la orden',
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.green, width: 2.0),
              ),
            ),
            onChanged: (value) {
              BlocProvider.of<OrderUpdateBloc>(context)
                  .add(OrderCommentsEntered(comments: value));
            },
          ),
        ));
        headerDetails.add(BlocBuilder<OrderUpdateBloc, OrderUpdateState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2, // Ajusta la proporción si es necesario
                  child: Switch(
                    value: state.isTimePickerEnabled ?? false,
                    onChanged: (bool value) {
                      // Envía el evento para habilitar/deshabilitar el TimePicker
                      BlocProvider.of<OrderUpdateBloc>(context)
                          .add(TimePickerEnabled(isTimePickerEnabled: value));
                    },
                  ),
                ),
                Expanded(
                  flex: 8, // Ajusta la proporción si es necesario
                  child: ListTile(
                    title: Text('Seleccionar hora programada'),
                    subtitle: Text(
                      (state.isTimePickerEnabled ?? false) &&
                              state.scheduledDeliveryTime != null
                          ? state.scheduledDeliveryTime!.format(context)
                          : 'No seleccionada',
                    ),
                    leading: Icon(Icons.access_time, size: 30),
                    onTap: state.isTimePickerEnabled ?? false
                        ? () => _selectTime(context)
                        : null, // Asegúrate de que onTap permita la selección de la hora solo si isTimePickerEnabled es true
                  ),
                ),
              ],
            );
          },
        ));

        int headerCount =
            headerDetails.length; // Número de elementos en el encabezado
        int orderItemsCount =
            state.orderItems?.length ?? 0; // Número de OrderItems
        int orderAdjustmentsCount = state.orderAdjustments?.length ?? 0;

        return ListView.builder(
          itemCount: headerCount +
              orderItemsCount +
              orderAdjustmentsCount +
              3, // Añade +3 para incluir el total y el botón de enviar
          itemBuilder: (context, index) {
            if (index < headerCount) {
              // Devuelve el widget de encabezado correspondiente
              return headerDetails[index];
            } else if (index < headerCount + orderItemsCount) {
              // Devuelve el widget de OrderItem correspondiente
              final orderItemIndex = index - headerCount;
              final orderItem = state.orderItems![orderItemIndex];

              List<Widget> details = [];

              Color textColor = Colors.white;
              switch (orderItem.status) {
                case OrderItemStatus.created:
                  textColor = Colors.white;
                  break;
                case OrderItemStatus.in_preparation:
                  textColor = Colors.blue;
                  break;
                case OrderItemStatus.prepared:
                  textColor = Colors.orange;
                  break;
                default:
                  textColor = Colors.white;
              }

              if (orderItem.productVariant != null) {
                details.add(Text(
                  'Variante: ${orderItem.productVariant?.name}',
                  style: TextStyle(color: textColor),
                ));
              }
              if (orderItem.selectedModifiers != null &&
                  orderItem.selectedModifiers!.isNotEmpty) {
                details.add(Text(
                  'Modificadores: ${orderItem.selectedModifiers!.map((m) => m.modifier?.name).join(', ')}',
                  style: TextStyle(color: textColor),
                ));
              }
              if (orderItem.selectedPizzaFlavors != null &&
                  orderItem.selectedPizzaFlavors!.isNotEmpty) {
                details.add(Text(
                  'Sabor: ${orderItem.selectedPizzaFlavors!.map((f) => f.pizzaFlavor?.name).join('/')}',
                  style: TextStyle(color: textColor),
                ));
              }
              if (orderItem.selectedPizzaIngredients != null &&
                  orderItem.selectedPizzaIngredients!.isNotEmpty) {
                final ingredientsLeft = orderItem.selectedPizzaIngredients!
                    .where((i) => i.half == PizzaHalf.left)
                    .map((i) => i.pizzaIngredient?.name)
                    .join(', ');
                final ingredientsRight = orderItem.selectedPizzaIngredients!
                    .where((i) => i.half == PizzaHalf.right)
                    .map((i) => i.pizzaIngredient?.name)
                    .join(', ');
                final ingredientsNone = orderItem.selectedPizzaIngredients!
                    .where((i) => i.half == PizzaHalf.none)
                    .map((i) => i.pizzaIngredient?.name)
                    .join(', ');

                String ingredientsText = '';
                if (ingredientsLeft.isNotEmpty) {
                  ingredientsText += 'Mitad 1: $ingredientsLeft';
                }
                if (ingredientsRight.isNotEmpty) {
                  if (ingredientsText.isNotEmpty) ingredientsText += ' | ';
                  ingredientsText += 'Mitad 2: $ingredientsRight';
                }
                if (ingredientsNone.isNotEmpty) {
                  if (ingredientsText.isNotEmpty) ingredientsText += ' | ';
                  ingredientsText += 'Completa: $ingredientsNone';
                }

                details.add(Text(
                  'Ingredientes: $ingredientsText',
                  style: TextStyle(color: textColor),
                ));
              }
              if (orderItem.selectedProductObservations != null &&
                  orderItem.selectedProductObservations!.isNotEmpty) {
                details.add(Text(
                  'Observaciones: ${orderItem.selectedProductObservations!.map((o) => o.productObservation?.name).join(', ')}',
                  style: TextStyle(color: textColor),
                ));
              }
              if (orderItem.comments != null &&
                  orderItem.comments!.isNotEmpty) {
                details.add(Text(
                  'Comentarios: ${orderItem.comments}',
                  style: TextStyle(color: textColor),
                ));
              }

              return InkWell(
                onTap: () {
                  final orderItemStatus = orderItem.status;
                  switch (orderItemStatus) {
                    case OrderItemStatus.created:
                      // Buscar el producto por ID en las categorías cargadas en el estado
                      Product? foundProduct;
                      for (var category in state.categories!) {
                        for (var subcategory in category.subcategories ?? []) {
                          for (var product in subcategory.products ?? []) {
                            if (product.id == orderItem.product!.id) {
                              foundProduct = product;
                              break;
                            }
                          }
                          if (foundProduct != null) break;
                        }
                        if (foundProduct != null) break;
                      }

                      // Asumiendo que siempre se encuentra el producto, redirige a la página de personalización
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UpdateProductPersonalizationPage(
                            product:
                                foundProduct!, // Aquí se asume que el producto siempre se encuentra
                            existingOrderItem: orderItem,
                          ),
                        ),
                      );
                      break;
                    case OrderItemStatus.in_preparation:
                      // Muestra un diálogo para confirmar si desea actualizar un producto en preparación
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirmación"),
                            content: Text(
                                "Este producto está en preparación. ¿Deseas actualizarlo?"),
                            actions: <Widget>[
                              TextButton(
                                child: Text("Cancelar"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text("Actualizar"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // Buscar el producto por ID
                                  Product? foundProduct;
                                  for (var category in state.categories!) {
                                    for (var subcategory
                                        in category.subcategories ?? []) {
                                      for (var product
                                          in subcategory.products ?? []) {
                                        if (product.id ==
                                            orderItem.product!.id) {
                                          foundProduct = product;
                                          break;
                                        }
                                      }
                                      if (foundProduct != null) break;
                                    }
                                    if (foundProduct != null) break;
                                  }

                                  // Asumiendo que siempre se encuentra el producto, redirige a la página de personalización
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UpdateProductPersonalizationPage(
                                        product:
                                            foundProduct!, // Aquí se asume que el producto siempre se encuentra
                                        existingOrderItem: orderItem,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                      break;
                    case OrderItemStatus.prepared:
                      // No permite la redirección y muestra un mensaje
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Este producto ya está preparado y no puede ser modificado."),
                          duration: Duration(milliseconds: 700),
                        ),
                      );
                      break;
                    default:
                      // Manejo de otros estados si es necesario
                      break;
                  }
                },
                child: ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          orderItem.product?.name ?? '',
                          style: TextStyle(color: textColor),
                        ),
                      ),
                      Text('\$${orderItem.price?.toStringAsFixed(2) ?? ''}'),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: details,
                  ),
                ),
              );
            } else if (index <
                headerCount + orderItemsCount + orderAdjustmentsCount) {
              final adjustmentIndex = index - (headerCount + orderItemsCount);
              final adjustment = state.orderAdjustments![adjustmentIndex];
              return ListTile(
                title: Text(adjustment.name ?? ''),
                trailing: Text(
                    adjustment.amount! < 0
                        ? '-\$${(-adjustment.amount!).toStringAsFixed(2)}'
                        : '\$${adjustment.amount?.toStringAsFixed(2) ?? ''}',
                    style: TextStyle(
                      fontSize:
                          16.0, // Ajuste para igualar la fuente de los orderItems
                    )),
                onTap: () {
                  _showAddOrderAdjustmentDialog(context,
                      existingAdjustment: adjustment);
                },
              );
            } else if (index ==
                headerCount + orderItemsCount + orderAdjustmentsCount) {
              // Widget para mostrar el total
              return ListTile(
                title: Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 25.0, // Tamaño de letra más grande
                    fontStyle: FontStyle.italic, // Letra en cursiva
                  ),
                ),
                trailing: Text(
                  '\$${calculateTotal(state.orderItems, state.orderAdjustments).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 25.0, // Tamaño de letra más grande
                    fontStyle: FontStyle.italic, // Letra en cursiva
                  ),
                ),
              );
            } else if (index ==
                headerCount + orderItemsCount + orderAdjustmentsCount + 1) {
              // Botón para agregar un ajuste de orden
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () => _showAddOrderAdjustmentDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    textStyle: TextStyle(fontSize: 20),
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text('Agregar ajuste de orden'),
                ),
              );
            } else if (index ==
                headerCount + orderItemsCount + orderAdjustmentsCount + 2) {
              return _buildAddProductButton(context);
            }
            throw Exception('Índice inesperado: $index');
          },
        );
      },
    );
  }

  Widget _buildAddProductButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: ElevatedButton.icon(
        icon: Icon(Icons.add, size: 30.0), // Icono más grande
        label: Text('Agregar Productos',
            style: TextStyle(fontSize: 18.0)), // Texto más grande
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductPage()),
          );
        },
      ),
    );
  }

  void _updateOrder(BuildContext context, OrderUpdateState state) async {
    if (state.orderItems == null || state.orderItems!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,
          content: Text(
            'No se puede enviar la orden sin productos.',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          duration: Duration(seconds: 2),
        ),
      );
      return; // Salir del método para evitar enviar la orden
    }

    // Verificaciones adicionales basadas en el tipo de orden
    switch (state.selectedOrderType) {
      case OrderType.dineIn:
        if (state.selectedAreaId == null || state.selectedTableId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orange,
              content: Text(
                'Selecciona un área y una mesa para continuar.',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              duration: Duration(seconds: 2),
            ),
          );
          return; // Salir del método para evitar enviar la orden
        }
        break;
      case OrderType.delivery:
        if (state.deliveryAddress == null || state.deliveryAddress!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orange,
              content: Text(
                'La dirección de entrega es necesaria para continuar.',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              duration: Duration(seconds: 2),
            ),
          );
          return; // Salir del método para evitar enviar la orden
        }
        break;
      case OrderType.pickUpWait:
        if (state.customerName == null || state.customerName!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orange,
              content: Text(
                'El nombre del cliente es necesario para continuar.',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              duration: Duration(seconds: 2),
            ),
          );
          return; // Salir del método para evitar enviar la orden
        }
        break;
      default:
        break; // No se requieren verificaciones adicionales para otros tipos de orden
    }
    BlocProvider.of<OrderUpdateBloc>(context).add(UpdateOrder());
    Navigator.pop(context);
  }

  Widget _buildAreaDropdown(BuildContext context, OrderUpdateState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Área',
          contentPadding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.green, width: 2.0),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<int>(
            value: state.selectedAreaId,
            isExpanded: true,
            onChanged: (int? newValue) {
              if (newValue != null) {
                BlocProvider.of<OrderUpdateBloc>(context)
                    .add(AreaSelected(areaId: newValue));
              }
            },
            items: state.areas!.map<DropdownMenuItem<int>>((area) {
              return DropdownMenuItem<int>(
                value: area.id,
                child: Text(area.name!),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTableDropdown(BuildContext context, OrderUpdateState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Mesa',
          contentPadding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.green, width: 2.0),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<int>(
            value: state.tables
                        ?.any((table) => table.id == state.selectedTableId) ??
                    false
                ? state.selectedTableId
                : null,
            isExpanded: true,
            onChanged: (int? newValue) {
              if (newValue != null) {
                BlocProvider.of<OrderUpdateBloc>(context)
                    .add(TableSelected(tableId: newValue));
              }
            },
            items: state.tables?.map<DropdownMenuItem<int>>((table) {
                  return DropdownMenuItem<int>(
                    value: table.id,
                    child: Text(table.number.toString()),
                  );
                }).toList() ??
                [],
          ),
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      // Envía el evento TimeSelected con el tiempo elegido
      BlocProvider.of<OrderUpdateBloc>(context).add(TimeSelected(time: picked));
    }
  }

  double calculateTotal(
      List<OrderItem>? orderItems, List<OrderAdjustment>? orderAdjustments) {
    double itemsTotal = orderItems?.fold<double>(0.0,
            (double total, OrderItem item) => total + (item.price ?? 0.0)) ??
        0.0;
    double adjustmentsTotal = orderAdjustments?.fold<double>(
            0.0,
            (double total, OrderAdjustment adjustment) =>
                total + (adjustment.amount ?? 0.0)) ??
        0.0;
    return itemsTotal + adjustmentsTotal;
  }

  void _cancelOrder(BuildContext context, OrderUpdateState state) async {
    if (state.orderIdSelectedForUpdate != null) {
      final bool? shouldCancel = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Confirmación', style: TextStyle(fontSize: 24)),
          content: Text(
            '¿Estás seguro de que deseas cancelar esta orden?',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('No', style: TextStyle(fontSize: 18)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Sí', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      );

      if (shouldCancel == true) {
        BlocProvider.of<OrderUpdateBloc>(context).add(CancelOrder());
        Navigator.pop(context);
      }
    }
  }

  Future<void> _showAddOrderAdjustmentDialog(BuildContext context,
      {OrderAdjustment? existingAdjustment}) async {
    String? name = existingAdjustment?.name;
    String? amountString = existingAdjustment?.amount?.toString();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(existingAdjustment == null
              ? 'Agregar ajuste de orden'
              : 'Editar ajuste de orden'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Nombre'),
                onChanged: (value) {
                  name = value;
                },
                controller: TextEditingController(text: name),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  amountString = value;
                },
                controller: TextEditingController(text: amountString),
              ),
            ],
          ),
          actions: [
            if (existingAdjustment != null)
              TextButton(
                onPressed: () {
                  BlocProvider.of<OrderUpdateBloc>(context).add(
                    OrderAdjustmentRemoved(orderAdjustment: existingAdjustment),
                  );
                  Navigator.of(context).pop();
                },
                child: Text('Eliminar', style: TextStyle(color: Colors.red)),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (name != null && amountString != null) {
                  double? amount = double.tryParse(amountString!);
                  if (amount != null) {
                    BlocProvider.of<OrderUpdateBloc>(context).add(
                      existingAdjustment == null
                          ? OrderAdjustmentAdded(
                              orderAdjustment: OrderAdjustment(
                                name: name,
                                amount: amount,
                              ),
                            )
                          : OrderAdjustmentUpdated(
                              orderAdjustment: existingAdjustment.copyWith(
                                name: name,
                                amount: amount,
                              ),
                            ),
                    );
                    Navigator.of(context).pop();
                  }
                }
              },
              child:
                  Text(existingAdjustment == null ? 'Agregar' : 'Actualizar'),
            ),
          ],
        );
      },
    );
  }

  BluetoothDevice? _selectedPrinter;

// Función para seleccionar la impresora Bluetooth
  Future<void> _selectPrinter(BuildContext context) async {
    BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

    List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
    if (devices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se encontraron impresoras Bluetooth.'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    // Muestra un diálogo para seleccionar la impresora
    BluetoothDevice? selectedDevice = await showDialog<BluetoothDevice>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Seleccionar impresora'),
          content: SingleChildScrollView(
            child: ListBody(
              children: devices
                  .map((device) => RadioListTile(
                        title: Text(device.name ?? ''),
                        value: device,
                        groupValue: _selectedPrinter,
                        onChanged: (BluetoothDevice? value) {
                          Navigator.pop(context, value);
                        },
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );

    if (selectedDevice != null) {
      setState(() {
        _selectedPrinter = selectedDevice;
      });
    }
  }

  Future<void> _printTicket(
      BuildContext context, OrderUpdateState state) async {
    if (_selectedPrinter == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se ha seleccionado una impresora.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

    try {
      // Desconecta de la impresora si ya está conectado
      if (await bluetooth.isConnected ?? false) {
        await bluetooth.disconnect();
      }

      // Conecta con la impresora seleccionada
      await bluetooth.connect(_selectedPrinter!);

      // Agrega un retraso antes de imprimir
      await Future.delayed(Duration(milliseconds: 500));

      // Genera el contenido del ticket
      String ticketContent = _generateTicketContent(state);

      // Imprime el ticket
      await bluetooth.printCustom(ticketContent, 0, 1);

      // Desconecta de la impresora
      await bluetooth.disconnect();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ticket impreso correctamente.'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al imprimir el ticket: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  String _generateTicketContent(OrderUpdateState state) {
    String content = '';
    String cmdFontSizeLarge =
        "\x1d\x21\x12"; // Ajusta este valor según tu impresora
    String cmdFontSizeMedium = "\x1d\x21\x01"; // Tamaño de fuente intermedio
    String cmdFontSizeNormal =
        "\x1d\x21\x00"; // Comando para restablecer el tamaño de la fuente a normal

    // Comandos para activar/desactivar negrita
    String cmdBoldOn = "\x1b\x45\x01";
    String cmdBoldOff = "\x1b\x45\x00";

    // Comando para alinear el texto a la izquierda
    String cmdAlignLeft = "\x1b\x61\x00";

    // Comando para centrar el texto
    String cmdAlignCenter = "\x1b\x61\x01";

    // Añadir "Orden" con el tamaño de fuente grande y en negrita
    content += cmdBoldOn +
        cmdFontSizeLarge +
        'Orden #${state.orderIdSelectedForUpdate ?? ''}\n\n' +
        cmdBoldOff +
        cmdFontSizeNormal;

    if (state.selectedOrderType != OrderType.dineIn) {
      // Imprimir el tipo de orden con un tamaño de fuente intermedio y en negritas, sin la etiqueta "Tipo:", alineado a la izquierda
      content += cmdFontSizeMedium +
          '${_orderTypeTranslations[state.selectedOrderType]}\n' +
          cmdBoldOff +
          cmdFontSizeNormal;
    }

    if (state.selectedOrderType == OrderType.dineIn) {
      // Alinear los detalles de la orden a la izquierda
      content += cmdAlignLeft;
      content += cmdFontSizeMedium +
          '${state.areas?.firstWhere((area) => area.id == state.selectedAreaId)?.name ?? ''}:' +
          cmdFontSizeNormal;
      content += cmdFontSizeMedium +
          '${state.tables?.firstWhere((table) => table.id == state.selectedTableId)?.number ?? ''}\n' +
          cmdFontSizeNormal;
    } else if (state.selectedOrderType == OrderType.delivery) {
      // Alinear los detalles de la orden a la izquierda
      content += cmdAlignLeft;
      content += cmdFontSizeMedium +
          'Telefono: ${state.phoneNumber}\n' +
          cmdFontSizeNormal;
      content += cmdFontSizeMedium +
          'Direccion: ${removeAccents(state.deliveryAddress ?? '')}\n' +
          cmdFontSizeNormal;
    } else if (state.selectedOrderType == OrderType.pickUpWait) {
      // Alinear los detalles de la orden a la izquierda
      content += cmdAlignLeft;
      content += cmdFontSizeMedium +
          'Nombre del Cliente: ${state.customerName}\n' +
          cmdFontSizeNormal;
      content += cmdFontSizeMedium +
          'Telefono: ${state.phoneNumber}\n' +
          cmdFontSizeNormal;
    }
    // Añadir la fecha de impresión del ticket formateada hasta el minuto
    content += 'Fecha: ${DateTime.now().toString().substring(0, 16)}\n';
    content +=
        '--------------------------------\n'; // Línea de separación con guiones
    state.orderItems?.forEach((item) {
      final int lineWidth = 32; // Ajusta según el ancho de tu impresora
      // Determina si se debe usar el nombre de la variante o el nombre del producto
      String productName =
          item.productVariant?.name ?? item.product?.name ?? '';
      String productPrice = '\$${item.price?.toStringAsFixed(2) ?? ''}';

      // Calcula el espacio máximo disponible para el nombre del producto o variante
      int maxProductNameLength = lineWidth -
          productPrice.length -
          1; // -1 por el espacio entre nombre y precio

      // Trunca el nombre del producto o variante si es necesario
      if (productName.length > maxProductNameLength) {
        productName =
            productName.substring(0, maxProductNameLength - 3) + '...';
      }

      // Calcula el espacio restante después de colocar el nombre truncado y el precio
      int spaceNeeded = lineWidth - productName.length - productPrice.length;
      String spaces = ' ' * (spaceNeeded > 0 ? spaceNeeded : 0);

      content += productName + spaces + productPrice + '\n';

      // Función para agregar espacios al inicio de cada línea de un detalle
      String addPrefixToEachLine(String text, String prefix) {
        return text.split('\n').map((line) => prefix + line).join('\n');
      }

      // Define un prefijo de espacios para los detalles adicionales
      String detailPrefix = '  '; // 4 espacios de indentación

      // Agrega detalles adicionales como modificadores, ingredientes, etc.
      if (item.selectedModifiers != null &&
          item.selectedModifiers!.isNotEmpty) {
        String modifiersText =
            'Modificadores: ${item.selectedModifiers!.map((m) => m.modifier?.name).join(', ')}';
        content += addPrefixToEachLine(modifiersText, detailPrefix) + '\n';
      }
      if (item.selectedPizzaFlavors != null &&
          item.selectedPizzaFlavors!.isNotEmpty) {
        String flavorsText =
            'Sabor: ${item.selectedPizzaFlavors!.map((f) => f.pizzaFlavor?.name).join('/')}';
        content += addPrefixToEachLine(flavorsText, detailPrefix) + '\n';
      }
      if (item.selectedPizzaIngredients != null &&
          item.selectedPizzaIngredients!.isNotEmpty) {
        String ingredientsText = '';
        final ingredientsLeft = item.selectedPizzaIngredients!
            .where((i) => i.half == PizzaHalf.left)
            .map((i) => i.pizzaIngredient?.name)
            .join(', ');
        final ingredientsRight = item.selectedPizzaIngredients!
            .where((i) => i.half == PizzaHalf.right)
            .map((i) => i.pizzaIngredient?.name)
            .join(', ');
        final ingredientsNone = item.selectedPizzaIngredients!
            .where((i) => i.half == PizzaHalf.none)
            .map((i) => i.pizzaIngredient?.name)
            .join(', ');

        if (ingredientsLeft.isNotEmpty) {
          ingredientsText += 'Mitad 1: $ingredientsLeft';
        }
        if (ingredientsRight.isNotEmpty) {
          if (ingredientsText.isNotEmpty) ingredientsText += ' | ';
          ingredientsText += 'Mitad 2: $ingredientsRight';
        }
        if (ingredientsNone.isNotEmpty) {
          if (ingredientsText.isNotEmpty) ingredientsText += ' | ';
          ingredientsText += 'Completa: $ingredientsNone';
        }

        content += addPrefixToEachLine(ingredientsText, detailPrefix) + '\n';
      }
    });
    // Procesamiento de los ajustes de la orden
    state.orderAdjustments?.forEach((adjustment) {
      final int lineWidth = 32;
      String adjustmentName = adjustment.name ?? '';
      String adjustmentAmount = adjustment.amount! < 0
          ? '-\$${(-adjustment.amount!).toStringAsFixed(2)}'
          : '\$${adjustment.amount?.toStringAsFixed(2) ?? ''}';

      int maxAdjustmentNameLength = lineWidth - adjustmentAmount.length - 1;
      if (adjustmentName.length > maxAdjustmentNameLength) {
        adjustmentName =
            adjustmentName.substring(0, maxAdjustmentNameLength - 3) + '...';
      }

      int spaceNeeded =
          lineWidth - adjustmentName.length - adjustmentAmount.length;
      String spaces = ' ' * (spaceNeeded > 0 ? spaceNeeded : 0);

      content += adjustmentName + spaces + adjustmentAmount + '\n';
    });

    content +=
        '--------------------------------\n'; // Línea de separación con guiones

    content += cmdFontSizeLarge +
        'Total: \$${calculateTotal(state.orderItems, state.orderAdjustments).toStringAsFixed(2)}\n' +
        cmdFontSizeNormal; // Restablece el tamaño de la fuente a normal después del total

    // Añade un mensaje de gracias después del total
    content += cmdAlignCenter +
        cmdFontSizeMedium +
        '\n" Gracias "\n' +
        cmdFontSizeNormal;

    // Restablece la alineación a la izquierda después del mensaje de gracias
    content += cmdAlignLeft;

    content += '\n\n';
    return content;
  }

  String removeAccents(String originalString) {
    const accents = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÖØòóôõöøÈÉÊËèéêëÇçÌÍÎÏìíîïÙÚÛÜùúûüÿÑñ';
    const withoutAccents =
        'AAAAAAaaaaaaOOOOOOooooooEEEEeeeeCcIIIIiiiiUUUUuuuuyNn';

    String result = '';
    for (int i = 0; i < originalString.length; i++) {
      final char = originalString[i];
      final index = accents.indexOf(char);
      if (index != -1) {
        result += withoutAccents[index];
      } else {
        result += char;
      }
    }
    return result;
  }
}
