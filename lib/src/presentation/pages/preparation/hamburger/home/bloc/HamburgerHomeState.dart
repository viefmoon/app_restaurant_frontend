import 'package:equatable/equatable.dart';

class HamburgerHomeState extends Equatable {
  final int pageIndex;
  final String? name;
  final String? role;

  const HamburgerHomeState({this.pageIndex = 0, this.name, this.role});

  HamburgerHomeState copyWith({int? pageIndex, String? name, String? role}) {
    return HamburgerHomeState(
      pageIndex: pageIndex ?? this.pageIndex,
      name: name ?? this.name,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [pageIndex];
}
