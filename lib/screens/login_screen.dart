// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:winepool_final/features/auth/application/auth_controller.dart';
import 'package:winepool_final/features/auth/domain/profile.dart';

// Импорт для перехода на главный экран

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final passwordVisible = useState(false);
    final authState = ref.watch(authControllerProvider);
    
    ref.listen<AsyncValue<Profile?>>(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        String errorMessage = 'Произошла неизвестная ошибка.';
        final error = next.error;
        if (error is AuthApiException) {
          if (error.message == 'Invalid login credentials') {
            errorMessage = 'Неверный Email или пароль.';
          } else if (error.message == 'missing email or phone') {
            errorMessage = 'Не заполнен Email.';
          } else {
            errorMessage = error.message; // Оставляем оригинальное сообщение для других ошибок
          }
        } else if (error.toString().contains('SocketException')) {
          errorMessage = 'Нет подключения к интернету.';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    });
    
    return Scaffold(
      appBar: AppBar(title: const Text('Вход для продавца')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      passwordVisible.value = !passwordVisible.value;
                    },
                  ),
                ),
                obscureText: !passwordVisible.value,
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                onEditingComplete: () async {
                  try {
                    await ref.read(authControllerProvider.notifier).signIn(
                          emailController.text,
                          passwordController.text,
                        );
                  } catch (e) {
                    if (!context.mounted) return;

                    String errorMessage = 'Произошла неизвестная ошибка.';
                    if (e is AuthApiException) {
                      if (e.toString().contains('missing')) {
                        errorMessage = 'Нет подключения к интернету.';
                      } else {
                        errorMessage = e.message;
                      }                
                    } else if (e.toString().contains('SocketException')) {
                      errorMessage = 'Нет подключения к интернету.';
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMessage)),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: authState.isLoading ? null : () {
                  ref.read(authControllerProvider.notifier).signIn(
                        emailController.text,
                        passwordController.text,
                      );
                },
                child: authState.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Войти'),
              ),
              const SizedBox(height: 16),
              // Ссылка на регистрацию:
              TextButton(
                onPressed: () {
                  context.go('/register');
                },
                child: const Text('Нет аккаунта? Зарегистрироваться'),
              )
            ],
          ),
        ),
      ),
    );
 }
}