// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnalyticsData {

 List<TopVariety> get topVarieties; List<TopCountry> get topCountries; double? get averageRating; TasteWeb? get tasteWeb;
/// Create a copy of AnalyticsData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsDataCopyWith<AnalyticsData> get copyWith => _$AnalyticsDataCopyWithImpl<AnalyticsData>(this as AnalyticsData, _$identity);

  /// Serializes this AnalyticsData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsData&&const DeepCollectionEquality().equals(other.topVarieties, topVarieties)&&const DeepCollectionEquality().equals(other.topCountries, topCountries)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.tasteWeb, tasteWeb) || other.tasteWeb == tasteWeb));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(topVarieties),const DeepCollectionEquality().hash(topCountries),averageRating,tasteWeb);

@override
String toString() {
  return 'AnalyticsData(topVarieties: $topVarieties, topCountries: $topCountries, averageRating: $averageRating, tasteWeb: $tasteWeb)';
}


}

/// @nodoc
abstract mixin class $AnalyticsDataCopyWith<$Res>  {
  factory $AnalyticsDataCopyWith(AnalyticsData value, $Res Function(AnalyticsData) _then) = _$AnalyticsDataCopyWithImpl;
@useResult
$Res call({
 List<TopVariety> topVarieties, List<TopCountry> topCountries, double? averageRating, TasteWeb? tasteWeb
});


$TasteWebCopyWith<$Res>? get tasteWeb;

}
/// @nodoc
class _$AnalyticsDataCopyWithImpl<$Res>
    implements $AnalyticsDataCopyWith<$Res> {
  _$AnalyticsDataCopyWithImpl(this._self, this._then);

  final AnalyticsData _self;
  final $Res Function(AnalyticsData) _then;

/// Create a copy of AnalyticsData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? topVarieties = null,Object? topCountries = null,Object? averageRating = freezed,Object? tasteWeb = freezed,}) {
  return _then(_self.copyWith(
topVarieties: null == topVarieties ? _self.topVarieties : topVarieties // ignore: cast_nullable_to_non_nullable
as List<TopVariety>,topCountries: null == topCountries ? _self.topCountries : topCountries // ignore: cast_nullable_to_non_nullable
as List<TopCountry>,averageRating: freezed == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double?,tasteWeb: freezed == tasteWeb ? _self.tasteWeb : tasteWeb // ignore: cast_nullable_to_non_nullable
as TasteWeb?,
  ));
}
/// Create a copy of AnalyticsData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TasteWebCopyWith<$Res>? get tasteWeb {
    if (_self.tasteWeb == null) {
    return null;
  }

  return $TasteWebCopyWith<$Res>(_self.tasteWeb!, (value) {
    return _then(_self.copyWith(tasteWeb: value));
  });
}
}


/// Adds pattern-matching-related methods to [AnalyticsData].
extension AnalyticsDataPatterns on AnalyticsData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsData value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsData value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TopVariety> topVarieties,  List<TopCountry> topCountries,  double? averageRating,  TasteWeb? tasteWeb)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsData() when $default != null:
return $default(_that.topVarieties,_that.topCountries,_that.averageRating,_that.tasteWeb);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TopVariety> topVarieties,  List<TopCountry> topCountries,  double? averageRating,  TasteWeb? tasteWeb)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsData():
return $default(_that.topVarieties,_that.topCountries,_that.averageRating,_that.tasteWeb);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TopVariety> topVarieties,  List<TopCountry> topCountries,  double? averageRating,  TasteWeb? tasteWeb)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsData() when $default != null:
return $default(_that.topVarieties,_that.topCountries,_that.averageRating,_that.tasteWeb);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsData implements AnalyticsData {
  const _AnalyticsData({required final  List<TopVariety> topVarieties, required final  List<TopCountry> topCountries, required this.averageRating, required this.tasteWeb}): _topVarieties = topVarieties,_topCountries = topCountries;
  factory _AnalyticsData.fromJson(Map<String, dynamic> json) => _$AnalyticsDataFromJson(json);

 final  List<TopVariety> _topVarieties;
@override List<TopVariety> get topVarieties {
  if (_topVarieties is EqualUnmodifiableListView) return _topVarieties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topVarieties);
}

 final  List<TopCountry> _topCountries;
@override List<TopCountry> get topCountries {
  if (_topCountries is EqualUnmodifiableListView) return _topCountries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topCountries);
}

@override final  double? averageRating;
@override final  TasteWeb? tasteWeb;

/// Create a copy of AnalyticsData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsDataCopyWith<_AnalyticsData> get copyWith => __$AnalyticsDataCopyWithImpl<_AnalyticsData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsData&&const DeepCollectionEquality().equals(other._topVarieties, _topVarieties)&&const DeepCollectionEquality().equals(other._topCountries, _topCountries)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.tasteWeb, tasteWeb) || other.tasteWeb == tasteWeb));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_topVarieties),const DeepCollectionEquality().hash(_topCountries),averageRating,tasteWeb);

@override
String toString() {
  return 'AnalyticsData(topVarieties: $topVarieties, topCountries: $topCountries, averageRating: $averageRating, tasteWeb: $tasteWeb)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsDataCopyWith<$Res> implements $AnalyticsDataCopyWith<$Res> {
  factory _$AnalyticsDataCopyWith(_AnalyticsData value, $Res Function(_AnalyticsData) _then) = __$AnalyticsDataCopyWithImpl;
@override @useResult
$Res call({
 List<TopVariety> topVarieties, List<TopCountry> topCountries, double? averageRating, TasteWeb? tasteWeb
});


@override $TasteWebCopyWith<$Res>? get tasteWeb;

}
/// @nodoc
class __$AnalyticsDataCopyWithImpl<$Res>
    implements _$AnalyticsDataCopyWith<$Res> {
  __$AnalyticsDataCopyWithImpl(this._self, this._then);

  final _AnalyticsData _self;
  final $Res Function(_AnalyticsData) _then;

/// Create a copy of AnalyticsData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? topVarieties = null,Object? topCountries = null,Object? averageRating = freezed,Object? tasteWeb = freezed,}) {
  return _then(_AnalyticsData(
topVarieties: null == topVarieties ? _self._topVarieties : topVarieties // ignore: cast_nullable_to_non_nullable
as List<TopVariety>,topCountries: null == topCountries ? _self._topCountries : topCountries // ignore: cast_nullable_to_non_nullable
as List<TopCountry>,averageRating: freezed == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double?,tasteWeb: freezed == tasteWeb ? _self.tasteWeb : tasteWeb // ignore: cast_nullable_to_non_nullable
as TasteWeb?,
  ));
}

/// Create a copy of AnalyticsData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TasteWebCopyWith<$Res>? get tasteWeb {
    if (_self.tasteWeb == null) {
    return null;
  }

  return $TasteWebCopyWith<$Res>(_self.tasteWeb!, (value) {
    return _then(_self.copyWith(tasteWeb: value));
  });
}
}


/// @nodoc
mixin _$TopVariety {

 String? get grapeVariety; int get count;
/// Create a copy of TopVariety
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopVarietyCopyWith<TopVariety> get copyWith => _$TopVarietyCopyWithImpl<TopVariety>(this as TopVariety, _$identity);

  /// Serializes this TopVariety to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopVariety&&(identical(other.grapeVariety, grapeVariety) || other.grapeVariety == grapeVariety)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,grapeVariety,count);

@override
String toString() {
  return 'TopVariety(grapeVariety: $grapeVariety, count: $count)';
}


}

/// @nodoc
abstract mixin class $TopVarietyCopyWith<$Res>  {
  factory $TopVarietyCopyWith(TopVariety value, $Res Function(TopVariety) _then) = _$TopVarietyCopyWithImpl;
@useResult
$Res call({
 String? grapeVariety, int count
});




}
/// @nodoc
class _$TopVarietyCopyWithImpl<$Res>
    implements $TopVarietyCopyWith<$Res> {
  _$TopVarietyCopyWithImpl(this._self, this._then);

  final TopVariety _self;
  final $Res Function(TopVariety) _then;

/// Create a copy of TopVariety
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? grapeVariety = freezed,Object? count = null,}) {
  return _then(_self.copyWith(
grapeVariety: freezed == grapeVariety ? _self.grapeVariety : grapeVariety // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TopVariety].
extension TopVarietyPatterns on TopVariety {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopVariety value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopVariety() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopVariety value)  $default,){
final _that = this;
switch (_that) {
case _TopVariety():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopVariety value)?  $default,){
final _that = this;
switch (_that) {
case _TopVariety() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? grapeVariety,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopVariety() when $default != null:
return $default(_that.grapeVariety,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? grapeVariety,  int count)  $default,) {final _that = this;
switch (_that) {
case _TopVariety():
return $default(_that.grapeVariety,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? grapeVariety,  int count)?  $default,) {final _that = this;
switch (_that) {
case _TopVariety() when $default != null:
return $default(_that.grapeVariety,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TopVariety implements TopVariety {
  const _TopVariety({this.grapeVariety, required this.count});
  factory _TopVariety.fromJson(Map<String, dynamic> json) => _$TopVarietyFromJson(json);

@override final  String? grapeVariety;
@override final  int count;

/// Create a copy of TopVariety
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopVarietyCopyWith<_TopVariety> get copyWith => __$TopVarietyCopyWithImpl<_TopVariety>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopVarietyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopVariety&&(identical(other.grapeVariety, grapeVariety) || other.grapeVariety == grapeVariety)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,grapeVariety,count);

@override
String toString() {
  return 'TopVariety(grapeVariety: $grapeVariety, count: $count)';
}


}

/// @nodoc
abstract mixin class _$TopVarietyCopyWith<$Res> implements $TopVarietyCopyWith<$Res> {
  factory _$TopVarietyCopyWith(_TopVariety value, $Res Function(_TopVariety) _then) = __$TopVarietyCopyWithImpl;
@override @useResult
$Res call({
 String? grapeVariety, int count
});




}
/// @nodoc
class __$TopVarietyCopyWithImpl<$Res>
    implements _$TopVarietyCopyWith<$Res> {
  __$TopVarietyCopyWithImpl(this._self, this._then);

  final _TopVariety _self;
  final $Res Function(_TopVariety) _then;

/// Create a copy of TopVariety
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? grapeVariety = freezed,Object? count = null,}) {
  return _then(_TopVariety(
grapeVariety: freezed == grapeVariety ? _self.grapeVariety : grapeVariety // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TopCountry {

 String? get countryName; int get count;
/// Create a copy of TopCountry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopCountryCopyWith<TopCountry> get copyWith => _$TopCountryCopyWithImpl<TopCountry>(this as TopCountry, _$identity);

  /// Serializes this TopCountry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopCountry&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,countryName,count);

@override
String toString() {
  return 'TopCountry(countryName: $countryName, count: $count)';
}


}

/// @nodoc
abstract mixin class $TopCountryCopyWith<$Res>  {
  factory $TopCountryCopyWith(TopCountry value, $Res Function(TopCountry) _then) = _$TopCountryCopyWithImpl;
@useResult
$Res call({
 String? countryName, int count
});




}
/// @nodoc
class _$TopCountryCopyWithImpl<$Res>
    implements $TopCountryCopyWith<$Res> {
  _$TopCountryCopyWithImpl(this._self, this._then);

  final TopCountry _self;
  final $Res Function(TopCountry) _then;

/// Create a copy of TopCountry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? countryName = freezed,Object? count = null,}) {
  return _then(_self.copyWith(
countryName: freezed == countryName ? _self.countryName : countryName // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TopCountry].
extension TopCountryPatterns on TopCountry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopCountry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopCountry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopCountry value)  $default,){
final _that = this;
switch (_that) {
case _TopCountry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopCountry value)?  $default,){
final _that = this;
switch (_that) {
case _TopCountry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? countryName,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopCountry() when $default != null:
return $default(_that.countryName,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? countryName,  int count)  $default,) {final _that = this;
switch (_that) {
case _TopCountry():
return $default(_that.countryName,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? countryName,  int count)?  $default,) {final _that = this;
switch (_that) {
case _TopCountry() when $default != null:
return $default(_that.countryName,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TopCountry implements TopCountry {
  const _TopCountry({this.countryName, required this.count});
  factory _TopCountry.fromJson(Map<String, dynamic> json) => _$TopCountryFromJson(json);

@override final  String? countryName;
@override final  int count;

/// Create a copy of TopCountry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopCountryCopyWith<_TopCountry> get copyWith => __$TopCountryCopyWithImpl<_TopCountry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopCountryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopCountry&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,countryName,count);

@override
String toString() {
  return 'TopCountry(countryName: $countryName, count: $count)';
}


}

/// @nodoc
abstract mixin class _$TopCountryCopyWith<$Res> implements $TopCountryCopyWith<$Res> {
  factory _$TopCountryCopyWith(_TopCountry value, $Res Function(_TopCountry) _then) = __$TopCountryCopyWithImpl;
@override @useResult
$Res call({
 String? countryName, int count
});




}
/// @nodoc
class __$TopCountryCopyWithImpl<$Res>
    implements _$TopCountryCopyWith<$Res> {
  __$TopCountryCopyWithImpl(this._self, this._then);

  final _TopCountry _self;
  final $Res Function(_TopCountry) _then;

/// Create a copy of TopCountry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? countryName = freezed,Object? count = null,}) {
  return _then(_TopCountry(
countryName: freezed == countryName ? _self.countryName : countryName // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TasteWeb {

 double? get sweetness; double? get acidity; double? get tannins; double? get saturation;
/// Create a copy of TasteWeb
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TasteWebCopyWith<TasteWeb> get copyWith => _$TasteWebCopyWithImpl<TasteWeb>(this as TasteWeb, _$identity);

  /// Serializes this TasteWeb to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TasteWeb&&(identical(other.sweetness, sweetness) || other.sweetness == sweetness)&&(identical(other.acidity, acidity) || other.acidity == acidity)&&(identical(other.tannins, tannins) || other.tannins == tannins)&&(identical(other.saturation, saturation) || other.saturation == saturation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sweetness,acidity,tannins,saturation);

@override
String toString() {
  return 'TasteWeb(sweetness: $sweetness, acidity: $acidity, tannins: $tannins, saturation: $saturation)';
}


}

/// @nodoc
abstract mixin class $TasteWebCopyWith<$Res>  {
  factory $TasteWebCopyWith(TasteWeb value, $Res Function(TasteWeb) _then) = _$TasteWebCopyWithImpl;
@useResult
$Res call({
 double? sweetness, double? acidity, double? tannins, double? saturation
});




}
/// @nodoc
class _$TasteWebCopyWithImpl<$Res>
    implements $TasteWebCopyWith<$Res> {
  _$TasteWebCopyWithImpl(this._self, this._then);

  final TasteWeb _self;
  final $Res Function(TasteWeb) _then;

/// Create a copy of TasteWeb
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sweetness = freezed,Object? acidity = freezed,Object? tannins = freezed,Object? saturation = freezed,}) {
  return _then(_self.copyWith(
sweetness: freezed == sweetness ? _self.sweetness : sweetness // ignore: cast_nullable_to_non_nullable
as double?,acidity: freezed == acidity ? _self.acidity : acidity // ignore: cast_nullable_to_non_nullable
as double?,tannins: freezed == tannins ? _self.tannins : tannins // ignore: cast_nullable_to_non_nullable
as double?,saturation: freezed == saturation ? _self.saturation : saturation // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [TasteWeb].
extension TasteWebPatterns on TasteWeb {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TasteWeb value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TasteWeb() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TasteWeb value)  $default,){
final _that = this;
switch (_that) {
case _TasteWeb():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TasteWeb value)?  $default,){
final _that = this;
switch (_that) {
case _TasteWeb() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? sweetness,  double? acidity,  double? tannins,  double? saturation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TasteWeb() when $default != null:
return $default(_that.sweetness,_that.acidity,_that.tannins,_that.saturation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? sweetness,  double? acidity,  double? tannins,  double? saturation)  $default,) {final _that = this;
switch (_that) {
case _TasteWeb():
return $default(_that.sweetness,_that.acidity,_that.tannins,_that.saturation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? sweetness,  double? acidity,  double? tannins,  double? saturation)?  $default,) {final _that = this;
switch (_that) {
case _TasteWeb() when $default != null:
return $default(_that.sweetness,_that.acidity,_that.tannins,_that.saturation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TasteWeb implements TasteWeb {
  const _TasteWeb({required this.sweetness, required this.acidity, required this.tannins, required this.saturation});
  factory _TasteWeb.fromJson(Map<String, dynamic> json) => _$TasteWebFromJson(json);

@override final  double? sweetness;
@override final  double? acidity;
@override final  double? tannins;
@override final  double? saturation;

/// Create a copy of TasteWeb
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TasteWebCopyWith<_TasteWeb> get copyWith => __$TasteWebCopyWithImpl<_TasteWeb>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TasteWebToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TasteWeb&&(identical(other.sweetness, sweetness) || other.sweetness == sweetness)&&(identical(other.acidity, acidity) || other.acidity == acidity)&&(identical(other.tannins, tannins) || other.tannins == tannins)&&(identical(other.saturation, saturation) || other.saturation == saturation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sweetness,acidity,tannins,saturation);

@override
String toString() {
  return 'TasteWeb(sweetness: $sweetness, acidity: $acidity, tannins: $tannins, saturation: $saturation)';
}


}

/// @nodoc
abstract mixin class _$TasteWebCopyWith<$Res> implements $TasteWebCopyWith<$Res> {
  factory _$TasteWebCopyWith(_TasteWeb value, $Res Function(_TasteWeb) _then) = __$TasteWebCopyWithImpl;
@override @useResult
$Res call({
 double? sweetness, double? acidity, double? tannins, double? saturation
});




}
/// @nodoc
class __$TasteWebCopyWithImpl<$Res>
    implements _$TasteWebCopyWith<$Res> {
  __$TasteWebCopyWithImpl(this._self, this._then);

  final _TasteWeb _self;
  final $Res Function(_TasteWeb) _then;

/// Create a copy of TasteWeb
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sweetness = freezed,Object? acidity = freezed,Object? tannins = freezed,Object? saturation = freezed,}) {
  return _then(_TasteWeb(
sweetness: freezed == sweetness ? _self.sweetness : sweetness // ignore: cast_nullable_to_non_nullable
as double?,acidity: freezed == acidity ? _self.acidity : acidity // ignore: cast_nullable_to_non_nullable
as double?,tannins: freezed == tannins ? _self.tannins : tannins // ignore: cast_nullable_to_non_nullable
as double?,saturation: freezed == saturation ? _self.saturation : saturation // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
