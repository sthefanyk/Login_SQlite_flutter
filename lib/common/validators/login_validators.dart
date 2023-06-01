import 'dart:async';

class LoginValidators {
  final validateLogin =
      StreamTransformer<String, String>.fromHandlers(handleData: (login, sink) {
    if (login.length > 3) {
      sink.add(login);
    } else {
      sink.addError('Login deve conter pelo menos 4 caracteres!');
    }
  });

  final validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length > 2) {
      sink.add(name);
    } else {
      sink.addError('Nome deve conter pelo menos 3 caracteres!');
    }
  });

  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@') && email.contains('.') && email.length > 5) {
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
