import 'package:chat/src/app/core/constants/chat_constants.dart';
import 'package:chat/src/app/core/message/chat_message.dart';
import 'package:chat/src/app/core/provider/service_locator.dart';
import 'package:chat/src/app/core/ui/widgets/chat_loader.dart';
import 'package:chat/src/app/presentation/features/auth/bloc/auth_cubit.dart';
import 'package:chat/src/app/presentation/features/auth/bloc/auth_state.dart';
import 'package:chat/src/app/presentation/features/auth/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = getIt.get<AuthCubit>();
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 15,
                children: [
                  Image.asset(ChatConstants.LOGO_APP,scale: 5,),
                  ChatTextField(
                    keyboardType: TextInputType.emailAddress,
                    validator: Validatorless.multiple([
                      Validatorless.email('E-mail inválido '),
                      Validatorless.required('Email Requerido'),
                    ]),
                    controller: _emailController,
                    icon: Icons.email,
                    label: 'Email',
                  ),
                  ChatTextField(
                    obscureText: true,
                    validator: Validatorless.multiple([
                      Validatorless.min(
                        5,
                        'Password precisa ter no minimo 5 caracters',
                      ),
                      Validatorless.required('Password Requerido'),
                    ]),
                    controller: _passwordController,
                    icon: Icons.key,
                    label: 'Password',
                  ),
          
                  BlocConsumer<AuthCubit, AuthState>(
                    bloc: bloc,
                    listener: (context, state) {
                      if (state.status == AuthStatus.error) {
                        ChatMessage.showError(
                          state.message ?? 'erro ao criar usuário',
                          context,
                        );
                      }
                      if (state.status == AuthStatus.success) {
                        ChatMessage.showSuccess(
                          state.message ?? 'Login realizado com sucesso',
                          context,
                        );
                        Navigator.of(context).pushNamedAndRemoveUntil('/mainvaigation',(route) => false,);
                      }
                    },
                    builder: (context, state) {
                      return switch (state.status) {
                        AuthStatus.loading => ChatLoader(),
                        _ => Column(
                          spacing: 15,
                          children: [
                            FractionallySizedBox(
                              widthFactor: 1,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(),
                                onPressed: () {
                                  switch (_formkey.currentState?.validate()) {
                                    case false || null:
                                      {}
                                    case true:
                                      {
                                        final email = _emailController.text;
                                        final password = _passwordController.text;
                                        bloc.login(email, password);
                                      }
                                  }
                                },
                                child: Text('Login'),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed('/register');
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: 'Esqueceu a senha ?',
                                  children: [
                                    TextSpan(
                                      text: ' Recuperar senha',
                                      style: TextStyle(color:Colors.deepOrange),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed('/register');
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: 'Não tem conta ?',
                                  children: [
                                    TextSpan(
                                      text: ' Cadastre-se',
                                      style: TextStyle(color: Colors.amber),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      };
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
