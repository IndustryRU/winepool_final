import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_view_settings_provider.g.dart';

@riverpod
class AdminViewSettings extends _$AdminViewSettings {
  @override
  bool build() {
    return false; // по умолчанию не показываем удаленные
  }
}