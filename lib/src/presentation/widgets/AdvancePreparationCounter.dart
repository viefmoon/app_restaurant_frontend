import 'package:flutter/material.dart';
import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/domain/models/OrderItem.dart';

class AdvancePreparationCounter extends StatefulWidget {
  final List<Order> orders;

  const AdvancePreparationCounter({Key? key, required this.orders})
      : super(key: key);

  @override
  _AdvancePreparationCounterState createState() =>
      _AdvancePreparationCounterState();
}

class _AdvancePreparationCounterState extends State<AdvancePreparationCounter> {
  List<OrderItem> _advancePreparationItems = [];

  @override
  void initState() {
    super.initState();
    _updateAdvancePreparationItems();
  }

  @override
  void didUpdateWidget(covariant AdvancePreparationCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.orders != oldWidget.orders) {
      _updateAdvancePreparationItems();
    }
  }

  void _updateAdvancePreparationItems() {
    _advancePreparationItems = widget.orders
        .expand((order) => order.orderItems ?? [])
        .where((item) =>
            item.isBeingPreparedInAdvance == true &&
            item.status != OrderItemStatus.prepared)
        .toList()
        .cast<OrderItem>();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16.0,
      bottom: 80.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preparación anticipada',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              '${_advancePreparationItems.length} items',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 8.0),
            ..._advancePreparationItems.map((item) {
              final name = item.productVariant?.name ??
                  item.product?.name ??
                  'Producto desconocido';
              return Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
