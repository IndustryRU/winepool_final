// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'region.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Region {

 String? get id; String? get name; String? get countryCode; bool get isPopular;@JsonKey(name: 'countries') Country? get country;
/// Create a copy of Region
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegionCopyWith<Region> get copyWith => _$RegionCopyWithImpl<Region>(this as Region, _$identity);

  /// Serializes this Region to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Region&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.isPopular, isPopular) || other.isPopular == isPopular)&&(identical(other.country, country) || other.country == country));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,countryCode,isPopular,country);

@override
String toString() {
  return 'Region(id: $id, name: $name, countryCode: $countryCode, isPopular: $isPopular, country: $country)';
}


}

/// @nodoc
abstract mixin class $RegionCopyWith<$Res>  {
  factory $RegionCopyWith(Region value, $Res Function(Region) _then) = _$RegionCopyWithImpl;
@useResult
$Res call({
 String? id, String? name, String? countryCode, bool isPopular,@JsonKey(name: 'countries') Country? country
});


$CountryCopyWith<$Res>? get country;

}
/// @nodoc
class _$RegionCopyWithImpl<$Res>
    implements $RegionCopyWith<$Res> {
  _$RegionCopyWithImpl(this._self, this._then);

  final Region _self;
  final $Res Function(Region) _then;

/// Create a copy of Region
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? countryCode = freezed,Object? isPopular = null,Object? country = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,isPopular: null == isPopular ? _self.isPopular : isPopular // ignore: cast_nullable_to_non_nullable
as bool,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as Country?,
  ));
}
/// Create a copy of Region
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CountryCopyWith<$Res>? get country {
    if (_self.country == null) {
    return null;
  }

  return $CountryCopyWith<$Res>(_self.country!, (value) {
    return _then(_self.copyWith(country: value));
  });
}
}


/// Adds pattern-matching-related methods to [Region].
extension RegionPatterns on Region {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Region value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Region() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Region value)  $default,){
final _that = this;
switch (_that) {
case _Region():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Region value)?  $default,){
final _that = this;
switch (_that) {
case _Region() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? name,  String? countryCode,  bool isPopular, @JsonKey(name: 'countries')  Country? country)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Region() when $default != null:
return $default(_that.id,_that.name,_that.countryCode,_that.isPopular,_that.country);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? name,  String? countryCode,  bool isPopular, @JsonKey(name: 'countries')  Country? country)  $default,) {final _that = this;
switch (_that) {
case _Region():
return $default(_that.id,_that.name,_that.countryCode,_that.isPopular,_that.country);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? name,  String? countryCode,  bool isPopular, @JsonKey(name: 'countries')  Country? country)?  $default,) {final _that = this;
switch (_that) {
case _Region() when $default != null:
return $default(_that.id,_that.name,_that.countryCode,_that.isPopular,_that.country);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Region implements Region {
  const _Region({this.id, this.name, this.countryCode, this.isPopular = false, @JsonKey(name: 'countries') this.country});
  factory _Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);

@override final  String? id;
@override final  String? name;
@override final  String? countryCode;
@override@JsonKey() final  bool isPopular;
@override@JsonKey(name: 'countries') final  Country? country;

/// Create a copy of Region
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegionCopyWith<_Region> get copyWith => __$RegionCopyWithImpl<_Region>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Region&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.isPopular, isPopular) || other.isPopular == isPopular)&&(identical(other.country, country) || other.country == country));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,countryCode,isPopular,country);

@override
String toString() {
  return 'Region(id: $id, name: $name, countryCode: $countryCode, isPopular: $isPopular, country: $country)';
}


}

/// @nodoc
abstract mixin class _$RegionCopyWith<$Res> implements $RegionCopyWith<$Res> {
  factory _$RegionCopyWith(_Region value, $Res Function(_Region) _then) = __$RegionCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? name, String? countryCode, bool isPopular,@JsonKey(name: 'countries') Country? country
});


@override $CountryCopyWith<$Res>? get country;

}
/// @nodoc
class __$RegionCopyWithImpl<$Res>
    implements _$RegionCopyWith<$Res> {
  __$RegionCopyWithImpl(this._self, this._then);

  final _Region _self;
  final $Res Function(_Region) _then;

/// Create a copy of Region
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? countryCode = freezed,Object? isPopular = null,Object? country = freezed,}) {
  return _then(_Region(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,isPopular: null == isPopular ? _self.isPopular : isPopular // ignore: cast_nullable_to_non_nullable
as bool,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as Country?,
  ));
}

/// Create a copy of Region
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CountryCopyWith<$Res>? get country {
    if (_self.country == null) {
    return null;
  }

  return $CountryCopyWith<$Res>(_self.country!, (value) {
    return _then(_self.copyWith(country: value));
  });
}
}

// dart format on
