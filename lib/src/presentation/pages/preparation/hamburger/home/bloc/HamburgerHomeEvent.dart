import 'package:equatable/equatable.dart';

abstract class HamburgerHomeEvent extends Equatable {
  const HamburgerHomeEvent();
  @override
  List<Object?> get props => [];
}

class HamburgerChangeDrawerPage extends HamburgerHomeEvent {
  final int pageIndex;
  const HamburgerChangeDrawerPage({required this.pageIndex});
  @override
  List<Object?> get props => [pageIndex];
}

class LoadUser extends HamburgerHomeEvent {
  const LoadUser();
}

class InitEvent extends HamburgerHomeEvent {
  const InitEvent();
}

class Logout extends HamburgerHomeEvent {
  const Logout();
}
