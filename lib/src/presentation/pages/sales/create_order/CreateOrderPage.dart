import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'bloc/CreateOrderBloc.dart';
import 'CreateOrderContent.dart';
import 'bloc/CreateOrderEvent.dart';
import 'bloc/CreateOrderState.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key});

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  CreateOrderBloc? _bloc;

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<CreateOrderBloc>(context);

    return Scaffold(
        body: SizedBox(
      width: double.infinity,
      child: BlocListener<CreateOrderBloc, CreateOrderState>(
          listener: (context, state) {
        // Aquí manejarías los estados específicos de la creación de órdenes
      }, child: BlocBuilder<CreateOrderBloc, CreateOrderState>(
              builder: (context, state) {
        // Aquí construirías el contenido de la página basado en el estado
        return CreateOrderContent(_bloc, state);
      })),
    ));
  }
}
