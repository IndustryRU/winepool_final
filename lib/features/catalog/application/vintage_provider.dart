import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers.dart';

part 'vintage_provider.g.dart';

@riverpod
Future<List<int>> availableVintages(Ref ref) async {
  final result = await ref.watch(supabaseClientProvider).rpc('get_available_vintages');
  // Supabase возвращает List<dynamic>, нужно преобразовать в List<int>
  final vintages = (result as List).map((item) => item['vintage'] as int).toList();
  return vintages;
}