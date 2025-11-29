import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:winepool_final/core/providers.dart';
import 'package:winepool_final/features/auth/domain/profile.dart';
import 'package:winepool_final/features/offers/application/offers_controller.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  Future<Profile?> build() async {
    final client = ref.watch(supabaseClientProvider);
    final session = client.auth.currentSession;
    if (session == null) return null;

    // Загружаем профиль
    final profileData = await client.from('profiles').select().eq('id', session.user.id).single();
    return Profile.fromJson(profileData);
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(supabaseClientProvider).auth.signInWithPassword(
            email: email,
            password: password,
          );
      return null;
    });

    // Если ошибок не было, принудительно инвалидируем себя,
    // чтобы GoRouter отреагировал
    if (!state.hasError) {
      ref.invalidateSelf();
      ref.invalidate(offersControllerProvider);
    }
  }

  Future<void> signUp(String email, String password, String username) async {
    await ref.read(supabaseClientProvider).auth.signUp(
          email: email,
          password: password,
          data: {'username': username}, // Передаем username в метаданные
        );
    ref.invalidateSelf(); // Принудительно перезагружаем
  }

  Future<void> signOut() async {
    await ref.read(supabaseClientProvider).auth.signOut();
    ref.invalidateSelf(); // Принудительно перезагружаем
  }

  Future<void> forceSignOut() async {
    await ref.read(supabaseClientProvider).auth.signOut(scope: SignOutScope.global);
    ref.invalidateSelf();
  }

  Future<void> deleteAccount() async {
    final userId = state.value?.id;
    if (userId == null) return;
    await ref.read(supabaseClientProvider).functions.invoke('delete-user');
    ref.invalidateSelf();
  }
}