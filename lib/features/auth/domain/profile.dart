import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

enum UserRole {
  admin('admin'),
  buyer('buyer'),
  seller('seller');

  const UserRole(this.value);
  final String value;
}

@freezed
abstract class Profile with _$Profile {
  @JsonSerializable()
  const factory Profile({
    required String id,
    String? role,
    
    @JsonKey(name: 'full_name')
    String? fullName,
    
    String? username,
    
    @JsonKey(name: 'shop_name')
    String? shopName,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}
