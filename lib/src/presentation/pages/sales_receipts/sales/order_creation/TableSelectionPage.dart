import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationEvent.dart';

class TableSelectionPage extends StatelessWidget {
  const TableSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Accede al Bloc directamente desde el contexto
    final OrderCreationBloc bloc = BlocProvider.of<OrderCreationBloc>(context);

    // Usa BlocBuilder para reconstruir solo este widget basado en cambios de estado
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
              onPressed: () => bloc.add(TableSelectionContinue()),
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
    // Usa una ValueKey basada en el valor seleccionado para forzar la reconstrucción del widget
    return InputDecorator(
      decoration:
          InputDecoration(labelText: 'Área', border: OutlineInputBorder()),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          key: ValueKey<int?>(
              state.selectedAreaId), // Clave que cambia con el estado
          value: state.selectedAreaId,
          isExpanded: true,
          onChanged: (int? newValue) {
            if (newValue != null) {
              bloc.add(AreaSelected(areaId: newValue));
            }
          },
          items: state.areas?.map<DropdownMenuItem<int>>((area) {
                return DropdownMenuItem<int>(
                  value: area.id,
                  child: Text(area.name),
                );
              }).toList() ??
              [],
        ),
      ),
    );
  }

  Widget _buildTableDropdown(OrderCreationBloc bloc, OrderCreationState state) {
    // Usa una ValueKey basada en el valor seleccionado para forzar la reconstrucción del widget
    return InputDecorator(
      decoration:
          InputDecoration(labelText: 'Mesa', border: OutlineInputBorder()),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          key: ValueKey<int?>(
              state.selectedTableId), // Clave que cambia con el estado
          value: state.selectedTableId,
          isExpanded: true,
          onChanged: (int? newValue) {
            if (newValue != null) {
              bloc.add(TableSelected(tableId: newValue));
            }
          },
          items: state.tables
                  ?.where((table) => table.status.name == 'Disponible')
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
