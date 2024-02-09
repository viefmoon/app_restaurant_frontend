import 'package:equatable/equatable.dart';
// Importa tus modelos específicos aquí

abstract class OpenOrdersEvent extends Equatable {
  const OpenOrdersEvent();

  @override
  List<Object?> get props => [];
}

class OpenOrdersInit extends OpenOrdersEvent {
  const OpenOrdersInit();
}

// Aquí agregarías otros eventos específicos para las órdenes abiertas