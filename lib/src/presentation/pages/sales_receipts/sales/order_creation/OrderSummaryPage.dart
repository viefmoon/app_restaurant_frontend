import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/models/OrderAdjustment.dart';
import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/domain/models/SelectedPizzaIngredient.dart';
import 'package:app/src/domain/utils/Resource.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationState.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/ProductPersonalizationPage.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({super.key});

  @override
  _OrderSummaryPageState createState() => _OrderSummaryPageState();
}

final Map<OrderType, String> _orderTypeTranslations = {
  OrderType.dineIn: 'Comer Dentro',
  OrderType.delivery: 'Entrega a domicilio',
  OrderType.pickUpWait: 'Para llevar/Esperar',
};

class _OrderSummaryPageState extends State<OrderSummaryPage> {
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
    return BlocListener<OrderCreationBloc, OrderCreationState>(
        listener: (context, state) {
          if (state.response is Success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Orden enviada con éxito',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
              ),
            );
            BlocProvider.of<OrderCreationBloc>(context)
                .add(ResetResponseEvent());
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
            BlocProvider.of<OrderCreationBloc>(context)
                .add(ResetResponseEvent());
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Resumen de la Orden'),
            actions: <Widget>[
              PopupMenuButton<int>(
                onSelected: (item) => onSelected(context, item),
                itemBuilder: (context) => [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text('Eliminar Orden',
                        style: TextStyle(
                            fontSize: 18)), // Tamaño de texto aumentado
                  ),
                ],
              ),
            ],
          ),
          body: BlocBuilder<OrderCreationBloc, OrderCreationState>(
            builder: (context, state) {
              _phoneController.text = state.phoneNumber ?? "";
              _addressController.text = state.deliveryAddress ?? "";
              _customerNameController.text = state.customerName ?? "";
              _commentsController.text = state.comments ?? "";

              List<Widget> headerDetails = [];
              headerDetails.add(Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 15.0),
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
                          BlocProvider.of<OrderCreationBloc>(context).add(
                              OrderTypeSelected(selectedOrderType: newValue));
                        }
                      },
                      items: OrderType.values.map((OrderType type) {
                        return DropdownMenuItem<OrderType>(
                          value: type,
                          child: Text(
                              _orderTypeTranslations[type] ?? type.toString()),
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
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
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
                        BlocProvider.of<OrderCreationBloc>(context).add(
                          PhoneNumberEntered(phoneNumber: value),
                        );
                      },
                    ),
                  ));
                  headerDetails.add(Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Dirección',
                        hintText: 'Ingresa la dirección de entrega',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Colors.green, width: 2.0),
                        ),
                      ),
                      onChanged: (value) {
                        BlocProvider.of<OrderCreationBloc>(context).add(
                            DeliveryAddressEntered(deliveryAddress: value));
                      },
                    ),
                  ));
                  break;
                case OrderType.pickUpWait:
                  headerDetails.add(Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: TextField(
                      controller: _customerNameController,
                      decoration: InputDecoration(
                        labelText: 'Nombre del Cliente',
                        hintText: 'Ingresa el nombre del cliente',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
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
                        BlocProvider.of<OrderCreationBloc>(context).add(
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
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
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
                        BlocProvider.of<OrderCreationBloc>(context).add(
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
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
                    BlocProvider.of<OrderCreationBloc>(context)
                        .add(OrderCommentsEntered(comments: value));
                  },
                ),
              ));
              headerDetails
                  .add(BlocBuilder<OrderCreationBloc, OrderCreationState>(
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
                            BlocProvider.of<OrderCreationBloc>(context).add(
                                TimePickerEnabled(isTimePickerEnabled: value));
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
                    3, // +3 para el total, botón de ajuste, y botón de enviar
                itemBuilder: (context, index) {
                  if (index < headerCount) {
                    // Devuelve el widget de encabezado correspondiente
                    return headerDetails[index];
                  } else if (index < headerCount + orderItemsCount) {
                    // Devuelve el widget de OrderItem correspondiente
                    final orderItemIndex = index - headerCount;
                    final orderItem = state.orderItems![orderItemIndex];

                    List<Widget> details = [];
                    if (orderItem.productVariant != null) {
                      details.add(
                          Text('Variante: ${orderItem.productVariant?.name}'));
                    }
                    if (orderItem.selectedModifiers != null &&
                        orderItem.selectedModifiers!.isNotEmpty) {
                      details.add(Text(
                          'Modificadores: ${orderItem.selectedModifiers!.map((m) => m.modifier?.name).join(', ')}'));
                    }
                    if (orderItem.selectedPizzaFlavors != null &&
                        orderItem.selectedPizzaFlavors!.isNotEmpty) {
                      details.add(Text(
                          'Sabor: ${orderItem.selectedPizzaFlavors!.map((f) => f.pizzaFlavor?.name).join('/')}'));
                    }

                    if (orderItem.selectedPizzaIngredients != null &&
                        orderItem.selectedPizzaIngredients!.isNotEmpty) {
                      final ingredientsLeft = orderItem
                          .selectedPizzaIngredients!
                          .where((i) => i.half == PizzaHalf.left)
                          .map((i) => i.pizzaIngredient?.name)
                          .join(', ');
                      final ingredientsRight = orderItem
                          .selectedPizzaIngredients!
                          .where((i) => i.half == PizzaHalf.right)
                          .map((i) => i.pizzaIngredient?.name)
                          .join(', ');
                      final ingredientsNone = orderItem
                          .selectedPizzaIngredients!
                          .where((i) => i.half == PizzaHalf.none)
                          .map((i) => i.pizzaIngredient?.name)
                          .join(', ');

                      String ingredientsText = '';
                      if (ingredientsLeft.isNotEmpty) {
                        ingredientsText += 'Mitad 1: $ingredientsLeft';
                      }
                      if (ingredientsRight.isNotEmpty) {
                        if (ingredientsText.isNotEmpty)
                          ingredientsText += ' | ';
                        ingredientsText += 'Mitad 2: $ingredientsRight';
                      }
                      if (ingredientsNone.isNotEmpty) {
                        if (ingredientsText.isNotEmpty)
                          ingredientsText += ' | ';
                        ingredientsText += 'Completa: $ingredientsNone';
                      }

                      details.add(Text(
                        'Ingredientes: $ingredientsText',
                      ));
                    }
                    if (orderItem.selectedProductObservations != null &&
                        orderItem.selectedProductObservations!.isNotEmpty) {
                      details.add(Text(
                          'Observaciones: ${orderItem.selectedProductObservations!.map((o) => o.productObservation?.name).join(', ')}'));
                    }
                    if (orderItem.comments != null &&
                        orderItem.comments!.isNotEmpty) {
                      details.add(Text('Comentarios: ${orderItem.comments}'));
                    }

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductPersonalizationPage(
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
                            Text(
                                '\$${orderItem.price?.toStringAsFixed(2) ?? ''}'),
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
                    final adjustmentIndex =
                        index - (headerCount + orderItemsCount);
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
                          fontSize: 25.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      trailing: Text(
                        '\$${calculateTotal(state.orderItems, state.orderAdjustments).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
                  } else if (index ==
                      headerCount +
                          orderItemsCount +
                          orderAdjustmentsCount +
                          1) {
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
                  } else {
                    // Botón para enviar la orden
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () => _sendOrder(context, state),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          textStyle: TextStyle(fontSize: 22),
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text('Enviar orden'),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ));
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        BlocProvider.of<OrderCreationBloc>(context).add(ResetOrder());
        Navigator.popUntil(context, ModalRoute.withName('salesHome'));
        break;
    }
  }

  Widget _buildAreaDropdown(BuildContext context, OrderCreationState state) {
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
                BlocProvider.of<OrderCreationBloc>(context)
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

  Widget _buildTableDropdown(BuildContext context, OrderCreationState state) {
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
                BlocProvider.of<OrderCreationBloc>(context)
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
      BlocProvider.of<OrderCreationBloc>(context)
          .add(TimeSelected(time: picked));
    }
  }

  double calculateTotal(
      List<OrderItem>? orderItems, List<OrderAdjustment>? orderAdjustments) {
    // Asegura que el valor inicial y el valor retornado por la función sean `double` no nulos.
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

  void _sendOrder(BuildContext context, OrderCreationState state) {
    // Verificar si la lista de OrderItems está vacía o es nula
    if (state.orderItems == null || state.orderItems!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,
          content: Text('No se puede enviar la orden sin productos.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          duration: Duration(milliseconds: 800),
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
              content: Text('Selecciona un área y una mesa para continuar.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              duration: Duration(milliseconds: 800),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              duration: Duration(milliseconds: 800),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              duration: Duration(milliseconds: 800),
            ),
          );
          return; // Salir del método para evitar enviar la orden
        }
        break;
      default:
        break; // No se requieren verificaciones adicionales para otros tipos de orden
    }

    BlocProvider.of<OrderCreationBloc>(context).add(SendOrder());
    Navigator.popUntil(context, ModalRoute.withName('salesHome'));
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
                  BlocProvider.of<OrderCreationBloc>(context).add(
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
                    BlocProvider.of<OrderCreationBloc>(context).add(
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
}
