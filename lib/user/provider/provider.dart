import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_app/services/firebase_auth/provider.dart';
import 'package:poke_app/user/model/user_profile.dart';

final userProfileStreamProvider = StreamProvider<UserProfile?>((ref) {
  final authState = ref.watch(authStateProvider);

  // If auth state is still loading, return empty stream
  if (authState.isLoading) return const Stream.empty();

  final user = authState.value;
  if (user == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((doc) {
        if (!doc.exists) return null;
        return UserProfile.fromJson(doc.data()!);
      });
});

final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final authState = await ref.watch(authStateProvider.future);
  final user = authState;
  if (user == null) return null;

  final doc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  if (!doc.exists) return null;
  return UserProfile.fromJson(doc.data()!);
});
