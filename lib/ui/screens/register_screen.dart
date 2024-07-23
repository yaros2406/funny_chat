import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funny_chat/repositories/register_repository.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/register_bloc.dart';
import '../constants/app_numbers.dart';
import '../constants/app_strings.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterBloc(RegisterRepository()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.registrationButton),
        ),
        body: const RegisterForm(),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  RegisterFormState createState() => RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const double padding = AppNumbers.margin;
    const double textFieldPadding = AppNumbers.verticalPadding;
    const double buttonPadding = AppNumbers.symmetricMargin;
    const double buttonBorderRadius = AppNumbers.buttonBorderRadius;

    return Padding(
      padding: const EdgeInsets.all(padding),
      child: Column(
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: AppStrings.usernameLabel,
              contentPadding: EdgeInsets.all(textFieldPadding),
            ),
          ),
          const SizedBox(height: padding),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: AppStrings.passwordLabel,
              contentPadding: EdgeInsets.all(textFieldPadding),
            ),
            obscureText: true,
          ),
          const SizedBox(height: buttonPadding),
          BlocConsumer<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state is RegisterSuccess) {
                context.go(AppStrings.authScreenPath);
              } else if (state is RegisterFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
            builder: (context, state) {
              if (state is RegisterLoading) {
                return const CircularProgressIndicator();
              }

              return ElevatedButton(
                onPressed: () {
                  final username = _usernameController.text;
                  final password = _passwordController.text;
                  context.read<RegisterBloc>().add(
                    RegisterButtonPressed(username: username, password: password),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(buttonBorderRadius),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: buttonPadding, horizontal: padding),
                ),
                child: Text(AppStrings.registrationButton, style: Theme.of(context).textTheme.bodyLarge),
              );
            },
          ),
          TextButton(
            onPressed: () {
              context.go(AppStrings.authScreenPath);
            },
            child: Text(AppStrings.loginButton, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
