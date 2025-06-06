import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_app/features/leaderboard/provider/leaderboard_provider.dart';

class LeaderboardPage extends ConsumerWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: leaderboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) {
          return Column(
            children: [
              // Pinned header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Row(
                  children: const [
                    SizedBox(
                      width: 40,
                      child: Text('#', style: TextStyle(fontSize: 12)),
                    ),
                    Expanded(
                      child: Text('Name', style: TextStyle(fontSize: 12)),
                    ),
                    Spacer(),
                    SizedBox(
                      width: 80,
                      child: Text('Streak', style: TextStyle(fontSize: 12)),
                    ),
                    SizedBox(
                      width: 80,
                      child: Text('Total', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final entry = list[index];
                    final place = index + 1;

                    return Card(
                      margin: EdgeInsets.zero,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 40, child: Text('$place')),
                            Expanded(child: Text(entry.username)),
                            SizedBox(
                              width: 60,
                              child: Text('${entry.longestStreak}'),
                            ),
                            SizedBox(
                              width: 60,
                              child: Text('${entry.discoveredCount}'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
