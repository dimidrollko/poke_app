import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_app/services/api/api_service.dart';

final apiServiceProvider = Provider<APIService>((ref) => APIService());
