import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationState.dart';

class OrderSummaryPage extends StatefulWidget {
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
  TimeOfDay? _selectedTime; // Hacerlo nullable
  bool _isTimePickerEnabled = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: "");
    _addressController = TextEditingController(text: "");
    _customerNameController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    _customerNameController.dispose();
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
          // Actualizar el controlador del teléfono con el valor actual del estado
          _phoneController.text = state.phoneNumber ?? "";

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
                      // Usar el mapa para obtener la traducción al español
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
                    // Aquí puedes actualizar el estado con el nuevo nombre del cliente, si es necesario
                  },
                ),
              ));
              break;
            default:
              break;
          }
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
                2, // Añade +2 en lugar de +1 para incluir el total
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
                if (orderItem.selectedProductObservations != null &&
                    orderItem.selectedProductObservations!.isNotEmpty) {
                  details.add(Text(
                      'Observaciones: ${orderItem.selectedProductObservations!.map((o) => o.productObservation?.name).join(', ')}'));
                }
                if (orderItem.pizzaFlavor != null) {
                  details.add(
                      Text('Sabor de Pizza: ${orderItem.pizzaFlavor?.name}'));
                }

                return ListTile(
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
                );
              } else {
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
              }
            },
          );
        },
      ),
      floatingActionButton: BlocBuilder<OrderCreationBloc, OrderCreationState>(
        builder: (context, state) {
          bool isButtonEnabled = false;
          if (state.orderItems != null && state.orderItems!.isNotEmpty) {
            switch (state.selectedOrderType) {
              case OrderType.dineIn:
                isButtonEnabled = state.selectedAreaId != null &&
                    state.selectedTableId != null;
                break;
              case OrderType.delivery:
                isButtonEnabled = state.deliveryAddress != null &&
                    state.deliveryAddress!.isNotEmpty;
                break;
              case OrderType.pickUpWait:
                isButtonEnabled = _customerNameController.text.isNotEmpty;
                break;
              default:
                break;
            }
          }
          return Theme(
            data: Theme.of(context).copyWith(
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(5.0), // Esquinas menos redondeadas
                ),
                extendedTextStyle: TextStyle(
                  fontSize: 26, // Tamaño de letra más grande
                ),
              ),
            ),
            child: FloatingActionButton.extended(
              onPressed:
                  isButtonEnabled ? () => _sendOrder(context, state) : null,
              backgroundColor: isButtonEnabled ? Colors.blue : Colors.grey,
              label: Text('Enviar orden'),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                // Asegúrate de que el evento AreaSelected maneje el reseteo de la selección de la mesa y la carga de las nuevas mesas.
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
                : null, // Asegúrate de que el valor actual sea nulo si el ID seleccionado no está en las mesas cargadas
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
    if (!_isTimePickerEnabled)
      return; // No hacer nada si el selector de tiempo está deshabilitado

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
    // Implementa la lógica para enviar la orden aquí.
    // Por ejemplo, puedes llamar a un evento de Bloc para procesar la orden.
  }
}
