import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationEvent.dart';

class TableSelectionPage extends StatefulWidget {
  const TableSelectionPage({Key? key}) : super(key: key);

  @override
  _TableSelectionPageState createState() => _TableSelectionPageState();
}

class _TableSelectionPageState extends State<TableSelectionPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final OrderCreationBloc bloc =
          BlocProvider.of<OrderCreationBloc>(context);
      bloc.add(LoadAreas());
    });
  }

  @override
  Widget build(BuildContext context) {
    final OrderCreationBloc bloc = BlocProvider.of<OrderCreationBloc>(context);

    return BlocBuilder<OrderCreationBloc, OrderCreationState>(
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(height: 250),
            _buildAreaDropdown(bloc, state),
            SizedBox(height: 20),
            if (state.selectedAreaId != null) _buildTableDropdown(bloc, state),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  state.selectedAreaId != null && state.selectedTableId != null
                      ? () => bloc.add(TableSelectionContinue())
                      : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 30),
              ),
              child: Text('Continuar', style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 10),
          ],
        );
      },
    );
  }

  Widget _buildAreaDropdown(OrderCreationBloc bloc, OrderCreationState state) {
    return InputDecorator(
      decoration:
          InputDecoration(labelText: 'Área', border: OutlineInputBorder()),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          key: ValueKey<int?>(state.selectedAreaId),
          value: state.selectedAreaId,
          isExpanded: true,
          onChanged: (int? newValue) {
            if (newValue != null) {
              bloc.add(AreaSelected(areaId: newValue));
            }
          },
          items: state.areas?.map<DropdownMenuItem<int>>((area) {
                return DropdownMenuItem<int>(
                  value: area.id!,
                  child: Text(area.name!),
                );
              }).toList() ??
              [],
        ),
      ),
    );
  }

  Widget _buildTableDropdown(OrderCreationBloc bloc, OrderCreationState state) {
    return InputDecorator(
      decoration:
          InputDecoration(labelText: 'Mesa', border: OutlineInputBorder()),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          key: ValueKey<int?>(state.selectedTableId),
          value:
              state.tables?.any((table) => table.id == state.selectedTableId) ??
                      false
                  ? state.selectedTableId
                  : null,
          isExpanded: true,
          onChanged: (int? newValue) {
            if (newValue != null) {
              bloc.add(TableSelected(tableId: newValue));
            }
          },
          items: state.tables
                  ?.where((table) => table.status?.name == 'Disponible')
                  .map<DropdownMenuItem<int>>((table) {
                return DropdownMenuItem<int>(
                  value: table.id,
                  child: Text(table.number.toString()),
                );
              }).toList() ??
              [],
        ),
      ),
    );
  }
}
