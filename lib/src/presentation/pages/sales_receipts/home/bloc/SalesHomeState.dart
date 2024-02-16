import 'package:equatable/equatable.dart';

class SalesHomeState extends Equatable {

  final int pageIndex;

  const SalesHomeState({ this.pageIndex = 0 });

  SalesHomeState copyWith({
    int? pageIndex
  }) {
    return SalesHomeState(pageIndex: pageIndex ?? this.pageIndex);
  }

  @override
  List<Object?> get props => [pageIndex];

}