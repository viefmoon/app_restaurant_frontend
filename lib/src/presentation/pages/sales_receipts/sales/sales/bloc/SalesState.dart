import 'package:equatable/equatable.dart';
import 'package:app/src/presentation/utils/BlocFormItem.dart';

class SalesState extends Equatable {
  final bool showOrderTypeOptions;

  const SalesState({
    this.showOrderTypeOptions = false,
  });

  SalesState copyWith({
    bool? showOrderTypeOptions,
    String? selectedOption,
    BlocFormItem? phoneNumber,
  }) {
    return SalesState(
      showOrderTypeOptions: showOrderTypeOptions ?? this.showOrderTypeOptions,
    );
  }

  @override
  List<Object> get props => [showOrderTypeOptions];
}
