import 'package:equatable/equatable.dart';

abstract class KitchenHomeEvent extends Equatable {
  const KitchenHomeEvent();
  @override
  List<Object?> get props => [];
}

class KitchenChangeDrawerPage extends KitchenHomeEvent {
  final int pageIndex;
  const KitchenChangeDrawerPage({required this.pageIndex});
  @override
  List<Object?> get props => [pageIndex];
}

class LoadUser extends KitchenHomeEvent {
  const LoadUser();
}

class InitEvent extends KitchenHomeEvent {
  const InitEvent();
}

class Logout extends KitchenHomeEvent {
  const Logout();
}
