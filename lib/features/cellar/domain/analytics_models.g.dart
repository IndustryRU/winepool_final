// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnalyticsData _$AnalyticsDataFromJson(Map<String, dynamic> json) =>
    _AnalyticsData(
      topVarieties: (json['topVarieties'] as List<dynamic>)
          .map((e) => TopVariety.fromJson(e as Map<String, dynamic>))
          .toList(),
      topCountries: (json['topCountries'] as List<dynamic>)
          .map((e) => TopCountry.fromJson(e as Map<String, dynamic>))
          .toList(),
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      tasteWeb: json['tasteWeb'] == null
          ? null
          : TasteWeb.fromJson(json['tasteWeb'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AnalyticsDataToJson(_AnalyticsData instance) =>
    <String, dynamic>{
      'topVarieties': instance.topVarieties,
      'topCountries': instance.topCountries,
      'averageRating': instance.averageRating,
      'tasteWeb': instance.tasteWeb,
    };

_TopVariety _$TopVarietyFromJson(Map<String, dynamic> json) => _TopVariety(
  grapeVariety: json['grapeVariety'] as String?,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$TopVarietyToJson(_TopVariety instance) =>
    <String, dynamic>{
      'grapeVariety': instance.grapeVariety,
      'count': instance.count,
    };

_TopCountry _$TopCountryFromJson(Map<String, dynamic> json) => _TopCountry(
  countryName: json['countryName'] as String?,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$TopCountryToJson(_TopCountry instance) =>
    <String, dynamic>{
      'countryName': instance.countryName,
      'count': instance.count,
    };

_TasteWeb _$TasteWebFromJson(Map<String, dynamic> json) => _TasteWeb(
  sweetness: (json['sweetness'] as num?)?.toDouble(),
  acidity: (json['acidity'] as num?)?.toDouble(),
  tannins: (json['tannins'] as num?)?.toDouble(),
  saturation: (json['saturation'] as num?)?.toDouble(),
);

Map<String, dynamic> _$TasteWebToJson(_TasteWeb instance) => <String, dynamic>{
  'sweetness': instance.sweetness,
  'acidity': instance.acidity,
  'tannins': instance.tannins,
  'saturation': instance.saturation,
};
