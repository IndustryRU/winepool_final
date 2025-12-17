import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:winepool_final/features/wines/domain/wine.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@freezed
abstract class UserTasting with _$UserTasting {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UserTasting({
    String? id,
    String? userId,
    String? wineId,
    DateTime? tastingDate,
    double? rating,
    String? notes,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    required Wine wine,
  }) = _UserTasting;

  factory UserTasting.fromJson(Map<String, dynamic> json) =>
      _$UserTastingFromJson(json);
}

@freezed
abstract class UserStorageItem with _$UserStorageItem {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UserStorageItem({
    String? id,
    String? userId,
    String? wineId,
    int? quantity,
    double? purchasePrice,
    DateTime? purchaseDate,
    int? idealDrinkFrom, // Год
    int? idealDrinkTo,   // Год
    DateTime? createdAt,
    DateTime? updatedAt,
    required Wine wine,
  }) = _UserStorageItem;

  factory UserStorageItem.fromJson(Map<String, dynamic> json) =>
      _$UserStorageItemFromJson(json);
}