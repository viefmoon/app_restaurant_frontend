import 'package:equatable/equatable.dart';

class KitchenHomeState extends Equatable {
  final int pageIndex;
  final String? name;
  final String? role;

  const KitchenHomeState({this.pageIndex = 0, this.name, this.role});

  KitchenHomeState copyWith({int? pageIndex, String? name, String? role}) {
    return KitchenHomeState(
      pageIndex: pageIndex ?? this.pageIndex,
      name: name ?? this.name,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [pageIndex];
}
