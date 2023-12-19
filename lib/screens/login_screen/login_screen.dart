import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/screens/common/confirmation_dialog.dart';
import 'package:flutter_webapi_first_course/screens/common/exception_dialog.dart';
import 'package:flutter_webapi_first_course/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService service = AuthService();
  final _formKey = GlobalKey<FormState>();
  final bool isValid = false;
  bool valueValidator(String? value) {
    if (value != null && value.isEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(32),
        decoration:
            BoxDecoration(border: Border.all(width: 8), color: Colors.white),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Expanded(
                child: Column(
                  children: [
                    const Icon(
                      Icons.bookmark,
                      size: 64,
                      color: Colors.brown,
                    ),
                    const Text(
                      "Simple Journal",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Text("por Alura",
                        style: TextStyle(fontStyle: FontStyle.italic)),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(thickness: 2),
                    ),
                    const Text("Entre ou Registre-se"),
                    TextFormField(
                      validator: (String? value) {
                        // isValid = EmailValidator.validate(_emailController.text); OUTRA MANEIRA DE VALIDAR EMAIL
                        if (valueValidator(value)) {
                          return 'Campo email obrigatório!';
                        }
                        // else if (isValid == false) {
                        //   return 'Formato de email  inválido';
                        // }  OUTRA MANEIRA DE VALIDAR EMAIL
                        return null;
                      },
                      controller: _emailController,
                      decoration: const InputDecoration(
                        label: Text("E-mail"),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextFormField(
                      validator: (String? value) {
                        if (valueValidator(value)) {
                          return 'Campo senha obrigatório!';
                        } else if (_passwordController.text.length <= 3) {
                          return 'Senha muito curta! Preencha com no mínimo 4 caracteres.';
                        }
                        return null;
                      },
                      controller: _passwordController,
                      decoration: const InputDecoration(label: Text("Senha")),
                      keyboardType: TextInputType.visiblePassword,
                      maxLength: 16,
                      obscureText: true,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            login(context);
                          }
                        },
                        child: const Text("Continuar")),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  login(BuildContext context) {
    String email = _emailController.text;
    String password = _passwordController.text;
    service.login(email: email, password: password).then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, 'home');
      }
    }).catchError(
      (error) {
        var innerError = error as HttpException;
        showExceptionDialog(context, content: innerError.toString());
      },
      test: (error) => error is HttpException,
    ).catchError(
      (error) {
        showDialogBox(
          context,
          content: 'Usuário não cadastrado. Deseja criar uma conta?',
        ).then((value) {
          if (value != null && value) {
            service.register(email: email, password: password).then((value) {
              if (value) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                    'Cadastro realizado com sucesso!',
                  ),
                ));
                Navigator.pushReplacementNamed(context, 'home');
              }
            });
          }
        });
      },
      test: (error) => error is UserNotFoundException,
    ).catchError(
        (error) => showExceptionDialog(context,
            content: 'O servidor crashou! Tente novamente mais tarde!'),
        test: (error) => error is TimeoutException);
    // try {} on UserNotFoundException {
    //   if (!context.mounted) return;

    // } on IncorrectPasswordException {
    //   if (!context.mounted) return;

    // } OUTRA MANEIRA DE VALIDAÇÃO
  }
}
