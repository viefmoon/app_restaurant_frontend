import 'package:equatable/equatable.dart';

class BarHomeState extends Equatable {
  final int pageIndex;
  final String? name;
  final String? role;

  const BarHomeState({this.pageIndex = 0, this.name, this.role});

  BarHomeState copyWith({int? pageIndex, String? name, String? role}) {
    return BarHomeState(
      pageIndex: pageIndex ?? this.pageIndex,
      name: name ?? this.name,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [pageIndex];
}
