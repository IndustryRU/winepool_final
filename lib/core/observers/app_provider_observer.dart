import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class AppProviderObserver extends ProviderObserver {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  AppProviderObserver(this.scaffoldMessengerKey);

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    log('PROVIDER FAILED: ${context.provider.name ?? context.provider.runtimeType}, ERROR: $error');

    // Проверяем на наличие SocketException (ошибки сети)
    bool isNetworkError = error is SocketException;

    if (isNetworkError) {
      // Используем ключ для показа SnackBar
      scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('Ошибка сети. Проверьте подключение к интернету.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    // Логику обработки ошибок убираем, так как providerDidFail лучше подходит
  }
}