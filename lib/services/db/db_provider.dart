import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_app/services/db/db_service.dart';

final dbServiceProvider = Provider<DbService>((ref) => DbService());
