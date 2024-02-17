import 'package:equatable/equatable.dart';
import 'package:app/src/presentation/utils/BlocFormItem.dart';

class SalesState extends Equatable {
  final bool showOrderTypeOptions;
  final String? selectedOrderTypeOption;
  final BlocFormItem phoneNumber;

  const SalesState({
    this.showOrderTypeOptions = false,
    this.selectedOrderTypeOption,
    this.phoneNumber =
        const BlocFormItem(error: 'Ingresa el numero de teléfono'),
  });

  SalesState copyWith({
    bool? showOrderTypeOptions,
    String? selectedOption,
    BlocFormItem? phoneNumber,
  }) {
    return SalesState(
      showOrderTypeOptions: showOrderTypeOptions ?? this.showOrderTypeOptions,
      selectedOrderTypeOption:
          selectedOrderTypeOption ?? this.selectedOrderTypeOption,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object> get props =>
      [showOrderTypeOptions, selectedOrderTypeOption ?? '', phoneNumber];
}
