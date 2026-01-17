// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grape_variety.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GrapeVariety {

 String? get id; String? get name; String? get description; String? get originRegion; DateTime? get createdAt; DateTime? get updatedAt; bool get isPopular;
/// Create a copy of GrapeVariety
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GrapeVarietyCopyWith<GrapeVariety> get copyWith => _$GrapeVarietyCopyWithImpl<GrapeVariety>(this as GrapeVariety, _$identity);

  /// Serializes this GrapeVariety to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GrapeVariety&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.originRegion, originRegion) || other.originRegion == originRegion)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isPopular, isPopular) || other.isPopular == isPopular));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,originRegion,createdAt,updatedAt,isPopular);

@override
String toString() {
  return 'GrapeVariety(id: $id, name: $name, description: $description, originRegion: $originRegion, createdAt: $createdAt, updatedAt: $updatedAt, isPopular: $isPopular)';
}


}

/// @nodoc
abstract mixin class $GrapeVarietyCopyWith<$Res>  {
  factory $GrapeVarietyCopyWith(GrapeVariety value, $Res Function(GrapeVariety) _then) = _$GrapeVarietyCopyWithImpl;
@useResult
$Res call({
 String? id, String? name, String? description, String? originRegion, DateTime? createdAt, DateTime? updatedAt, bool isPopular
});




}
/// @nodoc
class _$GrapeVarietyCopyWithImpl<$Res>
    implements $GrapeVarietyCopyWith<$Res> {
  _$GrapeVarietyCopyWithImpl(this._self, this._then);

  final GrapeVariety _self;
  final $Res Function(GrapeVariety) _then;

/// Create a copy of GrapeVariety
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? description = freezed,Object? originRegion = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? isPopular = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,originRegion: freezed == originRegion ? _self.originRegion : originRegion // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isPopular: null == isPopular ? _self.isPopular : isPopular // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GrapeVariety].
extension GrapeVarietyPatterns on GrapeVariety {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GrapeVariety value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GrapeVariety() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GrapeVariety value)  $default,){
final _that = this;
switch (_that) {
case _GrapeVariety():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GrapeVariety value)?  $default,){
final _that = this;
switch (_that) {
case _GrapeVariety() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? name,  String? description,  String? originRegion,  DateTime? createdAt,  DateTime? updatedAt,  bool isPopular)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GrapeVariety() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.originRegion,_that.createdAt,_that.updatedAt,_that.isPopular);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? name,  String? description,  String? originRegion,  DateTime? createdAt,  DateTime? updatedAt,  bool isPopular)  $default,) {final _that = this;
switch (_that) {
case _GrapeVariety():
return $default(_that.id,_that.name,_that.description,_that.originRegion,_that.createdAt,_that.updatedAt,_that.isPopular);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? name,  String? description,  String? originRegion,  DateTime? createdAt,  DateTime? updatedAt,  bool isPopular)?  $default,) {final _that = this;
switch (_that) {
case _GrapeVariety() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.originRegion,_that.createdAt,_that.updatedAt,_that.isPopular);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _GrapeVariety implements GrapeVariety {
  const _GrapeVariety({this.id, this.name, this.description, this.originRegion, this.createdAt, this.updatedAt, this.isPopular = false});
  factory _GrapeVariety.fromJson(Map<String, dynamic> json) => _$GrapeVarietyFromJson(json);

@override final  String? id;
@override final  String? name;
@override final  String? description;
@override final  String? originRegion;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override@JsonKey() final  bool isPopular;

/// Create a copy of GrapeVariety
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GrapeVarietyCopyWith<_GrapeVariety> get copyWith => __$GrapeVarietyCopyWithImpl<_GrapeVariety>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GrapeVarietyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GrapeVariety&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.originRegion, originRegion) || other.originRegion == originRegion)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isPopular, isPopular) || other.isPopular == isPopular));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,originRegion,createdAt,updatedAt,isPopular);

@override
String toString() {
  return 'GrapeVariety(id: $id, name: $name, description: $description, originRegion: $originRegion, createdAt: $createdAt, updatedAt: $updatedAt, isPopular: $isPopular)';
}


}

/// @nodoc
abstract mixin class _$GrapeVarietyCopyWith<$Res> implements $GrapeVarietyCopyWith<$Res> {
  factory _$GrapeVarietyCopyWith(_GrapeVariety value, $Res Function(_GrapeVariety) _then) = __$GrapeVarietyCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? name, String? description, String? originRegion, DateTime? createdAt, DateTime? updatedAt, bool isPopular
});




}
/// @nodoc
class __$GrapeVarietyCopyWithImpl<$Res>
    implements _$GrapeVarietyCopyWith<$Res> {
  __$GrapeVarietyCopyWithImpl(this._self, this._then);

  final _GrapeVariety _self;
  final $Res Function(_GrapeVariety) _then;

/// Create a copy of GrapeVariety
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? description = freezed,Object? originRegion = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? isPopular = null,}) {
  return _then(_GrapeVariety(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,originRegion: freezed == originRegion ? _self.originRegion : originRegion // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isPopular: null == isPopular ? _self.isPopular : isPopular // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
