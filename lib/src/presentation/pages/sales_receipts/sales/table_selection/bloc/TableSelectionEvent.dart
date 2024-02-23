import 'package:equatable/equatable.dart';
import 'package:app/src/presentation/utils/IdentifierState.dart';

abstract class TableSelectionEvent extends Equatable {
  const TableSelectionEvent();
  @override
  List<Object?> get props => [];
}

class TableSelectionInitEvent extends TableSelectionEvent {
  const TableSelectionInitEvent();
}

class LoadAreas extends TableSelectionEvent {
  const LoadAreas();
}

class LoadTables extends TableSelectionEvent {
  final IdentifierState areaId;
  const LoadTables(this.areaId);
  @override
  List<Object?> get props => [areaId];
}

class AreaSelected extends TableSelectionEvent {
  final IdentifierState areaId;
  const AreaSelected({required this.areaId});
  @override
  List<Object?> get props => [areaId];
}

class TableSelected extends TableSelectionEvent {
  final IdentifierState tableId;
  const TableSelected({required this.tableId});
  @override
  List<Object?> get props => [tableId];
}

class TableSelectionContinue extends TableSelectionEvent {
  const TableSelectionContinue();
}
