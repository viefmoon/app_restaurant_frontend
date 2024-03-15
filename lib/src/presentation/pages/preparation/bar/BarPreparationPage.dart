import 'package:app/src/domain/models/Order.dart';
import 'package:app/src/presentation/pages/preparation/bar/home/bloc/BarHomeState.dart';
import 'package:app/src/presentation/widgets/OrderPreparationWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart'; // Importa flutter/services.dart
import 'package:app/src/presentation/pages/preparation/bar/bloc/BarPreparationBloc.dart';
import 'package:app/src/presentation/pages/preparation/bar/bloc/BarPreparationState.dart';

class BarPreparationPage extends StatefulWidget {
  final OrderFilterType filterType; // Usa el enum de BarHomeState

  const BarPreparationPage({Key? key, this.filterType = OrderFilterType.all})
      : super(key: key);

  @override
  _BarPreparationPageState createState() => _BarPreparationPageState();
}

class _BarPreparationPageState extends State<BarPreparationPage> {
  @override
  void initState() {
    super.initState();
    // Establece la orientación preferida a horizontal al entrar a la página
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    // Restablece la orientación a la predeterminada al salir de la página
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BarPreparationBloc, BarPreparationState>(
        builder: (context, state) {
          final orders = state.orders ?? [];
          final filteredOrders = orders.where((order) {
            print("widget.filterType: ${widget.filterType}");
            // Aquí usas widget.filterType para filtrar
            switch (widget.filterType) {
              case OrderFilterType.delivery:
                return order.orderType == OrderType.delivery;
              case OrderFilterType.dineIn:
                return order.orderType == OrderType.dineIn;
              case OrderFilterType.pickUpWait:
                return order.orderType == OrderType.pickUpWait;
              case OrderFilterType.all:
              default:
                return true;
            }
          }).toList();

          if (filteredOrders.isEmpty) {
            return Center(child: Text('No hay pedidos para mostrar.'));
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredOrders.length, // Usa filteredOrders.length aquí
            itemBuilder: (context, index) {
              final order = filteredOrders[
                  index]; // Usa filteredOrders para obtener la orden
              return OrderPreparationWidget(
                  order:
                      order); // Utiliza el widget personalizado para cada orden
            },
          );
        },
      ),
    );
  }
}
