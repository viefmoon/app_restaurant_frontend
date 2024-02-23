import 'package:app/src/presentation/pages/sales_receipts/sales/table_selection/bloc/TableSelectionEvent.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/table_selection/bloc/TableSelectionState.dart';
import 'package:app/src/presentation/utils/IdentifierState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:app/src/domain/useCases/areas/AreasUseCases.dart';
import 'package:app/src/domain/utils/Resource.dart';

import 'package:app/src/domain/models/Area.dart';
import 'package:app/src/domain/models/Table.dart' as appModel;

class TableSelectionBloc
    extends Bloc<TableSelectionEvent, TableSelectionState> {
  AreasUseCases areasUseCases;

  TableSelectionBloc(this.areasUseCases) : super(TableSelectionState()) {
    on<TableSelectionInitEvent>(_onInitEvent);
    on<AreaSelected>(_onAreaSelected);
    on<TableSelected>(_onTableSelected);
    on<LoadAreas>(_onLoadAreas);
    on<LoadTables>(_onLoadTables);
  }

  final formKey = GlobalKey<FormState>();

  Future<void> _onInitEvent(
      TableSelectionInitEvent event, Emitter<TableSelectionState> emit) async {
    emit(state.copyWith(formKey: formKey));
    await _onLoadAreas(LoadAreas(), emit);
    print('Areas cargadas');
  }

  Future<void> _onAreaSelected(
      AreaSelected event, Emitter<TableSelectionState> emit) async {
    emit(state.copyWith(
        selectedArea: IdentifierState(
            id: event.areaId.id,
            error: event.areaId.id != 0 ? null : 'Selecciona un área'),
        formKey: formKey));
    // Cargar las mesas después de seleccionar un área
    await _onLoadTables(LoadTables(event.areaId), emit);
  }

  Future<void> _onTableSelected(
      TableSelected event, Emitter<TableSelectionState> emit) async {
    emit(state.copyWith(
        selectedTable: IdentifierState(
            id: event.tableId.id,
            error: event.tableId.id != 0 ? null : 'Selecciona una mesa'),
        formKey: formKey));
  }

  Future<void> _onLoadAreas(
      LoadAreas event, Emitter<TableSelectionState> emit) async {
    emit(state.copyWith(response: Loading(), formKey: formKey));
    print('Cargando areas...');
    try {
      Resource response = await areasUseCases.getAreas.run();
      print('Areas cargadas');
      if (response is Success<List<Area>>) {
        List<Area> areas = response.data;
        print('Areas: $areas');
        emit(state.copyWith(
            areas: areas, response: Success(areas), formKey: formKey));
      } else {
        print('Error cargando areas: $response');
        emit(state.copyWith(areas: [], response: response, formKey: formKey));
      }
    } catch (e) {
      print('Error cargando areas: $e');
      emit(state.copyWith(
          areas: [], response: Error(e.toString()), formKey: formKey));
    }
  }

  Future<void> _onLoadTables(
      LoadTables event, Emitter<TableSelectionState> emit) async {
    emit(state.copyWith(response: Loading(), formKey: formKey));
    try {
      print('Cargando mesas...');
      Resource response =
          await areasUseCases.getTablesFromArea.run(event.areaId.id);
      if (response is Success<List<appModel.Table>>) {
        // Asume que Table es tu modelo de mesa
        List<appModel.Table> tables = response.data;
        emit(state.copyWith(
            tables: tables, response: Success(tables), formKey: formKey));
      } else {
        emit(state.copyWith(tables: [], response: response, formKey: formKey));
      }
    } catch (e) {
      emit(state.copyWith(
          tables: [], response: Error(e.toString()), formKey: formKey));
    }
  }
}
