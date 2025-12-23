// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'winery.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Winery {

 String? get id;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'description') String? get description;@JsonKey(name: 'logo_url') String? get logoUrl;@JsonKey(name: 'banner_url') String? get bannerUrl;@JsonKey(name: 'winemaker') String? get winemaker;@JsonKey(name: 'website') String? get website;@JsonKey(name: 'location_text') String? get locationText;@JsonKey(name: 'region_id') String? get regionId;@JsonKey(name: 'country_code') String? get countryCode;@JsonKey(name: 'latitude') double? get latitude;@JsonKey(name: 'longitude') double? get longitude;@JsonKey(name: 'founded_year') int? get foundedYear;@JsonKey(name: 'is_partner') bool? get isPartner;@JsonKey(name: 'phone') String? get phone;@JsonKey(name: 'email') String? get email;@JsonKey(name: 'country', fromJson: _countryFromJson) Country? get country;@JsonKey(name: 'region', fromJson: _regionFromJson) Region? get regionObject;
/// Create a copy of Winery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WineryCopyWith<Winery> get copyWith => _$WineryCopyWithImpl<Winery>(this as Winery, _$identity);

  /// Serializes this Winery to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Winery&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.bannerUrl, bannerUrl) || other.bannerUrl == bannerUrl)&&(identical(other.winemaker, winemaker) || other.winemaker == winemaker)&&(identical(other.website, website) || other.website == website)&&(identical(other.locationText, locationText) || other.locationText == locationText)&&(identical(other.regionId, regionId) || other.regionId == regionId)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.foundedYear, foundedYear) || other.foundedYear == foundedYear)&&(identical(other.isPartner, isPartner) || other.isPartner == isPartner)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.country, country) || other.country == country)&&(identical(other.regionObject, regionObject) || other.regionObject == regionObject));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,logoUrl,bannerUrl,winemaker,website,locationText,regionId,countryCode,latitude,longitude,foundedYear,isPartner,phone,email,country,regionObject);

@override
String toString() {
  return 'Winery(id: $id, name: $name, description: $description, logoUrl: $logoUrl, bannerUrl: $bannerUrl, winemaker: $winemaker, website: $website, locationText: $locationText, regionId: $regionId, countryCode: $countryCode, latitude: $latitude, longitude: $longitude, foundedYear: $foundedYear, isPartner: $isPartner, phone: $phone, email: $email, country: $country, regionObject: $regionObject)';
}


}

/// @nodoc
abstract mixin class $WineryCopyWith<$Res>  {
  factory $WineryCopyWith(Winery value, $Res Function(Winery) _then) = _$WineryCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'name') String? name,@JsonKey(name: 'description') String? description,@JsonKey(name: 'logo_url') String? logoUrl,@JsonKey(name: 'banner_url') String? bannerUrl,@JsonKey(name: 'winemaker') String? winemaker,@JsonKey(name: 'website') String? website,@JsonKey(name: 'location_text') String? locationText,@JsonKey(name: 'region_id') String? regionId,@JsonKey(name: 'country_code') String? countryCode,@JsonKey(name: 'latitude') double? latitude,@JsonKey(name: 'longitude') double? longitude,@JsonKey(name: 'founded_year') int? foundedYear,@JsonKey(name: 'is_partner') bool? isPartner,@JsonKey(name: 'phone') String? phone,@JsonKey(name: 'email') String? email,@JsonKey(name: 'country', fromJson: _countryFromJson) Country? country,@JsonKey(name: 'region', fromJson: _regionFromJson) Region? regionObject
});


$CountryCopyWith<$Res>? get country;$RegionCopyWith<$Res>? get regionObject;

}
/// @nodoc
class _$WineryCopyWithImpl<$Res>
    implements $WineryCopyWith<$Res> {
  _$WineryCopyWithImpl(this._self, this._then);

  final Winery _self;
  final $Res Function(Winery) _then;

/// Create a copy of Winery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? description = freezed,Object? logoUrl = freezed,Object? bannerUrl = freezed,Object? winemaker = freezed,Object? website = freezed,Object? locationText = freezed,Object? regionId = freezed,Object? countryCode = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? foundedYear = freezed,Object? isPartner = freezed,Object? phone = freezed,Object? email = freezed,Object? country = freezed,Object? regionObject = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,bannerUrl: freezed == bannerUrl ? _self.bannerUrl : bannerUrl // ignore: cast_nullable_to_non_nullable
as String?,winemaker: freezed == winemaker ? _self.winemaker : winemaker // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,locationText: freezed == locationText ? _self.locationText : locationText // ignore: cast_nullable_to_non_nullable
as String?,regionId: freezed == regionId ? _self.regionId : regionId // ignore: cast_nullable_to_non_nullable
as String?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,foundedYear: freezed == foundedYear ? _self.foundedYear : foundedYear // ignore: cast_nullable_to_non_nullable
as int?,isPartner: freezed == isPartner ? _self.isPartner : isPartner // ignore: cast_nullable_to_non_nullable
as bool?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as Country?,regionObject: freezed == regionObject ? _self.regionObject : regionObject // ignore: cast_nullable_to_non_nullable
as Region?,
  ));
}
/// Create a copy of Winery
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
}/// Create a copy of Winery
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RegionCopyWith<$Res>? get regionObject {
    if (_self.regionObject == null) {
    return null;
  }

  return $RegionCopyWith<$Res>(_self.regionObject!, (value) {
    return _then(_self.copyWith(regionObject: value));
  });
}
}


/// Adds pattern-matching-related methods to [Winery].
extension WineryPatterns on Winery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Winery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Winery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Winery value)  $default,){
final _that = this;
switch (_that) {
case _Winery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Winery value)?  $default,){
final _that = this;
switch (_that) {
case _Winery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'logo_url')  String? logoUrl, @JsonKey(name: 'banner_url')  String? bannerUrl, @JsonKey(name: 'winemaker')  String? winemaker, @JsonKey(name: 'website')  String? website, @JsonKey(name: 'location_text')  String? locationText, @JsonKey(name: 'region_id')  String? regionId, @JsonKey(name: 'country_code')  String? countryCode, @JsonKey(name: 'latitude')  double? latitude, @JsonKey(name: 'longitude')  double? longitude, @JsonKey(name: 'founded_year')  int? foundedYear, @JsonKey(name: 'is_partner')  bool? isPartner, @JsonKey(name: 'phone')  String? phone, @JsonKey(name: 'email')  String? email, @JsonKey(name: 'country', fromJson: _countryFromJson)  Country? country, @JsonKey(name: 'region', fromJson: _regionFromJson)  Region? regionObject)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Winery() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.logoUrl,_that.bannerUrl,_that.winemaker,_that.website,_that.locationText,_that.regionId,_that.countryCode,_that.latitude,_that.longitude,_that.foundedYear,_that.isPartner,_that.phone,_that.email,_that.country,_that.regionObject);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'logo_url')  String? logoUrl, @JsonKey(name: 'banner_url')  String? bannerUrl, @JsonKey(name: 'winemaker')  String? winemaker, @JsonKey(name: 'website')  String? website, @JsonKey(name: 'location_text')  String? locationText, @JsonKey(name: 'region_id')  String? regionId, @JsonKey(name: 'country_code')  String? countryCode, @JsonKey(name: 'latitude')  double? latitude, @JsonKey(name: 'longitude')  double? longitude, @JsonKey(name: 'founded_year')  int? foundedYear, @JsonKey(name: 'is_partner')  bool? isPartner, @JsonKey(name: 'phone')  String? phone, @JsonKey(name: 'email')  String? email, @JsonKey(name: 'country', fromJson: _countryFromJson)  Country? country, @JsonKey(name: 'region', fromJson: _regionFromJson)  Region? regionObject)  $default,) {final _that = this;
switch (_that) {
case _Winery():
return $default(_that.id,_that.name,_that.description,_that.logoUrl,_that.bannerUrl,_that.winemaker,_that.website,_that.locationText,_that.regionId,_that.countryCode,_that.latitude,_that.longitude,_that.foundedYear,_that.isPartner,_that.phone,_that.email,_that.country,_that.regionObject);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'logo_url')  String? logoUrl, @JsonKey(name: 'banner_url')  String? bannerUrl, @JsonKey(name: 'winemaker')  String? winemaker, @JsonKey(name: 'website')  String? website, @JsonKey(name: 'location_text')  String? locationText, @JsonKey(name: 'region_id')  String? regionId, @JsonKey(name: 'country_code')  String? countryCode, @JsonKey(name: 'latitude')  double? latitude, @JsonKey(name: 'longitude')  double? longitude, @JsonKey(name: 'founded_year')  int? foundedYear, @JsonKey(name: 'is_partner')  bool? isPartner, @JsonKey(name: 'phone')  String? phone, @JsonKey(name: 'email')  String? email, @JsonKey(name: 'country', fromJson: _countryFromJson)  Country? country, @JsonKey(name: 'region', fromJson: _regionFromJson)  Region? regionObject)?  $default,) {final _that = this;
switch (_that) {
case _Winery() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.logoUrl,_that.bannerUrl,_that.winemaker,_that.website,_that.locationText,_that.regionId,_that.countryCode,_that.latitude,_that.longitude,_that.foundedYear,_that.isPartner,_that.phone,_that.email,_that.country,_that.regionObject);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Winery implements Winery {
  const _Winery({this.id, @JsonKey(name: 'name') this.name, @JsonKey(name: 'description') this.description, @JsonKey(name: 'logo_url') this.logoUrl, @JsonKey(name: 'banner_url') this.bannerUrl, @JsonKey(name: 'winemaker') this.winemaker, @JsonKey(name: 'website') this.website, @JsonKey(name: 'location_text') this.locationText, @JsonKey(name: 'region_id') this.regionId, @JsonKey(name: 'country_code') this.countryCode, @JsonKey(name: 'latitude') this.latitude, @JsonKey(name: 'longitude') this.longitude, @JsonKey(name: 'founded_year') this.foundedYear, @JsonKey(name: 'is_partner') this.isPartner, @JsonKey(name: 'phone') this.phone, @JsonKey(name: 'email') this.email, @JsonKey(name: 'country', fromJson: _countryFromJson) this.country, @JsonKey(name: 'region', fromJson: _regionFromJson) this.regionObject});
  factory _Winery.fromJson(Map<String, dynamic> json) => _$WineryFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'description') final  String? description;
@override@JsonKey(name: 'logo_url') final  String? logoUrl;
@override@JsonKey(name: 'banner_url') final  String? bannerUrl;
@override@JsonKey(name: 'winemaker') final  String? winemaker;
@override@JsonKey(name: 'website') final  String? website;
@override@JsonKey(name: 'location_text') final  String? locationText;
@override@JsonKey(name: 'region_id') final  String? regionId;
@override@JsonKey(name: 'country_code') final  String? countryCode;
@override@JsonKey(name: 'latitude') final  double? latitude;
@override@JsonKey(name: 'longitude') final  double? longitude;
@override@JsonKey(name: 'founded_year') final  int? foundedYear;
@override@JsonKey(name: 'is_partner') final  bool? isPartner;
@override@JsonKey(name: 'phone') final  String? phone;
@override@JsonKey(name: 'email') final  String? email;
@override@JsonKey(name: 'country', fromJson: _countryFromJson) final  Country? country;
@override@JsonKey(name: 'region', fromJson: _regionFromJson) final  Region? regionObject;

/// Create a copy of Winery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WineryCopyWith<_Winery> get copyWith => __$WineryCopyWithImpl<_Winery>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WineryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Winery&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.bannerUrl, bannerUrl) || other.bannerUrl == bannerUrl)&&(identical(other.winemaker, winemaker) || other.winemaker == winemaker)&&(identical(other.website, website) || other.website == website)&&(identical(other.locationText, locationText) || other.locationText == locationText)&&(identical(other.regionId, regionId) || other.regionId == regionId)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.foundedYear, foundedYear) || other.foundedYear == foundedYear)&&(identical(other.isPartner, isPartner) || other.isPartner == isPartner)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.country, country) || other.country == country)&&(identical(other.regionObject, regionObject) || other.regionObject == regionObject));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,logoUrl,bannerUrl,winemaker,website,locationText,regionId,countryCode,latitude,longitude,foundedYear,isPartner,phone,email,country,regionObject);

@override
String toString() {
  return 'Winery(id: $id, name: $name, description: $description, logoUrl: $logoUrl, bannerUrl: $bannerUrl, winemaker: $winemaker, website: $website, locationText: $locationText, regionId: $regionId, countryCode: $countryCode, latitude: $latitude, longitude: $longitude, foundedYear: $foundedYear, isPartner: $isPartner, phone: $phone, email: $email, country: $country, regionObject: $regionObject)';
}


}

/// @nodoc
abstract mixin class _$WineryCopyWith<$Res> implements $WineryCopyWith<$Res> {
  factory _$WineryCopyWith(_Winery value, $Res Function(_Winery) _then) = __$WineryCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'name') String? name,@JsonKey(name: 'description') String? description,@JsonKey(name: 'logo_url') String? logoUrl,@JsonKey(name: 'banner_url') String? bannerUrl,@JsonKey(name: 'winemaker') String? winemaker,@JsonKey(name: 'website') String? website,@JsonKey(name: 'location_text') String? locationText,@JsonKey(name: 'region_id') String? regionId,@JsonKey(name: 'country_code') String? countryCode,@JsonKey(name: 'latitude') double? latitude,@JsonKey(name: 'longitude') double? longitude,@JsonKey(name: 'founded_year') int? foundedYear,@JsonKey(name: 'is_partner') bool? isPartner,@JsonKey(name: 'phone') String? phone,@JsonKey(name: 'email') String? email,@JsonKey(name: 'country', fromJson: _countryFromJson) Country? country,@JsonKey(name: 'region', fromJson: _regionFromJson) Region? regionObject
});


@override $CountryCopyWith<$Res>? get country;@override $RegionCopyWith<$Res>? get regionObject;

}
/// @nodoc
class __$WineryCopyWithImpl<$Res>
    implements _$WineryCopyWith<$Res> {
  __$WineryCopyWithImpl(this._self, this._then);

  final _Winery _self;
  final $Res Function(_Winery) _then;

/// Create a copy of Winery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? description = freezed,Object? logoUrl = freezed,Object? bannerUrl = freezed,Object? winemaker = freezed,Object? website = freezed,Object? locationText = freezed,Object? regionId = freezed,Object? countryCode = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? foundedYear = freezed,Object? isPartner = freezed,Object? phone = freezed,Object? email = freezed,Object? country = freezed,Object? regionObject = freezed,}) {
  return _then(_Winery(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,bannerUrl: freezed == bannerUrl ? _self.bannerUrl : bannerUrl // ignore: cast_nullable_to_non_nullable
as String?,winemaker: freezed == winemaker ? _self.winemaker : winemaker // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,locationText: freezed == locationText ? _self.locationText : locationText // ignore: cast_nullable_to_non_nullable
as String?,regionId: freezed == regionId ? _self.regionId : regionId // ignore: cast_nullable_to_non_nullable
as String?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,foundedYear: freezed == foundedYear ? _self.foundedYear : foundedYear // ignore: cast_nullable_to_non_nullable
as int?,isPartner: freezed == isPartner ? _self.isPartner : isPartner // ignore: cast_nullable_to_non_nullable
as bool?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as Country?,regionObject: freezed == regionObject ? _self.regionObject : regionObject // ignore: cast_nullable_to_non_nullable
as Region?,
  ));
}

/// Create a copy of Winery
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
}/// Create a copy of Winery
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RegionCopyWith<$Res>? get regionObject {
    if (_self.regionObject == null) {
    return null;
  }

  return $RegionCopyWith<$Res>(_self.regionObject!, (value) {
    return _then(_self.copyWith(regionObject: value));
  });
}
}

// dart format on
