import 'package:flutter/material.dart';
import 'package:login_with_sqllite/common/blocs/login_bloc.dart';

import '../common/messages/messages.dart';
import '../common/routes/view_routes.dart';
import '../components/input_field_login.dart';
import '../components/user_login_header.dart';
import '../external/database/db_sql_lite.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _userLoginController = TextEditingController();
  final _userPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _loginBloc = LoginBloc();

  @override
  void dispose() {
    _userLoginController.dispose();
    _userPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login With Signup'),
        //automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const UserLoginHeader('Login'),
                InputFieldLogin(
                  hintName: 'Login',
                  icon: Icons.person_2_outlined,
                  controller: _userLoginController,
                  stream: _loginBloc.outLogin,
                  onChanged: _loginBloc.changedLogin,
                ),
                InputFieldLogin(
                  isObscured: true,
                  hintName: 'Senha',
                  icon: Icons.lock,
                  controller: _userPasswordController,
                  stream: _loginBloc.outPassword,
                  onChanged: _loginBloc.changedPassword,
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 30,
                    left: 80,
                    right: 80,
                  ),
                  width: double.infinity,
                  child: StreamBuilder<bool>(
                    stream: _loginBloc.outSubmitValid,
                    builder: (context, snapshot) {
                      return ElevatedButton(
                        onPressed: snapshot.hasData ? () {
                          if (_formKey.currentState!.validate()) {
                            final db = SqlLiteDb();
                            db
                                .getLoginUser(
                              _userLoginController.text.trim(),
                              _userPasswordController.text.trim(),
                            )
                                .then(
                              (user) {
                                if (user == null) {
                                  MessagesApp.showCustom(
                                      context, MessagesApp.errorUserNoExist);
                                } else if (user.userType == 'admin') {
                                  Navigator.pushNamed(
                                    context,
                                    RoutesApp.adminPage,
                                    arguments: user,
                                  );
                                } else {
                                  Navigator.pushNamed(
                                    context,
                                    RoutesApp.loginUpdate,
                                    arguments: user,
                                  );
                                }
                              },
                            ).catchError(
                              (_) => MessagesApp.showCustom(
                                  context, MessagesApp.errorDefault),
                            );
                          }
                        } : null,
                        style:
                            ElevatedButton.styleFrom(
                              shape: const StadiumBorder(), 
                              disabledBackgroundColor: Colors.blue.withAlpha(140)),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 10,
                    right: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Possui uma Conta???'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              RoutesApp.loginSgnup,
                              (Route<dynamic> route) => false);
                        },
                        child: const Text('Cadastra-se'),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
