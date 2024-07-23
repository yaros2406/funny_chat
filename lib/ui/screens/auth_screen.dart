import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funny_chat/ui/constants/app_numbers.dart';
import 'package:funny_chat/ui/constants/app_strings.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/auth_bloc.dart';
import '../../repositories/auth_repository.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(authRepository: RepositoryProvider.of<AuthRepository>(context)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.loginButton),
        ),
        body: AuthForm(),
      ),
    );
  }
}

class AuthForm extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AuthForm({super.key});

  @override
  Widget build(BuildContext context) {
    const margin = AppNumbers.margin;
    const padding = AppNumbers.verticalPadding;
    const symmetricMargin = AppNumbers.symmetricMargin;
    return Padding(
      padding: const EdgeInsets.all(margin),
      child: Column(
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
                labelText: AppStrings.usernameLabel,
                contentPadding: EdgeInsets.all(padding)),
          ),
          const SizedBox(height: margin),
          TextField(
            textAlignVertical: TextAlignVertical.center,
            controller: _passwordController,
            decoration: const InputDecoration(
                labelText: AppStrings.passwordLabel,
                contentPadding: EdgeInsets.all(padding)),
            obscureText: true,
          ),
          const SizedBox(height: symmetricMargin),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(
                AuthLoginRequested(_usernameController.text, _passwordController.text),
              );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppNumbers.buttonBorderRadius),
              ),
              padding: const EdgeInsets.symmetric(vertical: padding, horizontal: symmetricMargin),
            ),
            child: Text(AppStrings.loginButton, style: Theme.of(context).textTheme.bodyLarge),
          ),
          TextButton(
            onPressed: () {
              context.go(AppStrings.registerScreenPath);
            },
            child: Text(AppStrings.registrationButton, style: Theme.of(context).textTheme.bodyLarge),
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                context.go(AppStrings.chatListScreenPath, extra: state.userKey);
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: Container(),
          ),
        ],
      ),
    );
  }
}
