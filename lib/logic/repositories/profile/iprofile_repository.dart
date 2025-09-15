import 'package:poke_app/logic/repositories/profile/profile_raw_model.dart';

abstract class IProfileRepository {
  Future<ProfileRawModel?> getProfile(String uid);
}
