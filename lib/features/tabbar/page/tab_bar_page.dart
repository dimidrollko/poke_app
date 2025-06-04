import 'package:flutter/material.dart';
import 'package:poke_app/features/leaderboard/page/leaderboard_page.dart';
import 'package:poke_app/features/pokedex/pages/pokedex_page.dart';

class MainTabbedPage extends StatefulWidget {
  const MainTabbedPage({super.key});

  @override
  State<MainTabbedPage> createState() => _MainTabbedPageState();
}

class _MainTabbedPageState extends State<MainTabbedPage> {
  int _selectedIndex = 0;

  final _pages = const [
    PokemonListPage(),
    LeaderboardPage(),
  ];

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.catching_pokemon),
            label: 'Pokédex',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
        ],
      ),
    );
  }
}
