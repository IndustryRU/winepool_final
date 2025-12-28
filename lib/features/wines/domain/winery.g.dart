// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'winery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Winery _$WineryFromJson(Map<String, dynamic> json) => _Winery(
  id: json['id'] as String?,
  name: json['name'] as String?,
  description: json['description'] as String?,
  logoUrl: json['logo_url'] as String?,
  bannerUrl: json['banner_url'] as String?,
  winemaker: json['winemaker'] as String?,
  website: json['website'] as String?,
  locationText: json['location_text'] as String?,
  regionId: json['region_id'] as String?,
  countryCode: json['country_code'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  foundedYear: (json['founded_year'] as num?)?.toInt(),
  isPartner: json['is_partner'] as bool?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  isDeleted: _isDeletedFromJson(json['is_deleted']),
  country: _countryFromJson(json['country']),
  regionObject: _regionFromJson(json['region']),
);

Map<String, dynamic> _$WineryToJson(_Winery instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'logo_url': instance.logoUrl,
  'banner_url': instance.bannerUrl,
  'winemaker': instance.winemaker,
  'website': instance.website,
  'location_text': instance.locationText,
  'region_id': instance.regionId,
  'country_code': instance.countryCode,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'founded_year': instance.foundedYear,
  'is_partner': instance.isPartner,
  'phone': instance.phone,
  'email': instance.email,
  'is_deleted': instance.isDeleted,
  'country': instance.country,
  'region': instance.regionObject,
};
