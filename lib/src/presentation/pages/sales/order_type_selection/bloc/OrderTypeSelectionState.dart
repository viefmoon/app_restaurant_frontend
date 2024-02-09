import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
// Importa tus modelos específicos aquí

class OrderTypeSelectionState extends Equatable {
  // Aquí definirías las propiedades específicas del estado de la selección del tipo de orden
  final bool isLoading;
  final String? error;

  const OrderTypeSelectionState({this.isLoading = false, this.error});

  OrderTypeSelectionState copyWith({bool? isLoading, String? error}) {
    return OrderTypeSelectionState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, error];
}
