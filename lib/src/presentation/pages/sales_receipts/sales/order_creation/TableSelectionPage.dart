import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/TableSelectionContent.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationState.dart';

class TableSelectionPage extends StatefulWidget {
  const TableSelectionPage({super.key});

  @override
  State<TableSelectionPage> createState() => _TableSelectionPageState();
}

class _TableSelectionPageState extends State<TableSelectionPage> {
  OrderCreationBloc? _bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<OrderCreationBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona una mesa'),
      ),
      body: BlocListener<OrderCreationBloc, OrderCreationState>(
        listener: (context, state) {
          if (state.response is Error) {
            Fluttertoast.showToast(
                msg: "Error al cargar datos", toastLength: Toast.LENGTH_LONG);
          }
        },
        child: BlocBuilder<OrderCreationBloc, OrderCreationState>(
          builder: (context, state) {
            return TableSelectionContent(_bloc, state);
          },
        ),
      ),
    );
  }
}
