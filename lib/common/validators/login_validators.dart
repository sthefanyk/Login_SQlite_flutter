import 'dart:async';

class LoginValidators {
  final validateLogin =
      StreamTransformer<String, String>.fromHandlers(handleData: (login, sink) {
    if (login.length > 3) {
      sink.add(login);
    } else {
      sink.addError('Insira um login válido!');
    }
  });

  final validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length > 5) {
      sink.add(name);
    } else {
      sink.addError('Insira um nome válido!');
    }
  });

  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@') && email.contains('@') && email.length > 5) {
      sink.add(email);
    } else {
      sink.addError('Insira um email válido!');
    }
  });

  final validatePassword =
      StreamTransformer<String, String>.fromHandlers(handleData: (password, sink) {
    if (password.length > 3) {
      sink.add(password);
    } else {
      sink.addError('Senha deve conter pelo menos 4 caracteres!');
    }
  });
}
