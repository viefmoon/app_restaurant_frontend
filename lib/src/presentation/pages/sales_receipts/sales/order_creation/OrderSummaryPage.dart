import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/models/OrderItem.dart';
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

  TimeOfDay? _selectedTime;
  bool _isTimePickerEnabled = false;

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen de la Orden'),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text('Eliminar Orden'),
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
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
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
                      BlocProvider.of<OrderCreationBloc>(context)
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
                        .add(DeliveryAddressEntered(deliveryAddress: value));
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
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    BlocProvider.of<OrderCreationBloc>(context).add(
                      CustomerNameEntered(customerName: value),
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
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
          headerDetails.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2, // Ajusta la proporción si es necesario
                  child: Switch(
                    value: _isTimePickerEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        _isTimePickerEnabled = value;
                        if (!value) {
                          _selectedTime =
                              null; // Resetear _selectedTime si el selector está deshabilitado
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 8, // Ajusta la proporción si es necesario
                  child: ListTile(
                    title: Text('Seleccionar Hora'),
                    subtitle: Text(
                      _isTimePickerEnabled && _selectedTime != null
                          ? _selectedTime!.format(context)
                          : 'No seleccionada',
                    ),
                    leading: Icon(Icons.access_time),
                    onTap: _isTimePickerEnabled
                        ? () => _selectTime(context)
                        : null,
                  ),
                ),
              ],
            ),
          );

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
                      'Sabores de Pizza: ${orderItem.selectedPizzaFlavors!.map((f) => f.pizzaFlavor?.name).join(', ')}'));
                }
                // Añadir detalles de ingredientes de pizza seleccionados
                if (orderItem.selectedPizzaIngredients != null &&
                    orderItem.selectedPizzaIngredients!.isNotEmpty) {
                  details.add(Text(
                      'Ingredientes de Pizza: ${orderItem.selectedPizzaIngredients!.map((i) => i.pizzaIngredient?.name).join(', ')}'));
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
                return ListTile(
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
                );
              } else {
                // Nuevo widget para el botón de enviar orden
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () => _sendOrder(context, state),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      textStyle: TextStyle(fontSize: 20),
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
    );
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
                child: Text(area.name),
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
    if (!_isTimePickerEnabled) {
      return; // No hacer nada si el selector de tiempo está deshabilitado
    }

    final localContext =
        context; // Captura el contexto antes de la brecha asíncrona

    final TimeOfDay? picked = await showTimePicker(
      context: localContext,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
      // Usa el contexto capturado
      BlocProvider.of<OrderCreationBloc>(localContext)
          .add(TimeSelected(time: picked));
    }
  }

  double calculateTotal(List<OrderItem>? orderItems) {
    if (orderItems == null) return 0.0;
    return orderItems.fold(0.0, (total, item) => total + (item.price ?? 0.0));
  }

  void _sendOrder(BuildContext context, OrderCreationState state) {
    // Verificar si la lista de OrderItems está vacía o es nula
    if (state.orderItems == null || state.orderItems!.isEmpty) {
      // Mostrar un SnackBar con un mensaje indicando que se necesitan ítems para crear la orden
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se puede enviar la orden sin ítems.'),
          duration: Duration(seconds: 1),
        ),
      );
      return; // Salir del método para evitar enviar la orden
    }

    // Si hay OrderItems, proceder con el envío de la orden
    BlocProvider.of<OrderCreationBloc>(context).add(SendOrder());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Orden enviada con éxito'),
        duration: Duration(seconds: 1),
      ),
    );
    Navigator.popUntil(context, ModalRoute.withName('salesHome'));
  }
}
