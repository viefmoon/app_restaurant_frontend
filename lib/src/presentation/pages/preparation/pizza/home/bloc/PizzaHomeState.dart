import 'package:equatable/equatable.dart';

class PizzaHomeState extends Equatable {
  final int pageIndex;
  final String? name;
  final String? role;

  const PizzaHomeState({this.pageIndex = 0, this.name, this.role});

  PizzaHomeState copyWith({int? pageIndex, String? name, String? role}) {
    return PizzaHomeState(
      pageIndex: pageIndex ?? this.pageIndex,
      name: name ?? this.name,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [pageIndex];
}
