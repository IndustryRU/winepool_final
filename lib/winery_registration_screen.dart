// lib/winery_registration_screen.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Глобальный клиент Supabase, инициализированный в main.dart
final supabase = Supabase.instance.client;

class WineryRegistrationSupabaseScreen extends StatefulWidget {
  const WineryRegistrationSupabaseScreen({super.key});

  @override
  _WineryRegistrationSupabaseScreenState createState() => _WineryRegistrationSupabaseScreenState();
}

class _WineryRegistrationSupabaseScreenState extends State<WineryRegistrationSupabaseScreen> {
  // ... (Остальной код, включая контроллеры, _registerWinery, и build метод) ...
  // Используйте полный код, который был предоставлен на Этапе 3: Регистрация Продавца на Supabase
  // ...

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController(); 
  final _innController = TextEditingController(); 

  bool _isLoading = false;

  Future<void> _registerWinery() async {
    setState(() => _isLoading = true);
    
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final wineryName = _nameController.text.trim();
    final inn = _innController.text.trim();

    try {
      // 1. Создание аккаунта через Supabase Auth
      final AuthResponse response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final User? user = response.user;

      if (user != null) {
        // 2. Запись данных винодельни в кастомную таблицу 'wineries'
        await supabase
            .from('wineries')
            .insert({
              'seller_id': user.id, 
              'title': wineryName,
              'inn': inn,
              'status': 'pending', 
            });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Регистрация успешно отправлена на проверку!')),
        );
        // TODO: Перенаправление
      }
    } on AuthException catch (e) {
      String message = 'Ошибка регистрации: ${e.message}';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      String message = 'Произошла неизвестная ошибка: ${e.toString()}';
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Регистрация Винодельни WinePool')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text('Станьте нашим партнером и разместите свое вино!', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Название Винодельни/Магазина')),
            TextField(controller: _innController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'ИНН (для верификации)')),
            TextField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: 'Пароль (минимум 6 символов)')),
            SizedBox(height: 30),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _registerWinery,
                    style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                    child: Text('Зарегистрировать Винодельню'),
                  ),
          ],
        ),
      ),
    );
  }
}

// Конец файла lib/winery_registration_screen.dart