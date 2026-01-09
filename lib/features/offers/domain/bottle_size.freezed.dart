// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bottle_size.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BottleSize {

 String? get id;@JsonKey(name: 'size_ml') int? get sizeMl;@JsonKey(name: 'size_l') String? get sizeL;
/// Create a copy of BottleSize
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BottleSizeCopyWith<BottleSize> get copyWith => _$BottleSizeCopyWithImpl<BottleSize>(this as BottleSize, _$identity);

  /// Serializes this BottleSize to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BottleSize&&(identical(other.id, id) || other.id == id)&&(identical(other.sizeMl, sizeMl) || other.sizeMl == sizeMl)&&(identical(other.sizeL, sizeL) || other.sizeL == sizeL));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sizeMl,sizeL);

@override
String toString() {
  return 'BottleSize(id: $id, sizeMl: $sizeMl, sizeL: $sizeL)';
}


}

/// @nodoc
abstract mixin class $BottleSizeCopyWith<$Res>  {
  factory $BottleSizeCopyWith(BottleSize value, $Res Function(BottleSize) _then) = _$BottleSizeCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'size_ml') int? sizeMl,@JsonKey(name: 'size_l') String? sizeL
});




}
/// @nodoc
class _$BottleSizeCopyWithImpl<$Res>
    implements $BottleSizeCopyWith<$Res> {
  _$BottleSizeCopyWithImpl(this._self, this._then);

  final BottleSize _self;
  final $Res Function(BottleSize) _then;

/// Create a copy of BottleSize
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? sizeMl = freezed,Object? sizeL = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,sizeMl: freezed == sizeMl ? _self.sizeMl : sizeMl // ignore: cast_nullable_to_non_nullable
as int?,sizeL: freezed == sizeL ? _self.sizeL : sizeL // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BottleSize].
extension BottleSizePatterns on BottleSize {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BottleSize value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BottleSize() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BottleSize value)  $default,){
final _that = this;
switch (_that) {
case _BottleSize():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BottleSize value)?  $default,){
final _that = this;
switch (_that) {
case _BottleSize() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'size_ml')  int? sizeMl, @JsonKey(name: 'size_l')  String? sizeL)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BottleSize() when $default != null:
return $default(_that.id,_that.sizeMl,_that.sizeL);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'size_ml')  int? sizeMl, @JsonKey(name: 'size_l')  String? sizeL)  $default,) {final _that = this;
switch (_that) {
case _BottleSize():
return $default(_that.id,_that.sizeMl,_that.sizeL);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'size_ml')  int? sizeMl, @JsonKey(name: 'size_l')  String? sizeL)?  $default,) {final _that = this;
switch (_that) {
case _BottleSize() when $default != null:
return $default(_that.id,_that.sizeMl,_that.sizeL);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BottleSize implements BottleSize {
  const _BottleSize({this.id, @JsonKey(name: 'size_ml') this.sizeMl, @JsonKey(name: 'size_l') this.sizeL});
  factory _BottleSize.fromJson(Map<String, dynamic> json) => _$BottleSizeFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'size_ml') final  int? sizeMl;
@override@JsonKey(name: 'size_l') final  String? sizeL;

/// Create a copy of BottleSize
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BottleSizeCopyWith<_BottleSize> get copyWith => __$BottleSizeCopyWithImpl<_BottleSize>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BottleSizeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BottleSize&&(identical(other.id, id) || other.id == id)&&(identical(other.sizeMl, sizeMl) || other.sizeMl == sizeMl)&&(identical(other.sizeL, sizeL) || other.sizeL == sizeL));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sizeMl,sizeL);

@override
String toString() {
  return 'BottleSize(id: $id, sizeMl: $sizeMl, sizeL: $sizeL)';
}


}

/// @nodoc
abstract mixin class _$BottleSizeCopyWith<$Res> implements $BottleSizeCopyWith<$Res> {
  factory _$BottleSizeCopyWith(_BottleSize value, $Res Function(_BottleSize) _then) = __$BottleSizeCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'size_ml') int? sizeMl,@JsonKey(name: 'size_l') String? sizeL
});




}
/// @nodoc
class __$BottleSizeCopyWithImpl<$Res>
    implements _$BottleSizeCopyWith<$Res> {
  __$BottleSizeCopyWithImpl(this._self, this._then);

  final _BottleSize _self;
  final $Res Function(_BottleSize) _then;

/// Create a copy of BottleSize
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? sizeMl = freezed,Object? sizeL = freezed,}) {
  return _then(_BottleSize(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,sizeMl: freezed == sizeMl ? _self.sizeMl : sizeMl // ignore: cast_nullable_to_non_nullable
as int?,sizeL: freezed == sizeL ? _self.sizeL : sizeL // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
