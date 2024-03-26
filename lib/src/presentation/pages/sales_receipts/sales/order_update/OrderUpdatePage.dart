import 'package:app/src/domain/models/OrderItem.dart';
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

class OrderUpdatePage extends StatefulWidget {
  const OrderUpdatePage({Key? key}) : super(key: key);

  @override
  _OrderUpdatePageState createState() => _OrderUpdatePageState();
}

final Map<OrderType, String> _orderTypeTranslations = {
  OrderType.dineIn: 'Comer Dentro',
  OrderType.delivery: 'Entrega a domicilio',
  OrderType.pickUpWait: 'Para llevar/Esperar',
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

  AppBar _buildAppBar(BuildContext context, OrderUpdateState state) {
    return AppBar(
      title: Text('Actualizar Orden #${state.orderIdSelectedForUpdate}'),
      actions: [
        IconButton(
          icon: Icon(Icons.save, size: 40),
          onPressed: () => _updateOrder(context, state),
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

        return ListView.builder(
          itemCount: (state.orderItems?.length ?? 0) +
              3, // Añade +3 para incluir el total y el botón de enviar
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: headerDetails,
              );
            } else if (index <= (state.orderItems?.length ?? 0)) {
              final orderItemIndex = index - 1;
              final orderItem = state.orderItems![orderItemIndex];

              List<Widget> details = [];
              if (orderItem.productVariant != null) {
                details
                    .add(Text('Variante: ${orderItem.productVariant?.name}'));
              }
              if (orderItem.selectedModifiers != null &&
                  orderItem.selectedModifiers!.isNotEmpty) {
                details.add(Text(
                    'Modificadores: ${orderItem.selectedModifiers!.map((m) => m.modifier?.name).join(', ')}'));
              }
              // Añadir detalles de sabores de pizza seleccionados
              if (orderItem.selectedPizzaFlavors != null &&
                  orderItem.selectedPizzaFlavors!.isNotEmpty) {
                details.add(Text(
                    'Sabor: ${orderItem.selectedPizzaFlavors!.map((f) => f.pizzaFlavor?.name).join('/')}'));
              }
              // Añadir detalles de ingredientes de pizza seleccionados separados por mitad
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

                details.add(Text('Ingredientes: $ingredientsText'));
              }

              if (orderItem.selectedProductObservations != null &&
                  orderItem.selectedProductObservations!.isNotEmpty) {
                details.add(Text(
                    'Observaciones: ${orderItem.selectedProductObservations!.map((o) => o.productObservation?.name).join(', ')}'));
              }
              // Añadir comentarios del item de orden si existen
              if (orderItem.comments != null &&
                  orderItem.comments!.isNotEmpty) {
                details.add(Text('Comentarios: ${orderItem.comments}'));
              }

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateProductPersonalizationPage(
                        product: orderItem.product!,
                        existingOrderItem: orderItem,
                      ),
                    ),
                  );
                },
                child: ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(orderItem.product?.name ?? ''),
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
            } else if (index == (state.orderItems?.length ?? 0) + 1) {
              // Widget para mostrar el total
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 25.0, // Tamaño de letra más grande
                        fontStyle: FontStyle.italic, // Letra en cursiva
                      ),
                    ),
                    trailing: Text(
                      '\$${calculateTotal(state.orderItems).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 25.0, // Tamaño de letra más grande
                        fontStyle: FontStyle.italic, // Letra en cursiva
                      ),
                    ),
                  ),
                  _buildAddProductButton(context),
                ],
              );
            }
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

  double calculateTotal(List<OrderItem>? orderItems) {
    if (orderItems == null) return 0.0;
    return orderItems.fold(0.0, (total, item) => total + (item.price ?? 0.0));
  }
}
