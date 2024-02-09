import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'bloc/OrderTypeSelectionBloc.dart';
import 'OrderTypeSelectionContent.dart';
import 'bloc/OrderTypeSelectionEvent.dart';
import 'bloc/OrderTypeSelectionState.dart';

class OrderTypeSelectionPage extends StatefulWidget {
  const OrderTypeSelectionPage({super.key});

  @override
  State<OrderTypeSelectionPage> createState() => _OrderTypeSelectionPageState();
}

class _OrderTypeSelectionPageState extends State<OrderTypeSelectionPage> {
  OrderTypeSelectionBloc? _bloc;

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<OrderTypeSelectionBloc>(context);

    return Scaffold(
        body: SizedBox(
      width: double.infinity,
      child: BlocListener<OrderTypeSelectionBloc, OrderTypeSelectionState>(
          listener: (context, state) {
        // Aquí manejarías los estados específicos de la selección del tipo de orden
      }, child: BlocBuilder<OrderTypeSelectionBloc, OrderTypeSelectionState>(
              builder: (context, state) {
        // Aquí construirías el contenido de la página basado en el estado
        return OrderTypeSelectionContent(_bloc, state);
      })),
    ));
  }
}
