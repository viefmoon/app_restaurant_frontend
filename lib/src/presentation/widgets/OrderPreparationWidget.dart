import 'dart:async';
import 'package:app/src/domain/models/OrderItem.dart';
import 'package:flutter/material.dart';
import 'package:app/src/domain/models/Order.dart';
import 'package:intl/intl.dart';

class OrderPreparationWidget extends StatefulWidget {
  final Order order;
  final Function(Order, String) onOrderGesture;
  final Function(Order, OrderItem) onOrderItemTap;

  const OrderPreparationWidget({
    //Key? key,
    required this.order,
    required this.onOrderGesture,
    required this.onOrderItemTap, // Agrega el callback al constructor
  });

  @override
  _OrderPreparationWidgetState createState() => _OrderPreparationWidgetState();
}

class _OrderPreparationWidgetState extends State<OrderPreparationWidget> {
  Timer? _timer;
  Duration _timeSinceCreation = Duration.zero;
  Duration _timeUntilScheduled = Duration.zero; // Añadir esta línea
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _updateTimeSinceCreation();
    _updateTimeUntilScheduled(); // Añadir esta llamada
    _timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
      _updateTimeSinceCreation();
      _updateTimeUntilScheduled(); // Añadir esta llamada
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _updateTimeSinceCreation() {
    if (widget.order.creationDate != null) {
      setState(() {
        _timeSinceCreation =
            DateTime.now().difference(widget.order.creationDate!);
      });
    }
  }

  void _updateTimeUntilScheduled() {
    if (widget.order.scheduledDeliveryTime != null) {
      final now = DateTime.now();
      final scheduledTime = widget.order.scheduledDeliveryTime!;
      final difference = scheduledTime.difference(now);
      setState(() {
        _timeUntilScheduled =
            difference.isNegative ? Duration.zero : difference;
      });
    }
  }

  Color _getColorBasedOnTime(Duration duration) {
    if (duration.inMinutes < 30) {
      return Colors.green;
    } else if (duration.inMinutes < 60) {
      return Colors.orange;
    } else {
      return Colors.deepOrange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String timeSinceCreation =
        '${_timeSinceCreation.inHours.toString().padLeft(2, '0')}:${_timeSinceCreation.inMinutes.remainder(60).toString().padLeft(2, '0')}';

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.25,
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderHeader(timeSinceCreation), // Modifica esta línea
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildOrderDetails(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderHeader(String timeSinceCreation) {
    // Añade el parámetro aquí
    return _OrderHeaderGestureDetector(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _getColorByOrderState(widget.order.status),
              _getColorByOrderType(widget.order.orderType),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: const [0.8, 0.2],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Orden #${widget.order.id} - ${_displayOrderType(widget.order.orderType)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Arial'),
                    ),
                    Text(
                      _displayOrderStatus(widget.order.status),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.black, fontStyle: FontStyle.italic),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'Creado: ${DateFormat('HH:mm').format(widget.order.creationDate!)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.black54),
                            ),
                            TextSpan(
                              text:
                                  '  - $timeSinceCreation', // Usa el parámetro aquí
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (widget.order.scheduledDeliveryTime != null)
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'Programado: ${DateFormat('HH:mm').format(widget.order.scheduledDeliveryTime!)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.black),
                            ),
                            TextSpan(
                              text:
                                  ' - Falta: ${_formatDuration(_timeUntilScheduled)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorByOrderType(OrderType? type) {
    switch (type) {
      case OrderType.delivery:
        return Colors.brown;
      case OrderType.dineIn:
        return Colors.green;
      case OrderType.pickUpWait:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getColorByOrderState(OrderStatus? status) {
    switch (status) {
      case OrderStatus.created:
        return Colors.lightBlue[100]!;
      case OrderStatus.in_preparation:
        return Colors.lightGreen[100]!;
      case OrderStatus.prepared:
        return Colors.amber[100]!;
      case OrderStatus.finished:
        return Colors.grey[100]!;
      case OrderStatus.canceled:
        return Colors.red[100]!;
      default:
        return Colors.white;
    }
  }

  Widget _OrderHeaderGestureDetector({required Widget child}) {
    return GestureDetector(
      onHorizontalDragEnd: _handleHorizontalDragEnd,
      onVerticalDragEnd: _handleVerticalDragEnd,
      onLongPress: () => _handleLongPress(widget.order), // Añade esto
      child: child,
    );
  }

  void _handleLongPress(Order order) {
    // Aquí implementas la lógica para cambiar el estado del pedido
    // basado en su estado actual
    String newStatus;
    if (order.status == OrderStatus.created ||
        order.status == OrderStatus.in_preparation) {
      newStatus = 'swipe_to_prepared'; // Define un nuevo tipo de gesto
    } else if (order.status == OrderStatus.prepared) {
      newStatus = 'swipe_to_in_preparation'; // Define otro tipo de gesto
    } else {
      return; // No hagas nada si el pedido no está en un estado que pueda cambiar
    }

    // Llama al callback proporcionado al widget con el nuevo estado
    widget.onOrderGesture(order, newStatus);
  }

  Widget _buildOrderDetails(BuildContext context) {
    List<Widget> orderDetails = [];

    Widget buildSubHeaderDetail(String text) {
      return Container(
        width: double.infinity,
        color: Colors.blueGrey,
        margin: EdgeInsets.only(bottom: 8.0),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.white),
        ),
      );
    }

    // Añadir detalles basados en el tipo de orden
    switch (widget.order.orderType) {
      case OrderType.delivery:
        orderDetails.add(buildSubHeaderDetail(
          'Dirección: ${widget.order.deliveryAddress}\nTeléfono: ${widget.order.phoneNumber}',
        ));
        break;
      case OrderType.dineIn:
        orderDetails.add(buildSubHeaderDetail(
          '${widget.order.area?.name} - ${widget.order.table?.number}',
        ));
        break;
      case OrderType.pickUpWait:
        orderDetails.add(buildSubHeaderDetail(
          'Cliente: ${widget.order.customerName}\nTeléfono: ${widget.order.phoneNumber}',
        ));
        break;
      default:
        orderDetails.add(SizedBox
            .shrink()); // En caso de que el tipo de orden no esté definido
    }

    // Añadir detalles de los OrderItems
    widget.order.orderItems?.asMap().forEach((index, orderItem) {
      if (index > 0) {
        // Añadir un Divider antes de cada OrderItem, excepto el primero
        orderDetails.add(Divider(color: Colors.black));
      }

      TextStyle baseTextStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ) ??
          TextStyle();

      TextStyle smallerTextStyle =
          Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ) ??
              TextStyle();

      TextStyle textStyle = orderItem.status == OrderItemStatus.prepared
          ? baseTextStyle.copyWith(
              decoration: TextDecoration.lineThrough,
              decorationColor: Colors.red,
              decorationThickness: 4,
              decorationStyle: TextDecorationStyle.solid,
            )
          : baseTextStyle;

      TextStyle smallerDecoratedTextStyle =
          orderItem.status == OrderItemStatus.prepared
              ? smallerTextStyle.copyWith(
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.red,
                  decorationThickness: 4,
                  decorationStyle: TextDecorationStyle.solid,
                )
              : smallerTextStyle;

      List<Widget> itemWidgets = [
        Text(
          orderItem.product?.name ?? 'Producto desconocido',
          style: textStyle,
        ),
        if (orderItem.productVariant != null)
          Text(
            orderItem.productVariant!.name,
            style: smallerDecoratedTextStyle,
          ),
        ...orderItem.selectedModifiers?.map((modifier) => Text(
                  modifier.modifier!.name,
                  style: smallerDecoratedTextStyle,
                )) ??
            [],
        ...orderItem.selectedProductObservations?.map((observation) => Text(
                  observation.productObservation!.name,
                  style: smallerDecoratedTextStyle,
                )) ??
            [],
      ];

      orderDetails.add(
        GestureDetector(
          onTap: () {
            widget.onOrderItemTap(widget.order, orderItem);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: itemWidgets,
          ),
        ),
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: orderDetails,
    );
  }

  String _displayOrderType(OrderType? type) {
    switch (type) {
      case OrderType.delivery:
        return 'Domicilio';
      case OrderType.dineIn:
        return 'Dentro';
      case OrderType.pickUpWait:
        return 'Recoger';
      default:
        return 'Desconocido';
    }
  }

  String _displayOrderStatus(OrderStatus? status) {
    switch (status) {
      case OrderStatus.created:
        return 'Creada';
      case OrderStatus.in_preparation:
        return 'En preparación';
      case OrderStatus.prepared:
        return 'Preparada';
      case OrderStatus.finished:
        return 'Finalizada';
      case OrderStatus.canceled:
        return 'Cancelada';
      default:
        return 'Desconocido';
    }
  }

  // Esta función ayuda a formatear la duración a un formato legible
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    return "$hours:$minutes";
  }

  void _handleHorizontalDragEnd(DragEndDetails details) {
    const double velocityThreshold =
        50.0; // Ajusta este valor según tus necesidades
    if (details.primaryVelocity! > velocityThreshold) {
      widget.onOrderGesture(widget.order, 'swipe_right');
    } else if (details.primaryVelocity! < -velocityThreshold) {
      widget.onOrderGesture(widget.order, 'swipe_left');
    }
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    const double velocityThreshold =
        50.0; // Ajusta este valor según tus necesidades
    if (details.primaryVelocity! > velocityThreshold) {
      widget.onOrderGesture(widget.order, 'swipe_down');
    } else if (details.primaryVelocity! < -velocityThreshold) {
      widget.onOrderGesture(widget.order, 'swipe_up');
    }
  }
}
