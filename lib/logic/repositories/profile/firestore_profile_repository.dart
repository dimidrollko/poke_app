import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poke_app/logic/repositories/profile/iprofile_repository.dart';
import 'package:poke_app/logic/repositories/profile/profile_raw_model.dart';

class FirestoreProfileRepository implements IProfileRepository {
  @override
  Future<ProfileRawModel?> getProfile(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      return doc.data() as ProfileRawModel;
    }
    return null;
  }
}
