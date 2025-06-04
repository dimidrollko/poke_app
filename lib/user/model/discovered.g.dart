// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovered.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Discovered _$DiscoveredFromJson(Map<String, dynamic> json) => Discovered(
  id: (json['id'] as num).toInt(),
  duration: (json['duration'] as num).toDouble(),
  timestamp: Discovered._timestampFromJson(json['timestamp']),
);

Map<String, dynamic> _$DiscoveredToJson(Discovered instance) =>
    <String, dynamic>{
      'id': instance.id,
      'duration': instance.duration,
      'timestamp': Discovered._timestampToJson(instance.timestamp),
    };
