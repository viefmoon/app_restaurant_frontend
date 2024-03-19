import 'package:app/main.dart';
import 'package:app/src/presentation/pages/preparation/bar/BarPreparationPage.dart';
import 'package:app/src/presentation/pages/setting/SettingsPage.dart'; // Added import for SettingsPage
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
  OrderFilterType _currentFilter = OrderFilterType.all;
  int _currentPageIndex = 0;
  bool _filterByPrepared = false;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<BarHomeBloc>(context, listen: false);
    _bloc!.add(InitEvent());
  }

  AppBar _buildAppBar() {
    double screenWidth = MediaQuery.of(context).size.width;

    IconButton _buildIconButton(IconData icon, OrderFilterType filterType) {
      return IconButton(
        icon: Icon(icon),
        iconSize: 40,
        onPressed: () {
          setState(() {
            _currentFilter = filterType;
          });
          _bloc?.add(ChangeOrderFilterType(filterType));
        },
      );
    }

    return AppBar(
      title: Text(
        'BAR',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        if (_currentPageIndex == 0)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildIconButton(Icons.filter_list, OrderFilterType.all),
              SizedBox(width: screenWidth * 0.12),
              _buildIconButton(Icons.local_shipping, OrderFilterType.delivery),
              SizedBox(width: screenWidth * 0.12),
              _buildIconButton(Icons.restaurant, OrderFilterType.dineIn),
              SizedBox(width: screenWidth * 0.12),
              _buildIconButton(Icons.shopping_bag, OrderFilterType.pickUpWait),
              SizedBox(width: screenWidth * 0.17),
              IconButton(
                iconSize: 40,
                icon: Icon(_filterByPrepared
                    ? Icons.check_box
                    : Icons.check_box_outline_blank),
                onPressed: () {
                  setState(() {
                    _filterByPrepared = !_filterByPrepared;
                  });
                },
              ),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pageList = <Widget>[
      BarPreparationPage(
          filterType: _currentFilter, filterByPrepared: _filterByPrepared),
      SettingsPage(),
    ];

    return Theme(
      data: ThemeData(
        primaryColor: Colors.orange, // Color primario
        scaffoldBackgroundColor: Colors.white, // Color de fondo del Scaffold
        appBarTheme: AppBarTheme(
          color: Colors.orange, // Color de la AppBar
          iconTheme: IconThemeData(
              color: Colors.white), // Color de los iconos de la AppBar
        ),
        // Otros colores y estilos que desees personalizar
      ),
      child: Scaffold(
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
                    selected: _currentPageIndex == 0,
                    onTap: () {
                      setState(() {
                        _currentPageIndex =
                            0; // Actualiza el índice de la página actual a 0
                      });
                      _bloc?.add(BarChangeDrawerPage(pageIndex: 0));
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Configuración'),
                    selected: _currentPageIndex == 1,
                    onTap: () {
                      setState(() {
                        _currentPageIndex =
                            1; // Cambia el índice de la página actual a 1
                      });
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
        body: pageList[
            _currentPageIndex], // Display the page based on _currentPageIndex
      ),
    );
  }
}
