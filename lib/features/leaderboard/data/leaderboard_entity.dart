import 'package:json_annotation/json_annotation.dart';
part 'leaderboard_entity.g.dart';

@JsonSerializable()
class LeaderboardEntity {
  @JsonKey(name: 'discovered_count')
  final int discoveredCount;
  @JsonKey(name: 'longest_streak')
  final int longestStreak;
  final String username;
  @JsonKey(includeFromJson: false)
  late String userId;

  LeaderboardEntity({
    required this.discoveredCount,
    required this.longestStreak,
    required this.username,
  });

  factory LeaderboardEntity.fromJson(Map<String, dynamic> json, String docId) =>
      _$LeaderboardEntityFromJson(json)..userId = docId;

}
