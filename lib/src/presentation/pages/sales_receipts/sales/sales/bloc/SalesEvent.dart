import 'package:equatable/equatable.dart';

abstract class SalesEvent extends Equatable {
  const SalesEvent();

  @override
  List<Object> get props => [];
}

class ShowOrderTypeOptions extends SalesEvent {
  const ShowOrderTypeOptions();
}
