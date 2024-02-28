import 'package:flutter/material.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationEvent.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/order_creation/bloc/OrderCreationState.dart';

class TableSelectionContent extends StatelessWidget {
  final OrderCreationBloc? bloc;
  final OrderCreationState state;

  const TableSelectionContent(this.bloc, this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 250), // Separación después del inicio del formulario
        _buildAreaDropdown(state),
        SizedBox(height: 20), // Separación entre dropdowns
        if (state.selectedAreaId != null) _buildTableDropdown(state),
        SizedBox(height: 20), // Separación antes del botón
        ElevatedButton(
          onPressed: () => bloc?.add(TableSelectionContinue()),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
                horizontal: 70, vertical: 30), // Aumento del tamaño del botón
          ),
          child: Text('Continuar',
              style: TextStyle(fontSize: 20)), // Tamaño de texto aumentado
        ),
        SizedBox(height: 10), // Separación después del botón
      ],
    );
  }

  Widget _buildAreaDropdown(OrderCreationState state) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Área',
        border: OutlineInputBorder(),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: state.selectedAreaId,
          isExpanded: true,
          onChanged: (int? newValue) {
            if (newValue != null) {
              bloc?.add(AreaSelected(areaId: newValue));
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

  Widget _buildTableDropdown(OrderCreationState state) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Mesa',
        border: OutlineInputBorder(),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: state.selectedTableId,
          isExpanded: true,
          onChanged: (int? newValue) {
            if (newValue != null) {
              bloc?.add(TableSelected(tableId: newValue));
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
