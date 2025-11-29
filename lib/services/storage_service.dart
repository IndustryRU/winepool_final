import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:winepool_final/core/providers.dart';

// Создаем провайдер вручную
final storageServiceProvider = Provider<StorageService>((ref) {
 return StorageService(ref.watch(supabaseClientProvider));
});

class StorageService {
  final SupabaseClient _client;

  StorageService(this._client);

  Future<String> uploadFile(String bucket, XFile file) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
    await _client.storage.from(bucket).upload(
          fileName,
          File(file.path),
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );
    return fileName;
  }
}