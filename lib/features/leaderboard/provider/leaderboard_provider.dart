import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_app/features/leaderboard/data/leaderboard_entity.dart';

final leaderboardProvider = FutureProvider<List<LeaderboardEntity>>((
  ref,
) async {
  final snapshot =
      await FirebaseFirestore.instance
          .collection('leaderboard_summary')
          .orderBy('discovered_count', descending: true)
          .get();
          
  print('Fetched ${snapshot.docs.length} docs');

  return snapshot.docs.map((doc) {
    print(doc.data());
    return LeaderboardEntity.fromJson(doc.data(), doc.id);
  }).toList();
});
