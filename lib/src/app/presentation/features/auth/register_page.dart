import 'package:chat/src/app/core/extension/focus_extension.dart';
import 'package:chat/src/app/core/message/chat_message.dart';
import 'package:chat/src/app/core/provider/service_locator.dart';
import 'package:chat/src/app/core/ui/widgets/chat_loader.dart';
import 'package:chat/src/app/presentation/features/auth/bloc/auth_cubit.dart';
import 'package:chat/src/app/presentation/features/auth/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _urlController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _urlController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = getIt.get<AuthCubit>();
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Register')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
                children: [
                  ChatTextField(
                    validator: Validatorless.multiple([
                      Validatorless.min(6, 'Nome precisa ter no minimo 6 caracters'),
                      Validatorless.required('Nome Requerido'),
                    ]), 
                    controller: _nameController,
                    icon: Icons.person,
                    label: 'Name',
                  ),
                  ChatTextField(
                    validator: Validatorless.multiple([
                      Validatorless.required('Url  Requerido'),
                    ]), 
                    controller: _urlController,
                    icon: Icons.camera,
                    label: 'Url Perfil',
                  ),
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
                      Validatorless.min(5, 'Password precisa ter no minimo 5 caracters'),
                      Validatorless.required('Password Requerido'),
                    ]), 
                    controller: _passwordController,
                    icon: Icons.key,
                    label: 'Pessword',
                  ),
                  ChatTextField(
                    obscureText: true,
                    validator: Validatorless.multiple([
                      Validatorless.min(5, 'Password precisa ter no minimo 5 caracters'),
                      Validatorless.required('Password Requerido'),
                      Validatorless.compare(_passwordController, 'Confimaão de password inválido')
                    ]), 
                    controller: _confirmPasswordController,
                    icon: Icons.key,
                    label: 'Confirm Password',
                  ),
                   
                   
                  BlocConsumer<AuthCubit, AuthState>(
                    bloc: bloc,
                    listener: (context, state) {
                       if (state.status == AuthStatus.error) {
                           ChatMessage.showError(state.message ?? 'erro ao criar usuário', context); 
                       }
                       if (state.status == AuthStatus.success) {
                           ChatMessage.showSuccess(state.message ?? 'Usuário cadastrado ', context);
                           Navigator.of(context).pop(); 
                       }
                    },
                    builder: (context, state) {
                      return switch (state.status) {
                        AuthStatus.loading => ChatLoader() ,
                        _=> FractionallySizedBox(
                        widthFactor: 0.9,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(),
                          onPressed: () {
                            switch (_formkey.currentState?.validate()) {
                              case false || null:
                                {}
                              case true: {
                               final  email = _emailController.text;
                               final password = _passwordController.text;
                               final name = _nameController.text;
                               final confirmPassword = _confirmPasswordController.text;
                               final urlPerfil  = _urlController.text;
                                bloc.register(email, password, name, confirmPassword,urlPerfil);
                              }
                            }
                          },
                          child: Text('Register'),
                        ),
                      )
                      };
                    },
                  ),
          
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Já tem conta ?',
                        children: [
                          TextSpan(
                            text: ' Fazer login',
                            style: TextStyle(color: Colors.amber),
                          ),
                        ],
                      ),
                    ),
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

class ChatTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  const ChatTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller, 
    this.validator, 
    this.keyboardType = TextInputType.text, 
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText ,
      onTapOutside: (_) => context.unFocos(),
      keyboardType:keyboardType ,
      controller: controller,
      validator:validator,
      decoration: InputDecoration(
        
        prefixIcon: Icon(icon),
        label: Text(label),
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
      ),
    );
  }
}
