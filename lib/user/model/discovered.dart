import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'discovered.g.dart';

@JsonSerializable()
class Discovered {
  final int id;
  final double duration;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final Timestamp timestamp;
  Discovered({
    required this.id,
    required this.duration,
    required this.timestamp,
  });

  factory Discovered.fromJson(Map<String, dynamic> json) =>
      _$DiscoveredFromJson(json);

  static Timestamp _timestampFromJson(dynamic json) =>
      json is Timestamp
          ? json
          : Timestamp.fromMillisecondsSinceEpoch(json.millisecondsSinceEpoch);

  static dynamic _timestampToJson(Timestamp timestamp) => timestamp;
}
