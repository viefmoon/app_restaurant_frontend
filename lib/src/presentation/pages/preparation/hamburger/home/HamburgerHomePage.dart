import 'package:app/main.dart';
import 'package:app/src/presentation/pages/preparation/hamburger/HamburgerPreparationPage.dart';
import 'package:flutter/material.dart';
import 'bloc/HamburgerHomeBloc.dart';
import 'bloc/HamburgerHomeEvent.dart';
import 'bloc/HamburgerHomeState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HamburgerHomePage extends StatefulWidget {
  const HamburgerHomePage({Key? key});

  @override
  State<HamburgerHomePage> createState() => _HamburgerHomePageState();
}

class _HamburgerHomePageState extends State<HamburgerHomePage> {
  HamburgerHomeBloc? _bloc;

  List<Widget> pageList = <Widget>[
    HamburgerPreparationPage(),
  ];

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<HamburgerHomeBloc>(context, listen: false);
    // Disparar el evento de inicialización para cargar el nombre de usuario
    BlocProvider.of<HamburgerHomeBloc>(context, listen: false).add(InitEvent());
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<HamburgerHomeBloc>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('HAMBURGUESAS - PREPARACIÓN'),
        ),
        drawer: BlocBuilder<HamburgerHomeBloc, HamburgerHomeState>(
          builder: (context, state) {
            return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                      decoration: BoxDecoration(color: Colors.black),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.name ?? "Usuario",
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                          Text(
                            state.role ?? "Rol no disponible",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      )),
                  ListTile(
                    title: Text('Hamburguesas'),
                    selected: state.pageIndex == 0,
                    onTap: () {
                      _bloc?.add(HamburgerChangeDrawerPage(pageIndex: 0));
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Cerrar sesión'),
                    onTap: () {
                      _bloc?.add(Logout());
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp()),
                          (route) => false);
                    },
                  ),
                ],
              ),
            );
          },
        ),
        body: BlocBuilder<HamburgerHomeBloc, HamburgerHomeState>(
            builder: (context, state) {
          return pageList[state.pageIndex];
        }));
  }
}
