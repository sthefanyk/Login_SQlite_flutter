import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../common/blocs/login_bloc.dart';
import '../common/messages/messages.dart';
import '../common/routes/view_routes.dart';
import '../components/input_field_login.dart';
import '../components/user_login_header.dart';
import '../components/user_text_field.dart';
import '../external/database/db_sql_lite.dart';
import '../model/user_model.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _userLoginController = TextEditingController();
  final _userNameController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userPasswordController = TextEditingController();
  final _userPasswordConfirmController = TextEditingController();
  final _loginBloc = LoginBloc();

  @override
  void dispose() {
    _userLoginController.dispose();
    _userNameController.dispose();
    _userEmailController.dispose();
    _userPasswordController.dispose();
    _userPasswordConfirmController.dispose();
    super.dispose();
  }

  void signUp(BuildContext context) async {
    // Retorna TRUE em caso de
    // conteudo valido de todos os campos
    if (_formKey.currentState!.validate()) {
      if (_userPasswordController.text.trim() !=
          _userPasswordConfirmController.text.trim()) {
        MessagesApp.showCustom(context, MessagesApp.errorPasswordMistach);
        return;
      }
      UserModel user = UserModel(
          userId: _userLoginController.text.trim(),
          userName: _userNameController.text.trim(),
          userEmail: _userEmailController.text.trim(),
          userPassword: _userPasswordController.text.trim(),
          userType: 'client');

      final db = SqlLiteDb();
      db.saveUser(user).then(
        (value) {
          AwesomeDialog(
            context: context,
            headerAnimationLoop: false,
            dialogType: DialogType.success,
            title: MessagesApp.successUserInsert,
            btnOkOnPress: () => Navigator.pushNamedAndRemoveUntil(
                context, RoutesApp.home, (Route<dynamic> route) => false),
            btnOkText: 'OK',
          ).show(); // Message
        },
      ).catchError((error) {
        if (error.toString().contains('UNIQUE constraint failed')) {
          MessagesApp.showCustom(
            context,
            MessagesApp.errorUserExist,
          );
        } else {
          MessagesApp.showCustom(
            context,
            MessagesApp.errorDefault,
          );
        }
      });
      // await db.saveUser(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Login'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const UserLoginHeader('Cadastrar Login'),
                InputFieldLogin(
                  hintName: 'login',
                  icon: Icons.person,
                  controller: _userLoginController,
                  stream: _loginBloc.outLogin,
                  onChanged: _loginBloc.changedLogin,
                ),
                InputFieldLogin(
                  hintName: 'Nome',
                  icon: Icons.person_2_outlined,
                  controller: _userNameController,
                  stream: _loginBloc.outName,
                  onChanged: _loginBloc.changedName,
                ),
                InputFieldLogin(
                  hintName: 'Email',
                  icon: Icons.email,
                  controller: _userEmailController,
                  inputType: TextInputType.emailAddress,
                  stream: _loginBloc.outEmail,
                  onChanged: _loginBloc.changedEmail,
                ),
                InputFieldLogin(
                  isObscured: true,
                  hintName: 'Senha',
                  icon: Icons.lock,
                  controller: _userPasswordController,
                  stream: _loginBloc.outPassword,
                  onChanged: _loginBloc.changedPassword,
                ),
                InputFieldLogin(
                  isObscured: true,
                  hintName: 'Confirmação de Senha',
                  controller: _userPasswordConfirmController,
                  icon: Icons.lock,
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
                    stream: _loginBloc.outSubmitSingupValid,
                    builder: (context, snapshot) {
                      return ElevatedButton(
                        onPressed: snapshot.hasData ? () => signUp(context) : null,
                        style:
                            ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              disabledBackgroundColor: Colors.blue.withAlpha(140)
                            ),
                        child: const Text(
                          'Cadastrar',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }
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
