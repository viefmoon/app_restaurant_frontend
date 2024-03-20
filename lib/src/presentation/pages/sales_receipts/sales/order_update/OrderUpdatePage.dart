import 'package:app/src/domain/models/OrderItem.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_update/AddProductPage.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_update/UpdateProductPersonalizationPage.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_update/bloc/OrderUpdateState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_update/bloc/OrderUpdateBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_update/bloc/OrderUpdateEvent.dart';
import 'package:collection/collection.dart';

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
    return PopScope(
        canPop: true, // Allows the pop to proceed
        onPopInvoked: (didPop) async {
          if (didPop) {
            BlocProvider.of<OrderUpdateBloc>(context)
                .add(ResetOrderUpdateState());
          }
        },
        child: Scaffold(
          appBar: _buildAppBar(context),
          body: _buildBody(context),
        ));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: BlocBuilder<OrderUpdateBloc, OrderUpdateState>(
        builder: (context, state) {
          return Text('Actualizar Orden #${state.orderIdSelectedForUpdate}');
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.save),
          onPressed: () => _updateOrder(),
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

        List<Widget> headerDetails = [
          _buildOrderTypeDropdown(context, state),
          if (state.selectedOrderType == OrderType.dineIn)
            _buildDineInDetails(context,
                state), // Aquí agregas los detalles específicos para dineIn
          if (state.selectedOrderType == OrderType.delivery)
            _buildDeliveryDetails(context, state),
          if (state.selectedOrderType == OrderType.pickUpWait)
            _buildPickUpWaitDetails(context, state),
          _buildCommentsField(context, state),
          _buildTimePicker(context, state),
        ];

        return ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: headerDetails,
            ),
            ..._buildOrderItemsList(context, state),
            _buildTotalTile(context, state),
            _buildAddProductButton(context),
          ],
        );
      },
    );
  }

  Widget _buildOrderTypeDropdown(BuildContext context, OrderUpdateState state) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DropdownButtonFormField<OrderType>(
        value: state.selectedOrderType,
        onChanged: (OrderType? newValue) {
          if (newValue != null) {
            BlocProvider.of<OrderUpdateBloc>(context)
                .add(OrderTypeSelected(selectedOrderType: newValue));
          }
        },
        items: OrderType.values.map((OrderType type) {
          return DropdownMenuItem<OrderType>(
            value: type,
            child: Text(_orderTypeTranslations[type] ?? type.toString()),
          );
        }).toList(),
        decoration: _inputDecoration(labelText: 'Tipo de Pedido'),
      ),
    );
  }

  InputDecoration _inputDecoration({required String labelText}) {
    return InputDecoration(
      labelText: labelText,
      contentPadding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.blue, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.green, width: 2.0),
      ),
    );
  }

  Widget _buildDineInDetails(BuildContext context, OrderUpdateState state) {
    // Aquí puedes agregar los campos específicos para dineIn, como selección de área o mesa
    return Column(
      children: [
        // Ejemplo de cómo podrías implementar un dropdown para seleccionar el área
        _buildAreaDropdown(context, state),
        // Si se selecciona un área, podrías mostrar un dropdown para seleccionar la mesa
        if (state.selectedAreaId != null) _buildTableDropdown(context, state),
        // Agrega aquí más widgets según sea necesario
      ],
    );
  }

  Widget _buildDeliveryDetails(BuildContext context, OrderUpdateState state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: TextField(
            controller: _phoneController,
            decoration: _inputDecoration(labelText: 'Teléfono'),
            onChanged: (value) {
              BlocProvider.of<OrderUpdateBloc>(context).add(
                PhoneNumberEntered(phoneNumber: value),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: TextField(
            controller: _addressController,
            decoration: _inputDecoration(labelText: 'Dirección'),
            onChanged: (value) {
              BlocProvider.of<OrderUpdateBloc>(context).add(
                DeliveryAddressEntered(deliveryAddress: value),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPickUpWaitDetails(BuildContext context, OrderUpdateState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: TextField(
        controller: _customerNameController,
        decoration: _inputDecoration(labelText: 'Nombre del Cliente'),
        onChanged: (value) {
          BlocProvider.of<OrderUpdateBloc>(context).add(
            CustomerNameEntered(customerName: value),
          );
        },
      ),
    );
  }

  Widget _buildCommentsField(BuildContext context, OrderUpdateState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: TextField(
        controller: _commentsController,
        decoration: _inputDecoration(labelText: 'Comentarios'),
        onChanged: (value) {
          BlocProvider.of<OrderUpdateBloc>(context)
              .add(OrderCommentsEntered(comments: value));
        },
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context, OrderUpdateState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Switch(
            value: _isTimePickerEnabled,
            onChanged: (bool value) {
              setState(() {
                _isTimePickerEnabled = value;
                if (!value) {
                  _selectedTime = null;
                }
              });
            },
          ),
        ),
        Expanded(
          flex: 8,
          child: ListTile(
            title: Text('Seleccionar Hora'),
            subtitle: Text(
              _isTimePickerEnabled && _selectedTime != null
                  ? _selectedTime!.format(context)
                  : 'No seleccionada',
            ),
            leading: Icon(Icons.access_time),
            onTap: _isTimePickerEnabled ? () => _selectTime(context) : null,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildOrderItemsList(
      BuildContext context, OrderUpdateState state) {
    return state.orderItems?.map((orderItem) {
          TextStyle textStyle;
          switch (orderItem.status) {
            case OrderItemStatus.in_preparation:
              textStyle = TextStyle(color: Colors.blue);
              break;
            case OrderItemStatus.prepared:
              textStyle = TextStyle(color: Colors.green);
              break;
            default:
              textStyle =
                  TextStyle(); // Estilo por defecto si está 'created' o cualquier otro estado
          }

          return InkWell(
            onTap: () {
              if (orderItem.status == OrderItemStatus.created) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateProductPersonalizationPage(
                      product: orderItem.product!,
                      existingOrderItem: orderItem,
                    ),
                  ),
                );
              } else {
                // Muestra un SnackBar con un mensaje de error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Este elemento no se puede actualizar.'),
                    duration: Duration(milliseconds: 500),
                  ),
                );
              }
            },
            child: ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      orderItem.product?.name ?? '',
                      style:
                          textStyle, // Aplica el estilo de texto basado en el estado
                    ),
                  ),
                  Text(
                    '\$${orderItem.price?.toStringAsFixed(2) ?? ''}',
                    style:
                        textStyle, // Aplica el estilo de texto basado en el estado
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildOrderItemDetails(orderItem,
                    textStyle), // Asegúrate de pasar el textStyle a este método también
              ),
            ),
          );
        }).toList() ??
        [];
  }

  List<Widget> _buildOrderItemDetails(
      OrderItem orderItem, TextStyle textStyle) {
    List<Widget> details = [];
    if (orderItem.productVariant != null) {
      details.add(Text('Variante: ${orderItem.productVariant?.name}',
          style: textStyle));
    }
    if (orderItem.selectedModifiers != null &&
        orderItem.selectedModifiers!.isNotEmpty) {
      details.add(Text(
          'Modificadores: ${orderItem.selectedModifiers!.map((m) => m.modifier?.name).join(', ')}',
          style: textStyle));
    }
    if (orderItem.selectedPizzaFlavors != null &&
        orderItem.selectedPizzaFlavors!.isNotEmpty) {
      details.add(Text(
          'Sabores de Pizza: ${orderItem.selectedPizzaFlavors!.map((f) => f.pizzaFlavor?.name).join(', ')}',
          style: textStyle));
    }
    if (orderItem.selectedPizzaIngredients != null &&
        orderItem.selectedPizzaIngredients!.isNotEmpty) {
      details.add(Text(
          'Ingredientes de Pizza: ${orderItem.selectedPizzaIngredients!.map((i) => i.pizzaIngredient?.name).join(', ')}',
          style: textStyle));
    }
    if (orderItem.selectedProductObservations != null &&
        orderItem.selectedProductObservations!.isNotEmpty) {
      details.add(Text(
          'Observaciones: ${orderItem.selectedProductObservations!.map((o) => o.productObservation?.name).join(', ')}',
          style: textStyle));
    }
    if (orderItem.comments != null && orderItem.comments!.isNotEmpty) {
      details.add(Text('Comentarios: ${orderItem.comments}', style: textStyle));
    }
    return details;
  }

  Widget _buildTotalTile(BuildContext context, OrderUpdateState state) {
    return ListTile(
      title: Text(
        'Total',
        style: TextStyle(
          fontSize: 25.0,
          fontStyle: FontStyle.italic,
        ),
      ),
      trailing: Text(
        '\$${_calculateTotal(state.orderItems).toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: 25.0,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  double _calculateTotal(List<OrderItem>? orderItems) {
    if (orderItems == null) return 0.0;
    return orderItems.fold(0.0, (total, item) => total + (item.price ?? 0.0));
  }

  Widget _buildAddProductButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: ElevatedButton.icon(
        icon: Icon(Icons.add),
        label: Text('Agregar Productos'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductPage()),
          );
        },
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    if (!_isTimePickerEnabled) {
      return;
    }

    final localContext = context;

    final TimeOfDay? picked = await showTimePicker(
      context: localContext,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
      BlocProvider.of<OrderUpdateBloc>(localContext)
          .add(TimeSelected(time: picked));
    }
  }

  void _updateOrder() {
    final currentState = context.read<OrderUpdateBloc>().state;

    DateTime? scheduledDeliveryDateTime;
    if (currentState.scheduledDeliveryTime != null) {
      final now = DateTime.now();
      scheduledDeliveryDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        currentState.scheduledDeliveryTime!.hour,
        currentState.scheduledDeliveryTime!.minute,
      );
    }

    // Imprimir todos los order items
    currentState.orderItems?.forEach((orderItem) {
      print('Item: ${orderItem.id},, Precio: ${orderItem.price}');
    });

    Order updatedOrder = Order(
      id: currentState.orderIdSelectedForUpdate,
      orderType: currentState.selectedOrderType,
      totalCost: currentState.totalCost,
      comments: currentState.comments,
      customerName: currentState.customerName,
      deliveryAddress: currentState.deliveryAddress,
      phoneNumber: currentState.phoneNumber,
      scheduledDeliveryTime: scheduledDeliveryDateTime,
      area: currentState.areas
          ?.firstWhereOrNull((area) => area.id == currentState.selectedAreaId),
      table: currentState.tables?.firstWhereOrNull(
          (table) => table.id == currentState.selectedTableId),
      orderItems: currentState.orderItems,
    );

    BlocProvider.of<OrderUpdateBloc>(context).add(UpdateOrder(updatedOrder));

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
}
