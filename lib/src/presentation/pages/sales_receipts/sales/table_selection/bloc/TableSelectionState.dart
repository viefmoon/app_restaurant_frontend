import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:app/src/presentation/utils/IdentifierState.dart'; // Asegúrate de importar IdentifierState
import 'package:app/src/domain/models/Area.dart';
import 'package:app/src/domain/models/Table.dart' as app_models;
import 'package:app/src/domain/utils/Resource.dart';

class TableSelectionState extends Equatable {
  final List<Area>? areas;
  final List<app_models.Table>? tables;
  final IdentifierState? selectedArea;
  final IdentifierState? selectedTable;
  final GlobalKey<FormState>? formKey;
  final Resource? response;

  const TableSelectionState({
    this.areas,
    this.tables,
    this.selectedArea,
    this.selectedTable,
    this.formKey,
    this.response,
  });

  TableSelectionState copyWith({
    List<Area>? areas,
    List<app_models.Table>? tables,
    IdentifierState? selectedArea,
    IdentifierState? selectedTable,
    GlobalKey<FormState>? formKey,
    Resource? response,
  }) {
    return TableSelectionState(
      areas: areas ?? this.areas,
      tables: tables ?? this.tables,
      selectedArea: selectedArea ?? this.selectedArea,
      selectedTable: selectedTable ?? this.selectedTable,
      formKey: formKey,
      response: response,
    );
  }

  @override
  List<Object?> get props =>
      [areas, tables, selectedArea, selectedTable, formKey, response];
}
