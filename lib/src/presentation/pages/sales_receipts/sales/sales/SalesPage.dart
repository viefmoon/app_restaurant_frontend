import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/sales/bloc/SalesBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/sales/bloc/SalesState.dart';
import 'SalesContent.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<SalesBloc>(
        create: (context) => SalesBloc(),
        child: BlocConsumer<SalesBloc, SalesState>(
          listener: (context, state) {},
          builder: (context, state) {
            final _bloc = BlocProvider.of<SalesBloc>(context);
            return SalesContent(_bloc, state);
          },
        ),
      ),
    );
  }
}
