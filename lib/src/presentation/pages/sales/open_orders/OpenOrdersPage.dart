import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'bloc/OpenOrdersBloc.dart';
import 'OpenOrdersContent.dart';
import 'bloc/OpenOrdersEvent.dart';
import 'bloc/OpenOrdersState.dart';

class OpenOrdersPage extends StatefulWidget {
  const OpenOrdersPage({super.key});

  @override
  State<OpenOrdersPage> createState() => _OpenOrdersPageState();
}

class _OpenOrdersPageState extends State<OpenOrdersPage> {
  OpenOrdersBloc? _bloc;

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<OpenOrdersBloc>(context);

    return Scaffold(
        body: SizedBox(
      width: double.infinity,
      child: BlocListener<OpenOrdersBloc, OpenOrdersState>(
          listener: (context, state) {
        // Aquí manejarías los estados específicos de las órdenes abiertas
      }, child: BlocBuilder<OpenOrdersBloc, OpenOrdersState>(
              builder: (context, state) {
        // Aquí construirías el contenido de la página basado en el estado
        return OpenOrdersContent(_bloc, state);
      })),
    ));
  }
}
