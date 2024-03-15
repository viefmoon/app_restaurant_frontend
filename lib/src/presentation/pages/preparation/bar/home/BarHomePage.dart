import 'package:app/main.dart';
import 'package:app/src/presentation/pages/preparation/bar/BarPreparationPage.dart';
import 'package:flutter/material.dart';
import 'bloc/BarHomeBloc.dart';
import 'bloc/BarHomeEvent.dart';
import 'bloc/BarHomeState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BarHomePage extends StatefulWidget {
  const BarHomePage({super.key});

  @override
  State<BarHomePage> createState() => _BarHomePageState();
}

class _BarHomePageState extends State<BarHomePage> {
  BarHomeBloc? _bloc;
  OrderFilterType _currentFilter = OrderFilterType.all; // Añade esta línea

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<BarHomeBloc>(context, listen: false);
    BlocProvider.of<BarHomeBloc>(context, listen: false).add(InitEvent());
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('BAR'),
      actions: <Widget>[
        Row(
          mainAxisSize: MainAxisSize
              .min, // Esto asegura que el Row no ocupe más espacio del necesario
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.local_shipping),
              iconSize: 40,
              onPressed: () {
                setState(() {
                  _currentFilter = OrderFilterType.delivery;
                });
                _bloc?.add(ChangeOrderFilterType(OrderFilterType.delivery));
              },
            ),
            SizedBox(width: 120), // Espaciado entre íconos
            IconButton(
              icon: Icon(Icons.restaurant),
              iconSize: 40,
              onPressed: () {
                setState(() {
                  _currentFilter = OrderFilterType.dineIn;
                });
                _bloc?.add(ChangeOrderFilterType(OrderFilterType.dineIn));
              },
            ),
            SizedBox(width: 120), // Espaciado entre íconos
            IconButton(
              icon: Icon(Icons.shopping_bag),
              iconSize: 40,
              onPressed: () {
                setState(() {
                  _currentFilter = OrderFilterType.pickUpWait;
                });
                _bloc?.add(ChangeOrderFilterType(OrderFilterType.pickUpWait));
              },
            ),
            SizedBox(width: 220),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<BarHomeBloc>(context);

    return Scaffold(
      appBar: _buildAppBar(),
      drawer: BlocBuilder<BarHomeBloc, BarHomeState>(
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
                  title: Text('Bar'),
                  selected: state.pageIndex == 0,
                  onTap: () {
                    _bloc?.add(BarChangeDrawerPage(pageIndex: 0));
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
      body: BlocBuilder<BarHomeBloc, BarHomeState>(
        builder: (context, state) {
          // Aquí decides qué página mostrar basado en el estado
          // Por simplicidad, siempre mostramos BarPreparationPage con el filtro actual
          return BarPreparationPage(filterType: _currentFilter);
        },
      ),
    );
  }
}
