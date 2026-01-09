// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wine.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Wine {

@JsonKey(includeIfNull: false) String? get id;@JsonKey(name: 'winery_id', includeIfNull: false) String? get wineryId;@JsonKey(name: 'wineries', includeToJson: false, fromJson: _wineryFromJson) Winery? get winery; String? get name;// Изменено на nullable
 String? get description;// Удалено поле grapeVariety
@JsonKey(name: 'grape_variety_ids') List<String>? get grapeVarietyIds;@JsonKey(name: 'image_url') String? get imageUrl;@JsonKey(unknownEnumValue: WineColor.unknown, fromJson: _stringToWineColor, toJson: _wineColorToString) WineColor? get color;@JsonKey(unknownEnumValue: WineType.unknown, fromJson: _stringToWineType, toJson: _wineTypeToString) WineType? get type;@JsonKey(unknownEnumValue: WineSugar.unknown, fromJson: _stringToWineSugar, toJson: _wineSugarToString) WineSugar? get sugar;@JsonKey(name: 'alcohol_level') double? get alcoholLevel;// Удалено поле rating
@JsonKey(name: 'average_rating') double? get averageRating;@JsonKey(name: 'reviews_count') int? get reviewsCount;@JsonKey(name: 'serving_temperature') String? get servingTemperature;@JsonKey(name: 'sweetness') int? get sweetness;@JsonKey(name: 'acidity') int? get acidity;@JsonKey(name: 'tannins') int? get tannins;@JsonKey(name: 'saturation') int? get saturation;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;@JsonKey(name: 'is_deleted') bool get isDeleted;@JsonKey(name: 'barcode') String? get barcode;@JsonKey(name: 'awards') List<String>? get awards;@JsonKey(name: 'offers', includeToJson: false, fromJson: _offersFromJson) List<Offer>? get offers;@JsonKey(name: 'grape_varieties', includeToJson: false, fromJson: _grapeVarietiesFromJson) List<GrapeVariety>? get grapeVarieties;
/// Create a copy of Wine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WineCopyWith<Wine> get copyWith => _$WineCopyWithImpl<Wine>(this as Wine, _$identity);

  /// Serializes this Wine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Wine&&(identical(other.id, id) || other.id == id)&&(identical(other.wineryId, wineryId) || other.wineryId == wineryId)&&(identical(other.winery, winery) || other.winery == winery)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.grapeVarietyIds, grapeVarietyIds)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.color, color) || other.color == color)&&(identical(other.type, type) || other.type == type)&&(identical(other.sugar, sugar) || other.sugar == sugar)&&(identical(other.alcoholLevel, alcoholLevel) || other.alcoholLevel == alcoholLevel)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.reviewsCount, reviewsCount) || other.reviewsCount == reviewsCount)&&(identical(other.servingTemperature, servingTemperature) || other.servingTemperature == servingTemperature)&&(identical(other.sweetness, sweetness) || other.sweetness == sweetness)&&(identical(other.acidity, acidity) || other.acidity == acidity)&&(identical(other.tannins, tannins) || other.tannins == tannins)&&(identical(other.saturation, saturation) || other.saturation == saturation)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&const DeepCollectionEquality().equals(other.awards, awards)&&const DeepCollectionEquality().equals(other.offers, offers)&&const DeepCollectionEquality().equals(other.grapeVarieties, grapeVarieties));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,wineryId,winery,name,description,const DeepCollectionEquality().hash(grapeVarietyIds),imageUrl,color,type,sugar,alcoholLevel,averageRating,reviewsCount,servingTemperature,sweetness,acidity,tannins,saturation,createdAt,updatedAt,isDeleted,barcode,const DeepCollectionEquality().hash(awards),const DeepCollectionEquality().hash(offers),const DeepCollectionEquality().hash(grapeVarieties)]);

@override
String toString() {
  return 'Wine(id: $id, wineryId: $wineryId, winery: $winery, name: $name, description: $description, grapeVarietyIds: $grapeVarietyIds, imageUrl: $imageUrl, color: $color, type: $type, sugar: $sugar, alcoholLevel: $alcoholLevel, averageRating: $averageRating, reviewsCount: $reviewsCount, servingTemperature: $servingTemperature, sweetness: $sweetness, acidity: $acidity, tannins: $tannins, saturation: $saturation, createdAt: $createdAt, updatedAt: $updatedAt, isDeleted: $isDeleted, barcode: $barcode, awards: $awards, offers: $offers, grapeVarieties: $grapeVarieties)';
}


}

/// @nodoc
abstract mixin class $WineCopyWith<$Res>  {
  factory $WineCopyWith(Wine value, $Res Function(Wine) _then) = _$WineCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeIfNull: false) String? id,@JsonKey(name: 'winery_id', includeIfNull: false) String? wineryId,@JsonKey(name: 'wineries', includeToJson: false, fromJson: _wineryFromJson) Winery? winery, String? name, String? description,@JsonKey(name: 'grape_variety_ids') List<String>? grapeVarietyIds,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(unknownEnumValue: WineColor.unknown, fromJson: _stringToWineColor, toJson: _wineColorToString) WineColor? color,@JsonKey(unknownEnumValue: WineType.unknown, fromJson: _stringToWineType, toJson: _wineTypeToString) WineType? type,@JsonKey(unknownEnumValue: WineSugar.unknown, fromJson: _stringToWineSugar, toJson: _wineSugarToString) WineSugar? sugar,@JsonKey(name: 'alcohol_level') double? alcoholLevel,@JsonKey(name: 'average_rating') double? averageRating,@JsonKey(name: 'reviews_count') int? reviewsCount,@JsonKey(name: 'serving_temperature') String? servingTemperature,@JsonKey(name: 'sweetness') int? sweetness,@JsonKey(name: 'acidity') int? acidity,@JsonKey(name: 'tannins') int? tannins,@JsonKey(name: 'saturation') int? saturation,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'is_deleted') bool isDeleted,@JsonKey(name: 'barcode') String? barcode,@JsonKey(name: 'awards') List<String>? awards,@JsonKey(name: 'offers', includeToJson: false, fromJson: _offersFromJson) List<Offer>? offers,@JsonKey(name: 'grape_varieties', includeToJson: false, fromJson: _grapeVarietiesFromJson) List<GrapeVariety>? grapeVarieties
});


$WineryCopyWith<$Res>? get winery;

}
/// @nodoc
class _$WineCopyWithImpl<$Res>
    implements $WineCopyWith<$Res> {
  _$WineCopyWithImpl(this._self, this._then);

  final Wine _self;
  final $Res Function(Wine) _then;

/// Create a copy of Wine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? wineryId = freezed,Object? winery = freezed,Object? name = freezed,Object? description = freezed,Object? grapeVarietyIds = freezed,Object? imageUrl = freezed,Object? color = freezed,Object? type = freezed,Object? sugar = freezed,Object? alcoholLevel = freezed,Object? averageRating = freezed,Object? reviewsCount = freezed,Object? servingTemperature = freezed,Object? sweetness = freezed,Object? acidity = freezed,Object? tannins = freezed,Object? saturation = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? isDeleted = null,Object? barcode = freezed,Object? awards = freezed,Object? offers = freezed,Object? grapeVarieties = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,wineryId: freezed == wineryId ? _self.wineryId : wineryId // ignore: cast_nullable_to_non_nullable
as String?,winery: freezed == winery ? _self.winery : winery // ignore: cast_nullable_to_non_nullable
as Winery?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,grapeVarietyIds: freezed == grapeVarietyIds ? _self.grapeVarietyIds : grapeVarietyIds // ignore: cast_nullable_to_non_nullable
as List<String>?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as WineColor?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WineType?,sugar: freezed == sugar ? _self.sugar : sugar // ignore: cast_nullable_to_non_nullable
as WineSugar?,alcoholLevel: freezed == alcoholLevel ? _self.alcoholLevel : alcoholLevel // ignore: cast_nullable_to_non_nullable
as double?,averageRating: freezed == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double?,reviewsCount: freezed == reviewsCount ? _self.reviewsCount : reviewsCount // ignore: cast_nullable_to_non_nullable
as int?,servingTemperature: freezed == servingTemperature ? _self.servingTemperature : servingTemperature // ignore: cast_nullable_to_non_nullable
as String?,sweetness: freezed == sweetness ? _self.sweetness : sweetness // ignore: cast_nullable_to_non_nullable
as int?,acidity: freezed == acidity ? _self.acidity : acidity // ignore: cast_nullable_to_non_nullable
as int?,tannins: freezed == tannins ? _self.tannins : tannins // ignore: cast_nullable_to_non_nullable
as int?,saturation: freezed == saturation ? _self.saturation : saturation // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,awards: freezed == awards ? _self.awards : awards // ignore: cast_nullable_to_non_nullable
as List<String>?,offers: freezed == offers ? _self.offers : offers // ignore: cast_nullable_to_non_nullable
as List<Offer>?,grapeVarieties: freezed == grapeVarieties ? _self.grapeVarieties : grapeVarieties // ignore: cast_nullable_to_non_nullable
as List<GrapeVariety>?,
  ));
}
/// Create a copy of Wine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WineryCopyWith<$Res>? get winery {
    if (_self.winery == null) {
    return null;
  }

  return $WineryCopyWith<$Res>(_self.winery!, (value) {
    return _then(_self.copyWith(winery: value));
  });
}
}


/// Adds pattern-matching-related methods to [Wine].
extension WinePatterns on Wine {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Wine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Wine() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Wine value)  $default,){
final _that = this;
switch (_that) {
case _Wine():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Wine value)?  $default,){
final _that = this;
switch (_that) {
case _Wine() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? id, @JsonKey(name: 'winery_id', includeIfNull: false)  String? wineryId, @JsonKey(name: 'wineries', includeToJson: false, fromJson: _wineryFromJson)  Winery? winery,  String? name,  String? description, @JsonKey(name: 'grape_variety_ids')  List<String>? grapeVarietyIds, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(unknownEnumValue: WineColor.unknown, fromJson: _stringToWineColor, toJson: _wineColorToString)  WineColor? color, @JsonKey(unknownEnumValue: WineType.unknown, fromJson: _stringToWineType, toJson: _wineTypeToString)  WineType? type, @JsonKey(unknownEnumValue: WineSugar.unknown, fromJson: _stringToWineSugar, toJson: _wineSugarToString)  WineSugar? sugar, @JsonKey(name: 'alcohol_level')  double? alcoholLevel, @JsonKey(name: 'average_rating')  double? averageRating, @JsonKey(name: 'reviews_count')  int? reviewsCount, @JsonKey(name: 'serving_temperature')  String? servingTemperature, @JsonKey(name: 'sweetness')  int? sweetness, @JsonKey(name: 'acidity')  int? acidity, @JsonKey(name: 'tannins')  int? tannins, @JsonKey(name: 'saturation')  int? saturation, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'is_deleted')  bool isDeleted, @JsonKey(name: 'barcode')  String? barcode, @JsonKey(name: 'awards')  List<String>? awards, @JsonKey(name: 'offers', includeToJson: false, fromJson: _offersFromJson)  List<Offer>? offers, @JsonKey(name: 'grape_varieties', includeToJson: false, fromJson: _grapeVarietiesFromJson)  List<GrapeVariety>? grapeVarieties)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Wine() when $default != null:
return $default(_that.id,_that.wineryId,_that.winery,_that.name,_that.description,_that.grapeVarietyIds,_that.imageUrl,_that.color,_that.type,_that.sugar,_that.alcoholLevel,_that.averageRating,_that.reviewsCount,_that.servingTemperature,_that.sweetness,_that.acidity,_that.tannins,_that.saturation,_that.createdAt,_that.updatedAt,_that.isDeleted,_that.barcode,_that.awards,_that.offers,_that.grapeVarieties);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? id, @JsonKey(name: 'winery_id', includeIfNull: false)  String? wineryId, @JsonKey(name: 'wineries', includeToJson: false, fromJson: _wineryFromJson)  Winery? winery,  String? name,  String? description, @JsonKey(name: 'grape_variety_ids')  List<String>? grapeVarietyIds, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(unknownEnumValue: WineColor.unknown, fromJson: _stringToWineColor, toJson: _wineColorToString)  WineColor? color, @JsonKey(unknownEnumValue: WineType.unknown, fromJson: _stringToWineType, toJson: _wineTypeToString)  WineType? type, @JsonKey(unknownEnumValue: WineSugar.unknown, fromJson: _stringToWineSugar, toJson: _wineSugarToString)  WineSugar? sugar, @JsonKey(name: 'alcohol_level')  double? alcoholLevel, @JsonKey(name: 'average_rating')  double? averageRating, @JsonKey(name: 'reviews_count')  int? reviewsCount, @JsonKey(name: 'serving_temperature')  String? servingTemperature, @JsonKey(name: 'sweetness')  int? sweetness, @JsonKey(name: 'acidity')  int? acidity, @JsonKey(name: 'tannins')  int? tannins, @JsonKey(name: 'saturation')  int? saturation, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'is_deleted')  bool isDeleted, @JsonKey(name: 'barcode')  String? barcode, @JsonKey(name: 'awards')  List<String>? awards, @JsonKey(name: 'offers', includeToJson: false, fromJson: _offersFromJson)  List<Offer>? offers, @JsonKey(name: 'grape_varieties', includeToJson: false, fromJson: _grapeVarietiesFromJson)  List<GrapeVariety>? grapeVarieties)  $default,) {final _that = this;
switch (_that) {
case _Wine():
return $default(_that.id,_that.wineryId,_that.winery,_that.name,_that.description,_that.grapeVarietyIds,_that.imageUrl,_that.color,_that.type,_that.sugar,_that.alcoholLevel,_that.averageRating,_that.reviewsCount,_that.servingTemperature,_that.sweetness,_that.acidity,_that.tannins,_that.saturation,_that.createdAt,_that.updatedAt,_that.isDeleted,_that.barcode,_that.awards,_that.offers,_that.grapeVarieties);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeIfNull: false)  String? id, @JsonKey(name: 'winery_id', includeIfNull: false)  String? wineryId, @JsonKey(name: 'wineries', includeToJson: false, fromJson: _wineryFromJson)  Winery? winery,  String? name,  String? description, @JsonKey(name: 'grape_variety_ids')  List<String>? grapeVarietyIds, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(unknownEnumValue: WineColor.unknown, fromJson: _stringToWineColor, toJson: _wineColorToString)  WineColor? color, @JsonKey(unknownEnumValue: WineType.unknown, fromJson: _stringToWineType, toJson: _wineTypeToString)  WineType? type, @JsonKey(unknownEnumValue: WineSugar.unknown, fromJson: _stringToWineSugar, toJson: _wineSugarToString)  WineSugar? sugar, @JsonKey(name: 'alcohol_level')  double? alcoholLevel, @JsonKey(name: 'average_rating')  double? averageRating, @JsonKey(name: 'reviews_count')  int? reviewsCount, @JsonKey(name: 'serving_temperature')  String? servingTemperature, @JsonKey(name: 'sweetness')  int? sweetness, @JsonKey(name: 'acidity')  int? acidity, @JsonKey(name: 'tannins')  int? tannins, @JsonKey(name: 'saturation')  int? saturation, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'is_deleted')  bool isDeleted, @JsonKey(name: 'barcode')  String? barcode, @JsonKey(name: 'awards')  List<String>? awards, @JsonKey(name: 'offers', includeToJson: false, fromJson: _offersFromJson)  List<Offer>? offers, @JsonKey(name: 'grape_varieties', includeToJson: false, fromJson: _grapeVarietiesFromJson)  List<GrapeVariety>? grapeVarieties)?  $default,) {final _that = this;
switch (_that) {
case _Wine() when $default != null:
return $default(_that.id,_that.wineryId,_that.winery,_that.name,_that.description,_that.grapeVarietyIds,_that.imageUrl,_that.color,_that.type,_that.sugar,_that.alcoholLevel,_that.averageRating,_that.reviewsCount,_that.servingTemperature,_that.sweetness,_that.acidity,_that.tannins,_that.saturation,_that.createdAt,_that.updatedAt,_that.isDeleted,_that.barcode,_that.awards,_that.offers,_that.grapeVarieties);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Wine implements Wine {
  const _Wine({@JsonKey(includeIfNull: false) this.id, @JsonKey(name: 'winery_id', includeIfNull: false) this.wineryId, @JsonKey(name: 'wineries', includeToJson: false, fromJson: _wineryFromJson) this.winery, this.name, this.description, @JsonKey(name: 'grape_variety_ids') final  List<String>? grapeVarietyIds, @JsonKey(name: 'image_url') this.imageUrl, @JsonKey(unknownEnumValue: WineColor.unknown, fromJson: _stringToWineColor, toJson: _wineColorToString) this.color, @JsonKey(unknownEnumValue: WineType.unknown, fromJson: _stringToWineType, toJson: _wineTypeToString) this.type, @JsonKey(unknownEnumValue: WineSugar.unknown, fromJson: _stringToWineSugar, toJson: _wineSugarToString) this.sugar, @JsonKey(name: 'alcohol_level') this.alcoholLevel, @JsonKey(name: 'average_rating') this.averageRating, @JsonKey(name: 'reviews_count') this.reviewsCount, @JsonKey(name: 'serving_temperature') this.servingTemperature, @JsonKey(name: 'sweetness') this.sweetness, @JsonKey(name: 'acidity') this.acidity, @JsonKey(name: 'tannins') this.tannins, @JsonKey(name: 'saturation') this.saturation, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, @JsonKey(name: 'is_deleted') this.isDeleted = false, @JsonKey(name: 'barcode') this.barcode, @JsonKey(name: 'awards') final  List<String>? awards, @JsonKey(name: 'offers', includeToJson: false, fromJson: _offersFromJson) final  List<Offer>? offers, @JsonKey(name: 'grape_varieties', includeToJson: false, fromJson: _grapeVarietiesFromJson) final  List<GrapeVariety>? grapeVarieties}): _grapeVarietyIds = grapeVarietyIds,_awards = awards,_offers = offers,_grapeVarieties = grapeVarieties;
  factory _Wine.fromJson(Map<String, dynamic> json) => _$WineFromJson(json);

@override@JsonKey(includeIfNull: false) final  String? id;
@override@JsonKey(name: 'winery_id', includeIfNull: false) final  String? wineryId;
@override@JsonKey(name: 'wineries', includeToJson: false, fromJson: _wineryFromJson) final  Winery? winery;
@override final  String? name;
// Изменено на nullable
@override final  String? description;
// Удалено поле grapeVariety
 final  List<String>? _grapeVarietyIds;
// Удалено поле grapeVariety
@override@JsonKey(name: 'grape_variety_ids') List<String>? get grapeVarietyIds {
  final value = _grapeVarietyIds;
  if (value == null) return null;
  if (_grapeVarietyIds is EqualUnmodifiableListView) return _grapeVarietyIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'image_url') final  String? imageUrl;
@override@JsonKey(unknownEnumValue: WineColor.unknown, fromJson: _stringToWineColor, toJson: _wineColorToString) final  WineColor? color;
@override@JsonKey(unknownEnumValue: WineType.unknown, fromJson: _stringToWineType, toJson: _wineTypeToString) final  WineType? type;
@override@JsonKey(unknownEnumValue: WineSugar.unknown, fromJson: _stringToWineSugar, toJson: _wineSugarToString) final  WineSugar? sugar;
@override@JsonKey(name: 'alcohol_level') final  double? alcoholLevel;
// Удалено поле rating
@override@JsonKey(name: 'average_rating') final  double? averageRating;
@override@JsonKey(name: 'reviews_count') final  int? reviewsCount;
@override@JsonKey(name: 'serving_temperature') final  String? servingTemperature;
@override@JsonKey(name: 'sweetness') final  int? sweetness;
@override@JsonKey(name: 'acidity') final  int? acidity;
@override@JsonKey(name: 'tannins') final  int? tannins;
@override@JsonKey(name: 'saturation') final  int? saturation;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;
@override@JsonKey(name: 'is_deleted') final  bool isDeleted;
@override@JsonKey(name: 'barcode') final  String? barcode;
 final  List<String>? _awards;
@override@JsonKey(name: 'awards') List<String>? get awards {
  final value = _awards;
  if (value == null) return null;
  if (_awards is EqualUnmodifiableListView) return _awards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Offer>? _offers;
@override@JsonKey(name: 'offers', includeToJson: false, fromJson: _offersFromJson) List<Offer>? get offers {
  final value = _offers;
  if (value == null) return null;
  if (_offers is EqualUnmodifiableListView) return _offers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<GrapeVariety>? _grapeVarieties;
@override@JsonKey(name: 'grape_varieties', includeToJson: false, fromJson: _grapeVarietiesFromJson) List<GrapeVariety>? get grapeVarieties {
  final value = _grapeVarieties;
  if (value == null) return null;
  if (_grapeVarieties is EqualUnmodifiableListView) return _grapeVarieties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Wine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WineCopyWith<_Wine> get copyWith => __$WineCopyWithImpl<_Wine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Wine&&(identical(other.id, id) || other.id == id)&&(identical(other.wineryId, wineryId) || other.wineryId == wineryId)&&(identical(other.winery, winery) || other.winery == winery)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._grapeVarietyIds, _grapeVarietyIds)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.color, color) || other.color == color)&&(identical(other.type, type) || other.type == type)&&(identical(other.sugar, sugar) || other.sugar == sugar)&&(identical(other.alcoholLevel, alcoholLevel) || other.alcoholLevel == alcoholLevel)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.reviewsCount, reviewsCount) || other.reviewsCount == reviewsCount)&&(identical(other.servingTemperature, servingTemperature) || other.servingTemperature == servingTemperature)&&(identical(other.sweetness, sweetness) || other.sweetness == sweetness)&&(identical(other.acidity, acidity) || other.acidity == acidity)&&(identical(other.tannins, tannins) || other.tannins == tannins)&&(identical(other.saturation, saturation) || other.saturation == saturation)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&const DeepCollectionEquality().equals(other._awards, _awards)&&const DeepCollectionEquality().equals(other._offers, _offers)&&const DeepCollectionEquality().equals(other._grapeVarieties, _grapeVarieties));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,wineryId,winery,name,description,const DeepCollectionEquality().hash(_grapeVarietyIds),imageUrl,color,type,sugar,alcoholLevel,averageRating,reviewsCount,servingTemperature,sweetness,acidity,tannins,saturation,createdAt,updatedAt,isDeleted,barcode,const DeepCollectionEquality().hash(_awards),const DeepCollectionEquality().hash(_offers),const DeepCollectionEquality().hash(_grapeVarieties)]);

@override
String toString() {
  return 'Wine(id: $id, wineryId: $wineryId, winery: $winery, name: $name, description: $description, grapeVarietyIds: $grapeVarietyIds, imageUrl: $imageUrl, color: $color, type: $type, sugar: $sugar, alcoholLevel: $alcoholLevel, averageRating: $averageRating, reviewsCount: $reviewsCount, servingTemperature: $servingTemperature, sweetness: $sweetness, acidity: $acidity, tannins: $tannins, saturation: $saturation, createdAt: $createdAt, updatedAt: $updatedAt, isDeleted: $isDeleted, barcode: $barcode, awards: $awards, offers: $offers, grapeVarieties: $grapeVarieties)';
}


}

/// @nodoc
abstract mixin class _$WineCopyWith<$Res> implements $WineCopyWith<$Res> {
  factory _$WineCopyWith(_Wine value, $Res Function(_Wine) _then) = __$WineCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeIfNull: false) String? id,@JsonKey(name: 'winery_id', includeIfNull: false) String? wineryId,@JsonKey(name: 'wineries', includeToJson: false, fromJson: _wineryFromJson) Winery? winery, String? name, String? description,@JsonKey(name: 'grape_variety_ids') List<String>? grapeVarietyIds,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(unknownEnumValue: WineColor.unknown, fromJson: _stringToWineColor, toJson: _wineColorToString) WineColor? color,@JsonKey(unknownEnumValue: WineType.unknown, fromJson: _stringToWineType, toJson: _wineTypeToString) WineType? type,@JsonKey(unknownEnumValue: WineSugar.unknown, fromJson: _stringToWineSugar, toJson: _wineSugarToString) WineSugar? sugar,@JsonKey(name: 'alcohol_level') double? alcoholLevel,@JsonKey(name: 'average_rating') double? averageRating,@JsonKey(name: 'reviews_count') int? reviewsCount,@JsonKey(name: 'serving_temperature') String? servingTemperature,@JsonKey(name: 'sweetness') int? sweetness,@JsonKey(name: 'acidity') int? acidity,@JsonKey(name: 'tannins') int? tannins,@JsonKey(name: 'saturation') int? saturation,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'is_deleted') bool isDeleted,@JsonKey(name: 'barcode') String? barcode,@JsonKey(name: 'awards') List<String>? awards,@JsonKey(name: 'offers', includeToJson: false, fromJson: _offersFromJson) List<Offer>? offers,@JsonKey(name: 'grape_varieties', includeToJson: false, fromJson: _grapeVarietiesFromJson) List<GrapeVariety>? grapeVarieties
});


@override $WineryCopyWith<$Res>? get winery;

}
/// @nodoc
class __$WineCopyWithImpl<$Res>
    implements _$WineCopyWith<$Res> {
  __$WineCopyWithImpl(this._self, this._then);

  final _Wine _self;
  final $Res Function(_Wine) _then;

/// Create a copy of Wine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? wineryId = freezed,Object? winery = freezed,Object? name = freezed,Object? description = freezed,Object? grapeVarietyIds = freezed,Object? imageUrl = freezed,Object? color = freezed,Object? type = freezed,Object? sugar = freezed,Object? alcoholLevel = freezed,Object? averageRating = freezed,Object? reviewsCount = freezed,Object? servingTemperature = freezed,Object? sweetness = freezed,Object? acidity = freezed,Object? tannins = freezed,Object? saturation = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? isDeleted = null,Object? barcode = freezed,Object? awards = freezed,Object? offers = freezed,Object? grapeVarieties = freezed,}) {
  return _then(_Wine(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,wineryId: freezed == wineryId ? _self.wineryId : wineryId // ignore: cast_nullable_to_non_nullable
as String?,winery: freezed == winery ? _self.winery : winery // ignore: cast_nullable_to_non_nullable
as Winery?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,grapeVarietyIds: freezed == grapeVarietyIds ? _self._grapeVarietyIds : grapeVarietyIds // ignore: cast_nullable_to_non_nullable
as List<String>?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as WineColor?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WineType?,sugar: freezed == sugar ? _self.sugar : sugar // ignore: cast_nullable_to_non_nullable
as WineSugar?,alcoholLevel: freezed == alcoholLevel ? _self.alcoholLevel : alcoholLevel // ignore: cast_nullable_to_non_nullable
as double?,averageRating: freezed == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double?,reviewsCount: freezed == reviewsCount ? _self.reviewsCount : reviewsCount // ignore: cast_nullable_to_non_nullable
as int?,servingTemperature: freezed == servingTemperature ? _self.servingTemperature : servingTemperature // ignore: cast_nullable_to_non_nullable
as String?,sweetness: freezed == sweetness ? _self.sweetness : sweetness // ignore: cast_nullable_to_non_nullable
as int?,acidity: freezed == acidity ? _self.acidity : acidity // ignore: cast_nullable_to_non_nullable
as int?,tannins: freezed == tannins ? _self.tannins : tannins // ignore: cast_nullable_to_non_nullable
as int?,saturation: freezed == saturation ? _self.saturation : saturation // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,awards: freezed == awards ? _self._awards : awards // ignore: cast_nullable_to_non_nullable
as List<String>?,offers: freezed == offers ? _self._offers : offers // ignore: cast_nullable_to_non_nullable
as List<Offer>?,grapeVarieties: freezed == grapeVarieties ? _self._grapeVarieties : grapeVarieties // ignore: cast_nullable_to_non_nullable
as List<GrapeVariety>?,
  ));
}

/// Create a copy of Wine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WineryCopyWith<$Res>? get winery {
    if (_self.winery == null) {
    return null;
  }

  return $WineryCopyWith<$Res>(_self.winery!, (value) {
    return _then(_self.copyWith(winery: value));
  });
}
}

// dart format on
