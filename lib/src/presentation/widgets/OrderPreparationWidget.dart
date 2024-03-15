import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app/src/domain/models/Order.dart';
import 'package:intl/intl.dart';

class OrderPreparationWidget extends StatefulWidget {
  final Order order;

  const OrderPreparationWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  _OrderPreparationWidgetState createState() => _OrderPreparationWidgetState();
}

class _OrderPreparationWidgetState extends State<OrderPreparationWidget> {
  Timer? _timer;
  Duration _timeSinceCreation = Duration.zero;
  Duration _timeUntilScheduled = Duration.zero; // Añadir esta línea

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
    final String formattedCreationDate = widget.order.creationDate != null
        ? DateFormat('HH:mm').format(widget.order.creationDate!)
        : 'Desconocido';
    final String timeSinceCreation = _timeSinceCreation.inHours
            .toString()
            .padLeft(2, '0') +
        ':' +
        _timeSinceCreation.inMinutes.remainder(60).toString().padLeft(2, '0');

    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.blueAccent, // Color de fondo para el encabezado
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Orden #${widget.order.id} - ${_displayOrderType(widget.order.orderType)} - ${_displayOrderStatus(widget.order.status)}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Creado: $formattedCreationDate',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          TextSpan(
                            text: '  - $timeSinceCreation',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color: _getColorBasedOnTime(
                                        _timeSinceCreation)),
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
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          TextSpan(
                            text:
                                ' - Falta: ${_formatDuration(_timeUntilScheduled)}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildOrderDetails(context),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(BuildContext context) {
    List<Widget> orderDetails = [];

    Widget _buildSubHeaderDetail(String text) {
      return Container(
        color: Colors.blueGrey, // Color suave para el subencabezado
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        margin: EdgeInsets.only(bottom: 8.0),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.white),
        ),
      );
    }

    // Añadir detalles basados en el tipo de orden
    switch (widget.order.orderType) {
      case OrderType.delivery:
        orderDetails.add(_buildSubHeaderDetail(
          'Dirección: ${widget.order.deliveryAddress}\nTeléfono: ${widget.order.phoneNumber}',
        ));
        break;
      case OrderType.dineIn:
        orderDetails.add(_buildSubHeaderDetail(
          '${widget.order.area?.name} - ${widget.order.table?.number}',
        ));
        break;
      case OrderType.pickUpWait:
        orderDetails.add(_buildSubHeaderDetail(
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
        orderDetails.add(Divider(color: Colors.grey));
      }
      orderDetails.add(Text(
        orderItem.product?.name ?? 'Producto desconocido',
        style: Theme.of(context).textTheme.bodyLarge,
      ));

      if (orderItem.productVariant != null) {
        orderDetails.add(Text(
          orderItem.productVariant!.name,
          style: Theme.of(context).textTheme.bodyMedium,
        ));
      }

      orderItem.selectedModifiers?.forEach((modifier) {
        orderDetails.add(Text(
          modifier.modifier!.name,
          style: Theme.of(context).textTheme.bodySmall,
        ));
      });

      orderItem.selectedProductObservations?.forEach((observation) {
        orderDetails.add(Text(
          observation.productObservation!.name,
          style: Theme.of(context).textTheme.bodySmall,
        ));
      });
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
}
