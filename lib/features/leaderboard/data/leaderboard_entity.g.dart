// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaderboardEntity _$LeaderboardEntityFromJson(Map<String, dynamic> json) =>
    LeaderboardEntity(
      discoveredCount: (json['discovered_count'] as num).toInt(),
      longestStreak: (json['longest_streak'] as num).toInt(),
      username: json['username'] as String,
    );

Map<String, dynamic> _$LeaderboardEntityToJson(LeaderboardEntity instance) =>
    <String, dynamic>{
      'discovered_count': instance.discoveredCount,
      'longest_streak': instance.longestStreak,
      'username': instance.username,
    };
