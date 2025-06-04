import 'package:json_annotation/json_annotation.dart';

part 'api_list_response.g.dart';

T Function(Map<String, dynamic>) fromApiList<T>(
  T Function(Object? json) fromItemJson,
) {
  return (json) => ApiListResponse<T>.fromJson(json, fromItemJson) as T;
}

@JsonSerializable(genericArgumentFactories: true)
class ApiListResponse<T> {
  final int count;
  final List<T> results;

  ApiListResponse({required this.count, required this.results});

  factory ApiListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiListResponseFromJson(json, fromJsonT);
}
