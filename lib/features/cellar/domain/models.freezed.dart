// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserTasting {

 String? get id; String? get userId; String? get wineId; DateTime? get tastingDate; double? get rating; String? get notes; String? get photoUrl; DateTime? get createdAt; DateTime? get updatedAt; Wine get wine;
/// Create a copy of UserTasting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserTastingCopyWith<UserTasting> get copyWith => _$UserTastingCopyWithImpl<UserTasting>(this as UserTasting, _$identity);

  /// Serializes this UserTasting to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserTasting&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.wineId, wineId) || other.wineId == wineId)&&(identical(other.tastingDate, tastingDate) || other.tastingDate == tastingDate)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.wine, wine) || other.wine == wine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,wineId,tastingDate,rating,notes,photoUrl,createdAt,updatedAt,wine);

@override
String toString() {
  return 'UserTasting(id: $id, userId: $userId, wineId: $wineId, tastingDate: $tastingDate, rating: $rating, notes: $notes, photoUrl: $photoUrl, createdAt: $createdAt, updatedAt: $updatedAt, wine: $wine)';
}


}

/// @nodoc
abstract mixin class $UserTastingCopyWith<$Res>  {
  factory $UserTastingCopyWith(UserTasting value, $Res Function(UserTasting) _then) = _$UserTastingCopyWithImpl;
@useResult
$Res call({
 String? id, String? userId, String? wineId, DateTime? tastingDate, double? rating, String? notes, String? photoUrl, DateTime? createdAt, DateTime? updatedAt, Wine wine
});


$WineCopyWith<$Res> get wine;

}
/// @nodoc
class _$UserTastingCopyWithImpl<$Res>
    implements $UserTastingCopyWith<$Res> {
  _$UserTastingCopyWithImpl(this._self, this._then);

  final UserTasting _self;
  final $Res Function(UserTasting) _then;

/// Create a copy of UserTasting
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = freezed,Object? wineId = freezed,Object? tastingDate = freezed,Object? rating = freezed,Object? notes = freezed,Object? photoUrl = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? wine = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,wineId: freezed == wineId ? _self.wineId : wineId // ignore: cast_nullable_to_non_nullable
as String?,tastingDate: freezed == tastingDate ? _self.tastingDate : tastingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,wine: null == wine ? _self.wine : wine // ignore: cast_nullable_to_non_nullable
as Wine,
  ));
}
/// Create a copy of UserTasting
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WineCopyWith<$Res> get wine {
  
  return $WineCopyWith<$Res>(_self.wine, (value) {
    return _then(_self.copyWith(wine: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserTasting].
extension UserTastingPatterns on UserTasting {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserTasting value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserTasting() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserTasting value)  $default,){
final _that = this;
switch (_that) {
case _UserTasting():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserTasting value)?  $default,){
final _that = this;
switch (_that) {
case _UserTasting() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? userId,  String? wineId,  DateTime? tastingDate,  double? rating,  String? notes,  String? photoUrl,  DateTime? createdAt,  DateTime? updatedAt,  Wine wine)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserTasting() when $default != null:
return $default(_that.id,_that.userId,_that.wineId,_that.tastingDate,_that.rating,_that.notes,_that.photoUrl,_that.createdAt,_that.updatedAt,_that.wine);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? userId,  String? wineId,  DateTime? tastingDate,  double? rating,  String? notes,  String? photoUrl,  DateTime? createdAt,  DateTime? updatedAt,  Wine wine)  $default,) {final _that = this;
switch (_that) {
case _UserTasting():
return $default(_that.id,_that.userId,_that.wineId,_that.tastingDate,_that.rating,_that.notes,_that.photoUrl,_that.createdAt,_that.updatedAt,_that.wine);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? userId,  String? wineId,  DateTime? tastingDate,  double? rating,  String? notes,  String? photoUrl,  DateTime? createdAt,  DateTime? updatedAt,  Wine wine)?  $default,) {final _that = this;
switch (_that) {
case _UserTasting() when $default != null:
return $default(_that.id,_that.userId,_that.wineId,_that.tastingDate,_that.rating,_that.notes,_that.photoUrl,_that.createdAt,_that.updatedAt,_that.wine);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserTasting implements UserTasting {
  const _UserTasting({this.id, this.userId, this.wineId, this.tastingDate, this.rating, this.notes, this.photoUrl, this.createdAt, this.updatedAt, required this.wine});
  factory _UserTasting.fromJson(Map<String, dynamic> json) => _$UserTastingFromJson(json);

@override final  String? id;
@override final  String? userId;
@override final  String? wineId;
@override final  DateTime? tastingDate;
@override final  double? rating;
@override final  String? notes;
@override final  String? photoUrl;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override final  Wine wine;

/// Create a copy of UserTasting
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserTastingCopyWith<_UserTasting> get copyWith => __$UserTastingCopyWithImpl<_UserTasting>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserTastingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserTasting&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.wineId, wineId) || other.wineId == wineId)&&(identical(other.tastingDate, tastingDate) || other.tastingDate == tastingDate)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.wine, wine) || other.wine == wine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,wineId,tastingDate,rating,notes,photoUrl,createdAt,updatedAt,wine);

@override
String toString() {
  return 'UserTasting(id: $id, userId: $userId, wineId: $wineId, tastingDate: $tastingDate, rating: $rating, notes: $notes, photoUrl: $photoUrl, createdAt: $createdAt, updatedAt: $updatedAt, wine: $wine)';
}


}

/// @nodoc
abstract mixin class _$UserTastingCopyWith<$Res> implements $UserTastingCopyWith<$Res> {
  factory _$UserTastingCopyWith(_UserTasting value, $Res Function(_UserTasting) _then) = __$UserTastingCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? userId, String? wineId, DateTime? tastingDate, double? rating, String? notes, String? photoUrl, DateTime? createdAt, DateTime? updatedAt, Wine wine
});


@override $WineCopyWith<$Res> get wine;

}
/// @nodoc
class __$UserTastingCopyWithImpl<$Res>
    implements _$UserTastingCopyWith<$Res> {
  __$UserTastingCopyWithImpl(this._self, this._then);

  final _UserTasting _self;
  final $Res Function(_UserTasting) _then;

/// Create a copy of UserTasting
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = freezed,Object? wineId = freezed,Object? tastingDate = freezed,Object? rating = freezed,Object? notes = freezed,Object? photoUrl = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? wine = null,}) {
  return _then(_UserTasting(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,wineId: freezed == wineId ? _self.wineId : wineId // ignore: cast_nullable_to_non_nullable
as String?,tastingDate: freezed == tastingDate ? _self.tastingDate : tastingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,wine: null == wine ? _self.wine : wine // ignore: cast_nullable_to_non_nullable
as Wine,
  ));
}

/// Create a copy of UserTasting
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WineCopyWith<$Res> get wine {
  
  return $WineCopyWith<$Res>(_self.wine, (value) {
    return _then(_self.copyWith(wine: value));
  });
}
}


/// @nodoc
mixin _$UserStorageItem {

 String? get id; String? get userId; String? get wineId; int? get quantity; double? get purchasePrice; DateTime? get purchaseDate; int? get idealDrinkFrom;// Год
 int? get idealDrinkTo;// Год
 DateTime? get createdAt; DateTime? get updatedAt; Wine get wine;
/// Create a copy of UserStorageItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserStorageItemCopyWith<UserStorageItem> get copyWith => _$UserStorageItemCopyWithImpl<UserStorageItem>(this as UserStorageItem, _$identity);

  /// Serializes this UserStorageItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserStorageItem&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.wineId, wineId) || other.wineId == wineId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.idealDrinkFrom, idealDrinkFrom) || other.idealDrinkFrom == idealDrinkFrom)&&(identical(other.idealDrinkTo, idealDrinkTo) || other.idealDrinkTo == idealDrinkTo)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.wine, wine) || other.wine == wine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,wineId,quantity,purchasePrice,purchaseDate,idealDrinkFrom,idealDrinkTo,createdAt,updatedAt,wine);

@override
String toString() {
  return 'UserStorageItem(id: $id, userId: $userId, wineId: $wineId, quantity: $quantity, purchasePrice: $purchasePrice, purchaseDate: $purchaseDate, idealDrinkFrom: $idealDrinkFrom, idealDrinkTo: $idealDrinkTo, createdAt: $createdAt, updatedAt: $updatedAt, wine: $wine)';
}


}

/// @nodoc
abstract mixin class $UserStorageItemCopyWith<$Res>  {
  factory $UserStorageItemCopyWith(UserStorageItem value, $Res Function(UserStorageItem) _then) = _$UserStorageItemCopyWithImpl;
@useResult
$Res call({
 String? id, String? userId, String? wineId, int? quantity, double? purchasePrice, DateTime? purchaseDate, int? idealDrinkFrom, int? idealDrinkTo, DateTime? createdAt, DateTime? updatedAt, Wine wine
});


$WineCopyWith<$Res> get wine;

}
/// @nodoc
class _$UserStorageItemCopyWithImpl<$Res>
    implements $UserStorageItemCopyWith<$Res> {
  _$UserStorageItemCopyWithImpl(this._self, this._then);

  final UserStorageItem _self;
  final $Res Function(UserStorageItem) _then;

/// Create a copy of UserStorageItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = freezed,Object? wineId = freezed,Object? quantity = freezed,Object? purchasePrice = freezed,Object? purchaseDate = freezed,Object? idealDrinkFrom = freezed,Object? idealDrinkTo = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? wine = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,wineId: freezed == wineId ? _self.wineId : wineId // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int?,purchasePrice: freezed == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as double?,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,idealDrinkFrom: freezed == idealDrinkFrom ? _self.idealDrinkFrom : idealDrinkFrom // ignore: cast_nullable_to_non_nullable
as int?,idealDrinkTo: freezed == idealDrinkTo ? _self.idealDrinkTo : idealDrinkTo // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,wine: null == wine ? _self.wine : wine // ignore: cast_nullable_to_non_nullable
as Wine,
  ));
}
/// Create a copy of UserStorageItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WineCopyWith<$Res> get wine {
  
  return $WineCopyWith<$Res>(_self.wine, (value) {
    return _then(_self.copyWith(wine: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserStorageItem].
extension UserStorageItemPatterns on UserStorageItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserStorageItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserStorageItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserStorageItem value)  $default,){
final _that = this;
switch (_that) {
case _UserStorageItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserStorageItem value)?  $default,){
final _that = this;
switch (_that) {
case _UserStorageItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? userId,  String? wineId,  int? quantity,  double? purchasePrice,  DateTime? purchaseDate,  int? idealDrinkFrom,  int? idealDrinkTo,  DateTime? createdAt,  DateTime? updatedAt,  Wine wine)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserStorageItem() when $default != null:
return $default(_that.id,_that.userId,_that.wineId,_that.quantity,_that.purchasePrice,_that.purchaseDate,_that.idealDrinkFrom,_that.idealDrinkTo,_that.createdAt,_that.updatedAt,_that.wine);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? userId,  String? wineId,  int? quantity,  double? purchasePrice,  DateTime? purchaseDate,  int? idealDrinkFrom,  int? idealDrinkTo,  DateTime? createdAt,  DateTime? updatedAt,  Wine wine)  $default,) {final _that = this;
switch (_that) {
case _UserStorageItem():
return $default(_that.id,_that.userId,_that.wineId,_that.quantity,_that.purchasePrice,_that.purchaseDate,_that.idealDrinkFrom,_that.idealDrinkTo,_that.createdAt,_that.updatedAt,_that.wine);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? userId,  String? wineId,  int? quantity,  double? purchasePrice,  DateTime? purchaseDate,  int? idealDrinkFrom,  int? idealDrinkTo,  DateTime? createdAt,  DateTime? updatedAt,  Wine wine)?  $default,) {final _that = this;
switch (_that) {
case _UserStorageItem() when $default != null:
return $default(_that.id,_that.userId,_that.wineId,_that.quantity,_that.purchasePrice,_that.purchaseDate,_that.idealDrinkFrom,_that.idealDrinkTo,_that.createdAt,_that.updatedAt,_that.wine);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserStorageItem implements UserStorageItem {
  const _UserStorageItem({this.id, this.userId, this.wineId, this.quantity, this.purchasePrice, this.purchaseDate, this.idealDrinkFrom, this.idealDrinkTo, this.createdAt, this.updatedAt, required this.wine});
  factory _UserStorageItem.fromJson(Map<String, dynamic> json) => _$UserStorageItemFromJson(json);

@override final  String? id;
@override final  String? userId;
@override final  String? wineId;
@override final  int? quantity;
@override final  double? purchasePrice;
@override final  DateTime? purchaseDate;
@override final  int? idealDrinkFrom;
// Год
@override final  int? idealDrinkTo;
// Год
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override final  Wine wine;

/// Create a copy of UserStorageItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserStorageItemCopyWith<_UserStorageItem> get copyWith => __$UserStorageItemCopyWithImpl<_UserStorageItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserStorageItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserStorageItem&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.wineId, wineId) || other.wineId == wineId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.idealDrinkFrom, idealDrinkFrom) || other.idealDrinkFrom == idealDrinkFrom)&&(identical(other.idealDrinkTo, idealDrinkTo) || other.idealDrinkTo == idealDrinkTo)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.wine, wine) || other.wine == wine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,wineId,quantity,purchasePrice,purchaseDate,idealDrinkFrom,idealDrinkTo,createdAt,updatedAt,wine);

@override
String toString() {
  return 'UserStorageItem(id: $id, userId: $userId, wineId: $wineId, quantity: $quantity, purchasePrice: $purchasePrice, purchaseDate: $purchaseDate, idealDrinkFrom: $idealDrinkFrom, idealDrinkTo: $idealDrinkTo, createdAt: $createdAt, updatedAt: $updatedAt, wine: $wine)';
}


}

/// @nodoc
abstract mixin class _$UserStorageItemCopyWith<$Res> implements $UserStorageItemCopyWith<$Res> {
  factory _$UserStorageItemCopyWith(_UserStorageItem value, $Res Function(_UserStorageItem) _then) = __$UserStorageItemCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? userId, String? wineId, int? quantity, double? purchasePrice, DateTime? purchaseDate, int? idealDrinkFrom, int? idealDrinkTo, DateTime? createdAt, DateTime? updatedAt, Wine wine
});


@override $WineCopyWith<$Res> get wine;

}
/// @nodoc
class __$UserStorageItemCopyWithImpl<$Res>
    implements _$UserStorageItemCopyWith<$Res> {
  __$UserStorageItemCopyWithImpl(this._self, this._then);

  final _UserStorageItem _self;
  final $Res Function(_UserStorageItem) _then;

/// Create a copy of UserStorageItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = freezed,Object? wineId = freezed,Object? quantity = freezed,Object? purchasePrice = freezed,Object? purchaseDate = freezed,Object? idealDrinkFrom = freezed,Object? idealDrinkTo = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? wine = null,}) {
  return _then(_UserStorageItem(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,wineId: freezed == wineId ? _self.wineId : wineId // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int?,purchasePrice: freezed == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as double?,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,idealDrinkFrom: freezed == idealDrinkFrom ? _self.idealDrinkFrom : idealDrinkFrom // ignore: cast_nullable_to_non_nullable
as int?,idealDrinkTo: freezed == idealDrinkTo ? _self.idealDrinkTo : idealDrinkTo // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,wine: null == wine ? _self.wine : wine // ignore: cast_nullable_to_non_nullable
as Wine,
  ));
}

/// Create a copy of UserStorageItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WineCopyWith<$Res> get wine {
  
  return $WineCopyWith<$Res>(_self.wine, (value) {
    return _then(_self.copyWith(wine: value));
  });
}
}

// dart format on
