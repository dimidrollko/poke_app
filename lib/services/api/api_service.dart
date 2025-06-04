import 'package:dio/dio.dart';

class APIService {
  static final APIService _instance = APIService._internal();

  factory APIService() => _instance;

  late final Dio _dio;

  static const String _baseUrl = 'https://pokeapi.co/api/v2/';

  APIService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
      ),
    );
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
      ),
    );
  }

  /// Generic GET request
  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParams);
      return fromJson(response.data);
    } on DioException catch (e) {
      // Customize error handling here
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.sendTimeout:
        return 'Send timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.badResponse:
        return 'Received invalid status code: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request to API server was cancelled';
      case DioExceptionType.unknown:
      default:
        return 'Unexpected error: ${error.message}';
    }
  }
}
