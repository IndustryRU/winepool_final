import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
abstract class Review with _$Review {
  const factory Review({
    @JsonKey(includeToJson: false)
    String? id,
    @JsonKey(name: 'wine_id')
    required String wineId,
    @JsonKey(name: 'user_id')
    required String userId,
    required double rating,
    @JsonKey(name: 'text')
    String? text,
    @JsonKey(name: 'created_at')
    DateTime? createdAt,
  }) = _Review;
  
  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}