import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

String? _userNameFromJson(Map<String, dynamic>? json) => json?['full_name'] as String?;

@freezed
abstract class Review with _$Review {
  const factory Review({
    @JsonKey(includeToJson: false)
    String? id,
    @JsonKey(name: 'wine_id')
    required String wineId,
    @JsonKey(name: 'user_id')
    required String userId,
    @JsonKey(name: 'profiles', fromJson: _userNameFromJson, includeToJson: false)
    String? userName,
    required double rating,
    @JsonKey(name: 'text')
    String? text,
    @JsonKey(name: 'created_at')
    DateTime? createdAt,
  }) = _Review;
  
  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}