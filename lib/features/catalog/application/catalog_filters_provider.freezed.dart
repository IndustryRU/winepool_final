// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_filters_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CatalogFiltersState {

 List<String> get color; List<String> get type; List<String> get sugar; double? get minPrice; double? get maxPrice; List<String> get country; List<String> get region; List<String> get grape; double? get minRating; int get minYear; int? get maxYear; List<String> get volume; bool get showUnavailable; String? get sortOption;
/// Create a copy of CatalogFiltersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogFiltersStateCopyWith<CatalogFiltersState> get copyWith => _$CatalogFiltersStateCopyWithImpl<CatalogFiltersState>(this as CatalogFiltersState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogFiltersState&&const DeepCollectionEquality().equals(other.color, color)&&const DeepCollectionEquality().equals(other.type, type)&&const DeepCollectionEquality().equals(other.sugar, sugar)&&(identical(other.minPrice, minPrice) || other.minPrice == minPrice)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&const DeepCollectionEquality().equals(other.country, country)&&const DeepCollectionEquality().equals(other.region, region)&&const DeepCollectionEquality().equals(other.grape, grape)&&(identical(other.minRating, minRating) || other.minRating == minRating)&&(identical(other.minYear, minYear) || other.minYear == minYear)&&(identical(other.maxYear, maxYear) || other.maxYear == maxYear)&&const DeepCollectionEquality().equals(other.volume, volume)&&(identical(other.showUnavailable, showUnavailable) || other.showUnavailable == showUnavailable)&&(identical(other.sortOption, sortOption) || other.sortOption == sortOption));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(color),const DeepCollectionEquality().hash(type),const DeepCollectionEquality().hash(sugar),minPrice,maxPrice,const DeepCollectionEquality().hash(country),const DeepCollectionEquality().hash(region),const DeepCollectionEquality().hash(grape),minRating,minYear,maxYear,const DeepCollectionEquality().hash(volume),showUnavailable,sortOption);

@override
String toString() {
  return 'CatalogFiltersState(color: $color, type: $type, sugar: $sugar, minPrice: $minPrice, maxPrice: $maxPrice, country: $country, region: $region, grape: $grape, minRating: $minRating, minYear: $minYear, maxYear: $maxYear, volume: $volume, showUnavailable: $showUnavailable, sortOption: $sortOption)';
}


}

/// @nodoc
abstract mixin class $CatalogFiltersStateCopyWith<$Res>  {
  factory $CatalogFiltersStateCopyWith(CatalogFiltersState value, $Res Function(CatalogFiltersState) _then) = _$CatalogFiltersStateCopyWithImpl;
@useResult
$Res call({
 List<String> color, List<String> type, List<String> sugar, double? minPrice, double? maxPrice, List<String> country, List<String> region, List<String> grape, double? minRating, int minYear, int? maxYear, List<String> volume, bool showUnavailable, String? sortOption
});




}
/// @nodoc
class _$CatalogFiltersStateCopyWithImpl<$Res>
    implements $CatalogFiltersStateCopyWith<$Res> {
  _$CatalogFiltersStateCopyWithImpl(this._self, this._then);

  final CatalogFiltersState _self;
  final $Res Function(CatalogFiltersState) _then;

/// Create a copy of CatalogFiltersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? color = null,Object? type = null,Object? sugar = null,Object? minPrice = freezed,Object? maxPrice = freezed,Object? country = null,Object? region = null,Object? grape = null,Object? minRating = freezed,Object? minYear = null,Object? maxYear = freezed,Object? volume = null,Object? showUnavailable = null,Object? sortOption = freezed,}) {
  return _then(_self.copyWith(
color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as List<String>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as List<String>,sugar: null == sugar ? _self.sugar : sugar // ignore: cast_nullable_to_non_nullable
as List<String>,minPrice: freezed == minPrice ? _self.minPrice : minPrice // ignore: cast_nullable_to_non_nullable
as double?,maxPrice: freezed == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as double?,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as List<String>,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as List<String>,grape: null == grape ? _self.grape : grape // ignore: cast_nullable_to_non_nullable
as List<String>,minRating: freezed == minRating ? _self.minRating : minRating // ignore: cast_nullable_to_non_nullable
as double?,minYear: null == minYear ? _self.minYear : minYear // ignore: cast_nullable_to_non_nullable
as int,maxYear: freezed == maxYear ? _self.maxYear : maxYear // ignore: cast_nullable_to_non_nullable
as int?,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as List<String>,showUnavailable: null == showUnavailable ? _self.showUnavailable : showUnavailable // ignore: cast_nullable_to_non_nullable
as bool,sortOption: freezed == sortOption ? _self.sortOption : sortOption // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogFiltersState].
extension CatalogFiltersStatePatterns on CatalogFiltersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogFiltersState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogFiltersState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogFiltersState value)  $default,){
final _that = this;
switch (_that) {
case _CatalogFiltersState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogFiltersState value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogFiltersState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> color,  List<String> type,  List<String> sugar,  double? minPrice,  double? maxPrice,  List<String> country,  List<String> region,  List<String> grape,  double? minRating,  int minYear,  int? maxYear,  List<String> volume,  bool showUnavailable,  String? sortOption)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogFiltersState() when $default != null:
return $default(_that.color,_that.type,_that.sugar,_that.minPrice,_that.maxPrice,_that.country,_that.region,_that.grape,_that.minRating,_that.minYear,_that.maxYear,_that.volume,_that.showUnavailable,_that.sortOption);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> color,  List<String> type,  List<String> sugar,  double? minPrice,  double? maxPrice,  List<String> country,  List<String> region,  List<String> grape,  double? minRating,  int minYear,  int? maxYear,  List<String> volume,  bool showUnavailable,  String? sortOption)  $default,) {final _that = this;
switch (_that) {
case _CatalogFiltersState():
return $default(_that.color,_that.type,_that.sugar,_that.minPrice,_that.maxPrice,_that.country,_that.region,_that.grape,_that.minRating,_that.minYear,_that.maxYear,_that.volume,_that.showUnavailable,_that.sortOption);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> color,  List<String> type,  List<String> sugar,  double? minPrice,  double? maxPrice,  List<String> country,  List<String> region,  List<String> grape,  double? minRating,  int minYear,  int? maxYear,  List<String> volume,  bool showUnavailable,  String? sortOption)?  $default,) {final _that = this;
switch (_that) {
case _CatalogFiltersState() when $default != null:
return $default(_that.color,_that.type,_that.sugar,_that.minPrice,_that.maxPrice,_that.country,_that.region,_that.grape,_that.minRating,_that.minYear,_that.maxYear,_that.volume,_that.showUnavailable,_that.sortOption);case _:
  return null;

}
}

}

/// @nodoc


class _CatalogFiltersState implements CatalogFiltersState {
  const _CatalogFiltersState({final  List<String> color = const [], final  List<String> type = const [], final  List<String> sugar = const [], this.minPrice, this.maxPrice, final  List<String> country = const [], final  List<String> region = const [], final  List<String> grape = const [], this.minRating, this.minYear = 1900, this.maxYear, final  List<String> volume = const [], this.showUnavailable = false, this.sortOption}): _color = color,_type = type,_sugar = sugar,_country = country,_region = region,_grape = grape,_volume = volume;
  

 final  List<String> _color;
@override@JsonKey() List<String> get color {
  if (_color is EqualUnmodifiableListView) return _color;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_color);
}

 final  List<String> _type;
@override@JsonKey() List<String> get type {
  if (_type is EqualUnmodifiableListView) return _type;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_type);
}

 final  List<String> _sugar;
@override@JsonKey() List<String> get sugar {
  if (_sugar is EqualUnmodifiableListView) return _sugar;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sugar);
}

@override final  double? minPrice;
@override final  double? maxPrice;
 final  List<String> _country;
@override@JsonKey() List<String> get country {
  if (_country is EqualUnmodifiableListView) return _country;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_country);
}

 final  List<String> _region;
@override@JsonKey() List<String> get region {
  if (_region is EqualUnmodifiableListView) return _region;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_region);
}

 final  List<String> _grape;
@override@JsonKey() List<String> get grape {
  if (_grape is EqualUnmodifiableListView) return _grape;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_grape);
}

@override final  double? minRating;
@override@JsonKey() final  int minYear;
@override final  int? maxYear;
 final  List<String> _volume;
@override@JsonKey() List<String> get volume {
  if (_volume is EqualUnmodifiableListView) return _volume;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_volume);
}

@override@JsonKey() final  bool showUnavailable;
@override final  String? sortOption;

/// Create a copy of CatalogFiltersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogFiltersStateCopyWith<_CatalogFiltersState> get copyWith => __$CatalogFiltersStateCopyWithImpl<_CatalogFiltersState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogFiltersState&&const DeepCollectionEquality().equals(other._color, _color)&&const DeepCollectionEquality().equals(other._type, _type)&&const DeepCollectionEquality().equals(other._sugar, _sugar)&&(identical(other.minPrice, minPrice) || other.minPrice == minPrice)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&const DeepCollectionEquality().equals(other._country, _country)&&const DeepCollectionEquality().equals(other._region, _region)&&const DeepCollectionEquality().equals(other._grape, _grape)&&(identical(other.minRating, minRating) || other.minRating == minRating)&&(identical(other.minYear, minYear) || other.minYear == minYear)&&(identical(other.maxYear, maxYear) || other.maxYear == maxYear)&&const DeepCollectionEquality().equals(other._volume, _volume)&&(identical(other.showUnavailable, showUnavailable) || other.showUnavailable == showUnavailable)&&(identical(other.sortOption, sortOption) || other.sortOption == sortOption));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_color),const DeepCollectionEquality().hash(_type),const DeepCollectionEquality().hash(_sugar),minPrice,maxPrice,const DeepCollectionEquality().hash(_country),const DeepCollectionEquality().hash(_region),const DeepCollectionEquality().hash(_grape),minRating,minYear,maxYear,const DeepCollectionEquality().hash(_volume),showUnavailable,sortOption);

@override
String toString() {
  return 'CatalogFiltersState(color: $color, type: $type, sugar: $sugar, minPrice: $minPrice, maxPrice: $maxPrice, country: $country, region: $region, grape: $grape, minRating: $minRating, minYear: $minYear, maxYear: $maxYear, volume: $volume, showUnavailable: $showUnavailable, sortOption: $sortOption)';
}


}

/// @nodoc
abstract mixin class _$CatalogFiltersStateCopyWith<$Res> implements $CatalogFiltersStateCopyWith<$Res> {
  factory _$CatalogFiltersStateCopyWith(_CatalogFiltersState value, $Res Function(_CatalogFiltersState) _then) = __$CatalogFiltersStateCopyWithImpl;
@override @useResult
$Res call({
 List<String> color, List<String> type, List<String> sugar, double? minPrice, double? maxPrice, List<String> country, List<String> region, List<String> grape, double? minRating, int minYear, int? maxYear, List<String> volume, bool showUnavailable, String? sortOption
});




}
/// @nodoc
class __$CatalogFiltersStateCopyWithImpl<$Res>
    implements _$CatalogFiltersStateCopyWith<$Res> {
  __$CatalogFiltersStateCopyWithImpl(this._self, this._then);

  final _CatalogFiltersState _self;
  final $Res Function(_CatalogFiltersState) _then;

/// Create a copy of CatalogFiltersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? color = null,Object? type = null,Object? sugar = null,Object? minPrice = freezed,Object? maxPrice = freezed,Object? country = null,Object? region = null,Object? grape = null,Object? minRating = freezed,Object? minYear = null,Object? maxYear = freezed,Object? volume = null,Object? showUnavailable = null,Object? sortOption = freezed,}) {
  return _then(_CatalogFiltersState(
color: null == color ? _self._color : color // ignore: cast_nullable_to_non_nullable
as List<String>,type: null == type ? _self._type : type // ignore: cast_nullable_to_non_nullable
as List<String>,sugar: null == sugar ? _self._sugar : sugar // ignore: cast_nullable_to_non_nullable
as List<String>,minPrice: freezed == minPrice ? _self.minPrice : minPrice // ignore: cast_nullable_to_non_nullable
as double?,maxPrice: freezed == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as double?,country: null == country ? _self._country : country // ignore: cast_nullable_to_non_nullable
as List<String>,region: null == region ? _self._region : region // ignore: cast_nullable_to_non_nullable
as List<String>,grape: null == grape ? _self._grape : grape // ignore: cast_nullable_to_non_nullable
as List<String>,minRating: freezed == minRating ? _self.minRating : minRating // ignore: cast_nullable_to_non_nullable
as double?,minYear: null == minYear ? _self.minYear : minYear // ignore: cast_nullable_to_non_nullable
as int,maxYear: freezed == maxYear ? _self.maxYear : maxYear // ignore: cast_nullable_to_non_nullable
as int?,volume: null == volume ? _self._volume : volume // ignore: cast_nullable_to_non_nullable
as List<String>,showUnavailable: null == showUnavailable ? _self.showUnavailable : showUnavailable // ignore: cast_nullable_to_non_nullable
as bool,sortOption: freezed == sortOption ? _self.sortOption : sortOption // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
