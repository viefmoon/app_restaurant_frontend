import 'package:equatable/equatable.dart';
// Importa tus modelos específicos aquí

abstract class OrderTypeSelectionEvent extends Equatable {
  const OrderTypeSelectionEvent();

  @override
  List<Object?> get props => [];
}

class OrderTypeSelectionInit extends OrderTypeSelectionEvent {
  const OrderTypeSelectionInit();
}

// Aquí agregarías otros eventos específicos para la selección del tipo de orden