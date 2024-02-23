import 'package:app/src/presentation/utils/IdentifierState.dart';
import 'package:flutter/material.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/table_selection/bloc/TableSelectionBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/table_selection/bloc/TableSelectionEvent.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/table_selection/bloc/TableSelectionState.dart';

class TableSelectionContent extends StatelessWidget {
  final TableSelectionBloc? bloc;
  final TableSelectionState state;

  const TableSelectionContent(this.bloc, this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: state.formKey,
      child: Column(
        children: [
          SizedBox(height: 250), // Separación después del inicio del formulario
          _buildAreaDropdown(state),
          SizedBox(height: 20), // Separación entre dropdowns
          if (state.selectedArea != null) _buildTableDropdown(state),
          SizedBox(height: 20), // Separación antes del botón
          ElevatedButton(
            onPressed: () {
              if (state.formKey?.currentState?.validate() ?? false) {
                bloc?.add(TableSelectionContinue());
              }
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                  horizontal: 70, vertical: 30), // Aumento del tamaño del botón
            ),
            child: Text('Continuar',
                style: TextStyle(fontSize: 20)), // Tamaño de texto aumentado
          ),
          SizedBox(height: 10), // Separación después del botón
        ],
      ),
    );
  }

  Widget _buildAreaDropdown(TableSelectionState state) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Área',
        border: OutlineInputBorder(),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: state.selectedArea?.id,
          isExpanded: true,
          onChanged: (int? newValue) {
            if (newValue != null) {
              bloc?.add(AreaSelected(areaId: IdentifierState(id: newValue)));
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

  Widget _buildTableDropdown(TableSelectionState state) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Mesa',
        border: OutlineInputBorder(),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: state.selectedTable?.id,
          isExpanded: true,
          onChanged: (int? newValue) {
            if (newValue != null) {
              bloc?.add(TableSelected(tableId: IdentifierState(id: newValue)));
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
