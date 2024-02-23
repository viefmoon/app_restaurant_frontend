import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/table_selection/TableSelectionContent.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/table_selection/bloc/TableSelectionBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/table_selection/bloc/TableSelectionState.dart';

class TableSelectionPage extends StatefulWidget {
  const TableSelectionPage({super.key});

  @override
  State<TableSelectionPage> createState() => _TableSelectionPageState();
}

class _TableSelectionPageState extends State<TableSelectionPage> {
  TableSelectionBloc? _bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<TableSelectionBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona una mesa'),
      ),
      body: BlocListener<TableSelectionBloc, TableSelectionState>(
        listener: (context, state) {
          if (state.response is Error) {
            Fluttertoast.showToast(
                msg: "Error al cargar datos", toastLength: Toast.LENGTH_LONG);
          }
        },
        child: BlocBuilder<TableSelectionBloc, TableSelectionState>(
          builder: (context, state) {
            return TableSelectionContent(_bloc, state);
          },
        ),
      ),
    );
  }
}
