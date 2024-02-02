import 'package:ecommerce_flutter/src/presentation/pages/auth/login/bloc/LoginBloc.dart';
import 'package:ecommerce_flutter/src/presentation/pages/auth/login/bloc/LoginEvent.dart';
import 'package:ecommerce_flutter/src/presentation/pages/auth/login/bloc/LoginState.dart';
import 'package:ecommerce_flutter/src/presentation/utils/BlocFormItem.dart';
import 'package:ecommerce_flutter/src/presentation/widgets/DefaultTextField.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginContent extends StatelessWidget {
  LoginBloc? bloc;
  LoginState state;

  LoginContent(this.bloc, this.state);

  @override
  Widget build(BuildContext context) {

    return Form(
      key: state.formKey,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _imageBackground(context),
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.3),
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // VERTICAL
              crossAxisAlignment: CrossAxisAlignment.center, // HORIZANTAL
              children: [
                _iconPerson(),
                _textLogin(),
                _textFieldEmail(), 
                _textFieldPassword(),
                _buttonLogin(context),
                _textDontHaveAccount(),
                _buttonGoToRegister(context)
              ],
            ),
          ),
        ],
      ),
    );

  }

  Widget _iconPerson() {
    return Icon(
      Icons.person,
      color: Colors.white,
      size: 125,
    );
  }

  Widget _textLogin() {
    return Text(
      'LOGIN',
      style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold),
    );
  }

  Widget _buttonGoToRegister(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 55,
      margin: EdgeInsets.only(left: 25, right: 25, top: 15),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, 'register');
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black),
        child: Text(
          'REGISTRATE',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _textDontHaveAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // HORIZANTAL
      children: [
        Container(
          width: 62,
          height: 1,
          color: Colors.white,
          margin: EdgeInsets.only(right: 5),
        ),
        Text(
          '¿No tienes cuenta?',
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
        Container(
          width: 62,
          height: 1,
          color: Colors.white,
          margin: EdgeInsets.only(left: 5),
        ),
      ],
    );
  }

  Widget _buttonLogin(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 55,
      margin: EdgeInsets.only(
          left: 25, right: 25, top: 25, bottom: 15),
      child: ElevatedButton(
        onPressed: () {
          if (state.formKey!.currentState!.validate()) {
            bloc?.add(LoginSubmit());  
          }
          else {
            Fluttertoast.showToast(
                msg: 'El formulario no es valido',
                toastLength: Toast.LENGTH_LONG);
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green
        ),
        child: Text(
          'INICIAR SESION',
          style: TextStyle(color: Colors.black),
        ),
      )
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25),
      child: DefaultTextField(
        label: 'Contraseña',
        icon: Icons.lock,
        // errorText: snapshot.error?.toString(),
        onChanged: (text) {
          bloc?.add(PasswordChanged(password: BlocFormItem(value: text)));
        },
        obscureText: true,
        validator: (value) {
          return state.password.error;
        },
      )
    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25),
      child: DefaultTextField(
        label: 'Correo electronico',
        icon: Icons.email,
        // errorText: snapshot.error?.toString(),
        onChanged: (text) {
          bloc?.add(EmailChanged(email: BlocFormItem(value: text)));
        },
        validator: (value) {
          return state.email.error;
        },
      )
    );
  } 

  Widget _imageBackground(BuildContext context) {
    return Image.asset(
      'assets/img/background3.jpg',
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      fit: BoxFit.cover,
      color: Color.fromRGBO(0, 0, 0, 0.7),
      colorBlendMode: BlendMode.darken,
    );
  }
}
