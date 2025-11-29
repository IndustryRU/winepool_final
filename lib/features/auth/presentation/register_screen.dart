import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/auth/application/auth_controller.dart';
import 'package:winepool_final/features/auth/domain/profile.dart';

class RegisterScreen extends HookConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final selectedRole = useState(UserRole.buyer);
    final isLoading = ref.watch(authControllerProvider.select((value) => value.isLoading));
    final error = ref.watch(authControllerProvider.select((value) => value.error));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Пароль',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16),
            SegmentedButton<UserRole>(
              segments: const [
                ButtonSegment(
                  value: UserRole.buyer,
                  label: Text('Покупатель'),
                ),
                ButtonSegment(
                  value: UserRole.seller,
                  label: Text('Продавец'),
                ),
              ],
              selected: {selectedRole.value},
              onSelectionChanged: (Set<UserRole> newSelection) {
                selectedRole.value = newSelection.first;
              },
            ),
            const SizedBox(height: 16),
            if (error != null)
              SelectableText.rich(
                TextSpan(
                  text: 'Ошибка: ',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
                  children: [
                    TextSpan(
                      text: error.toString(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      await ref
                          .read(authControllerProvider.notifier)
                          .signUp(emailController.text, passwordController.text, selectedRole.value.value.toString());
                      
                      if (!context.mounted) return;
                      
                      // Проверяем успешность регистрации через состояние провайдера
                      final state = ref.read(authControllerProvider);
                      if (state.value != null) {
                        context.go('/dashboard');
                      }
                    },
              child: isLoading ? const CircularProgressIndicator() : const Text('Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }
}