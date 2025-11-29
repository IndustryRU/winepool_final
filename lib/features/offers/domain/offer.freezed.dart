// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Offer {

 String get id;@JsonKey(name: 'seller_id') String? get sellerId;@JsonKey(name: 'wine_id') String? get wineId; double? get price; int? get vintage; double? get bottleSize;@JsonKey(name: 'created_at') DateTime? get createdAt; bool get isActive;@JsonKey(name: 'wines', includeToJson: false) Wine? get wine;@JsonKey(name: 'profiles', includeToJson: false) Profile? get seller;
/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfferCopyWith<Offer> get copyWith => _$OfferCopyWithImpl<Offer>(this as Offer, _$identity);

  /// Serializes this Offer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Offer&&(identical(other.id, id) || other.id == id)&&(identical(other.sellerId, sellerId) || other.sellerId == sellerId)&&(identical(other.wineId, wineId) || other.wineId == wineId)&&(identical(other.price, price) || other.price == price)&&(identical(other.vintage, vintage) || other.vintage == vintage)&&(identical(other.bottleSize, bottleSize) || other.bottleSize == bottleSize)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.wine, wine) || other.wine == wine)&&(identical(other.seller, seller) || other.seller == seller));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sellerId,wineId,price,vintage,bottleSize,createdAt,isActive,wine,seller);

@override
String toString() {
  return 'Offer(id: $id, sellerId: $sellerId, wineId: $wineId, price: $price, vintage: $vintage, bottleSize: $bottleSize, createdAt: $createdAt, isActive: $isActive, wine: $wine, seller: $seller)';
}


}

/// @nodoc
abstract mixin class $OfferCopyWith<$Res>  {
  factory $OfferCopyWith(Offer value, $Res Function(Offer) _then) = _$OfferCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'seller_id') String? sellerId,@JsonKey(name: 'wine_id') String? wineId, double? price, int? vintage, double? bottleSize,@JsonKey(name: 'created_at') DateTime? createdAt, bool isActive,@JsonKey(name: 'wines', includeToJson: false) Wine? wine,@JsonKey(name: 'profiles', includeToJson: false) Profile? seller
});


$WineCopyWith<$Res>? get wine;$ProfileCopyWith<$Res>? get seller;

}
/// @nodoc
class _$OfferCopyWithImpl<$Res>
    implements $OfferCopyWith<$Res> {
  _$OfferCopyWithImpl(this._self, this._then);

  final Offer _self;
  final $Res Function(Offer) _then;

/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sellerId = freezed,Object? wineId = freezed,Object? price = freezed,Object? vintage = freezed,Object? bottleSize = freezed,Object? createdAt = freezed,Object? isActive = null,Object? wine = freezed,Object? seller = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sellerId: freezed == sellerId ? _self.sellerId : sellerId // ignore: cast_nullable_to_non_nullable
as String?,wineId: freezed == wineId ? _self.wineId : wineId // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,vintage: freezed == vintage ? _self.vintage : vintage // ignore: cast_nullable_to_non_nullable
as int?,bottleSize: freezed == bottleSize ? _self.bottleSize : bottleSize // ignore: cast_nullable_to_non_nullable
as double?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,wine: freezed == wine ? _self.wine : wine // ignore: cast_nullable_to_non_nullable
as Wine?,seller: freezed == seller ? _self.seller : seller // ignore: cast_nullable_to_non_nullable
as Profile?,
  ));
}
/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WineCopyWith<$Res>? get wine {
    if (_self.wine == null) {
    return null;
  }

  return $WineCopyWith<$Res>(_self.wine!, (value) {
    return _then(_self.copyWith(wine: value));
  });
}/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileCopyWith<$Res>? get seller {
    if (_self.seller == null) {
    return null;
  }

  return $ProfileCopyWith<$Res>(_self.seller!, (value) {
    return _then(_self.copyWith(seller: value));
  });
}
}


/// Adds pattern-matching-related methods to [Offer].
extension OfferPatterns on Offer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Offer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Offer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Offer value)  $default,){
final _that = this;
switch (_that) {
case _Offer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Offer value)?  $default,){
final _that = this;
switch (_that) {
case _Offer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'seller_id')  String? sellerId, @JsonKey(name: 'wine_id')  String? wineId,  double? price,  int? vintage,  double? bottleSize, @JsonKey(name: 'created_at')  DateTime? createdAt,  bool isActive, @JsonKey(name: 'wines', includeToJson: false)  Wine? wine, @JsonKey(name: 'profiles', includeToJson: false)  Profile? seller)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Offer() when $default != null:
return $default(_that.id,_that.sellerId,_that.wineId,_that.price,_that.vintage,_that.bottleSize,_that.createdAt,_that.isActive,_that.wine,_that.seller);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'seller_id')  String? sellerId, @JsonKey(name: 'wine_id')  String? wineId,  double? price,  int? vintage,  double? bottleSize, @JsonKey(name: 'created_at')  DateTime? createdAt,  bool isActive, @JsonKey(name: 'wines', includeToJson: false)  Wine? wine, @JsonKey(name: 'profiles', includeToJson: false)  Profile? seller)  $default,) {final _that = this;
switch (_that) {
case _Offer():
return $default(_that.id,_that.sellerId,_that.wineId,_that.price,_that.vintage,_that.bottleSize,_that.createdAt,_that.isActive,_that.wine,_that.seller);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'seller_id')  String? sellerId, @JsonKey(name: 'wine_id')  String? wineId,  double? price,  int? vintage,  double? bottleSize, @JsonKey(name: 'created_at')  DateTime? createdAt,  bool isActive, @JsonKey(name: 'wines', includeToJson: false)  Wine? wine, @JsonKey(name: 'profiles', includeToJson: false)  Profile? seller)?  $default,) {final _that = this;
switch (_that) {
case _Offer() when $default != null:
return $default(_that.id,_that.sellerId,_that.wineId,_that.price,_that.vintage,_that.bottleSize,_that.createdAt,_that.isActive,_that.wine,_that.seller);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Offer implements Offer {
  const _Offer({required this.id, @JsonKey(name: 'seller_id') this.sellerId, @JsonKey(name: 'wine_id') this.wineId, this.price, this.vintage, this.bottleSize, @JsonKey(name: 'created_at') this.createdAt, this.isActive = true, @JsonKey(name: 'wines', includeToJson: false) this.wine, @JsonKey(name: 'profiles', includeToJson: false) this.seller});
  factory _Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

@override final  String id;
@override@JsonKey(name: 'seller_id') final  String? sellerId;
@override@JsonKey(name: 'wine_id') final  String? wineId;
@override final  double? price;
@override final  int? vintage;
@override final  double? bottleSize;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey() final  bool isActive;
@override@JsonKey(name: 'wines', includeToJson: false) final  Wine? wine;
@override@JsonKey(name: 'profiles', includeToJson: false) final  Profile? seller;

/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfferCopyWith<_Offer> get copyWith => __$OfferCopyWithImpl<_Offer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OfferToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Offer&&(identical(other.id, id) || other.id == id)&&(identical(other.sellerId, sellerId) || other.sellerId == sellerId)&&(identical(other.wineId, wineId) || other.wineId == wineId)&&(identical(other.price, price) || other.price == price)&&(identical(other.vintage, vintage) || other.vintage == vintage)&&(identical(other.bottleSize, bottleSize) || other.bottleSize == bottleSize)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.wine, wine) || other.wine == wine)&&(identical(other.seller, seller) || other.seller == seller));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sellerId,wineId,price,vintage,bottleSize,createdAt,isActive,wine,seller);

@override
String toString() {
  return 'Offer(id: $id, sellerId: $sellerId, wineId: $wineId, price: $price, vintage: $vintage, bottleSize: $bottleSize, createdAt: $createdAt, isActive: $isActive, wine: $wine, seller: $seller)';
}


}

/// @nodoc
abstract mixin class _$OfferCopyWith<$Res> implements $OfferCopyWith<$Res> {
  factory _$OfferCopyWith(_Offer value, $Res Function(_Offer) _then) = __$OfferCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'seller_id') String? sellerId,@JsonKey(name: 'wine_id') String? wineId, double? price, int? vintage, double? bottleSize,@JsonKey(name: 'created_at') DateTime? createdAt, bool isActive,@JsonKey(name: 'wines', includeToJson: false) Wine? wine,@JsonKey(name: 'profiles', includeToJson: false) Profile? seller
});


@override $WineCopyWith<$Res>? get wine;@override $ProfileCopyWith<$Res>? get seller;

}
/// @nodoc
class __$OfferCopyWithImpl<$Res>
    implements _$OfferCopyWith<$Res> {
  __$OfferCopyWithImpl(this._self, this._then);

  final _Offer _self;
  final $Res Function(_Offer) _then;

/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sellerId = freezed,Object? wineId = freezed,Object? price = freezed,Object? vintage = freezed,Object? bottleSize = freezed,Object? createdAt = freezed,Object? isActive = null,Object? wine = freezed,Object? seller = freezed,}) {
  return _then(_Offer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sellerId: freezed == sellerId ? _self.sellerId : sellerId // ignore: cast_nullable_to_non_nullable
as String?,wineId: freezed == wineId ? _self.wineId : wineId // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,vintage: freezed == vintage ? _self.vintage : vintage // ignore: cast_nullable_to_non_nullable
as int?,bottleSize: freezed == bottleSize ? _self.bottleSize : bottleSize // ignore: cast_nullable_to_non_nullable
as double?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,wine: freezed == wine ? _self.wine : wine // ignore: cast_nullable_to_non_nullable
as Wine?,seller: freezed == seller ? _self.seller : seller // ignore: cast_nullable_to_non_nullable
as Profile?,
  ));
}

/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WineCopyWith<$Res>? get wine {
    if (_self.wine == null) {
    return null;
  }

  return $WineCopyWith<$Res>(_self.wine!, (value) {
    return _then(_self.copyWith(wine: value));
  });
}/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileCopyWith<$Res>? get seller {
    if (_self.seller == null) {
    return null;
  }

  return $ProfileCopyWith<$Res>(_self.seller!, (value) {
    return _then(_self.copyWith(seller: value));
  });
}
}

// dart format on
