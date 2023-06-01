import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:login_with_sqllite/common/validators/login_validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends BlocBase with LoginValidators {
  final _loginController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Stream<String> get outLogin =>
      _loginController.stream.transform(validateLogin);
  Stream<String> get outName =>
      _nameController.stream.transform(validateName);
  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get outPassword =>
      _passwordController.stream.transform(validatePassword);

  Stream<bool> get outSubmitValid => Rx.combineLatest2(
    outLogin, outPassword, (a, b) => true
  );

  Function(String) get changedLogin => _loginController.sink.add;
  Function(String) get changedName => _nameController.sink.add;
  Function(String) get changedEmail => _emailController.sink.add;
  Function(String) get changedPassword => _passwordController.sink.add;

  @override
  void dispose() {
    _loginController.close();
    _nameController.close();
    _emailController.close();
    _passwordController.close();
    super.dispose();
  }
}
