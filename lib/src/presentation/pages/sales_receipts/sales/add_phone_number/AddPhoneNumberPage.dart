import 'package:app/src/presentation/pages/sales_receipts/sales/add_phone_number/bloc/AddPhoneNumberBloc.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/add_phone_number/bloc/AddPhoneNumberEvent.dart';
import 'package:app/src/presentation/pages/sales_receipts/sales/add_phone_number/bloc/AddPhoneNumberState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPhoneNumberPage extends StatefulWidget {
  const AddPhoneNumberPage({Key? key}) : super(key: key);

  @override
  State<AddPhoneNumberPage> createState() => _AddPhoneNumberPageState();
}

class _AddPhoneNumberPageState extends State<AddPhoneNumberPage> {
  late AddPhoneNumberBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc =
        AddPhoneNumberBloc(); // Asegúrate de proporcionar el BLoC correctamente si estás usando inyección de dependencias o algún contenedor de estado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Número de Teléfono'),
      ),
      body: BlocProvider<AddPhoneNumberBloc>(
        create: (_) => _bloc,
        child: BlocBuilder<AddPhoneNumberBloc, AddPhoneNumberState>(
          builder: (context, state) {
            return Form(
              key: _bloc.state.formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Número de teléfono'),
                      onChanged: (value) =>
                          _bloc.add(PhoneNumberChanged(value)),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _bloc.add(PhoneNumberSubmitted()),
                      child: Text('Continuar'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
