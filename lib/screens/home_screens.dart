import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../main.dart';
import '../widgets/common_widgets.dart';
import '../widgets/dish_rank_card.dart';
import 'discovery_screens.dart';
import 'home_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(
      index: _index,
      children: [
        HomeScreen(onOpenRankings: () => setState(() => _index = 1)),
        const LeaderboardScreen(),
        const SearchScreen(),
        const ProfileScreen(),
      ],
    ),
    bottomNavigationBar: NavigationBarTheme(
      data: NavigationBarThemeData(
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected) ? gold : muted,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected) ? gold : muted,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w500,
          ),
        ),
      ),
      child: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        backgroundColor: surface,
        indicatorColor: const Color(0x66FF6B35),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard_outlined),
            selectedIcon: Icon(Icons.leaderboard_rounded),
            label: 'Rank',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    ),
  );
}

class LegacyHomeScreen extends StatelessWidget {
  const LegacyHomeScreen({
    required this.onOpenRankings,
    required this.onOpenSearch,
    super.key,
  });

  final VoidCallback onOpenRankings;
  final VoidCallback onOpenSearch;

  void _openCategories(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute<void>(builder: (_) => const CategoriesScreen()),
  );

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final horizontal = constraints.maxWidth > 680 ? 32.0 : 20.0;
      return CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(horizontal, 12, horizontal, 0),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.restaurant_menu_rounded,
                      color: gold,
                    ),
                  ),
                  const SizedBox(width: 11),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FoodRank',
                        style: TextStyle(
                          color: surface,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'ISLAMABAD',
                        style: TextStyle(
                          color: muted,
                          fontSize: 9,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton.filledTonal(
                    onPressed: onOpenSearch,
                    icon: const Icon(Icons.search_rounded),
                    tooltip: 'Search dishes',
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(horizontal, 22, horizontal, 0),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(23),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(27),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .08),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'YOUR CITY, SERVED UP',
                        style: TextStyle(
                          color: gold,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                          letterSpacing: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 17),
                    const Text(
                      'Find your\nnext favourite.',
                      style: TextStyle(
                        color: ink,
                        fontWeight: FontWeight.w900,
                        fontSize: 31,
                        letterSpacing: -.7,
                        height: 1.12,
                      ),
                    ),
                    const SizedBox(height: 9),
                    const Text(
                      'Honest ratings for the dishes Islamabad loves.',
                      style: TextStyle(color: muted, fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: () => _openCategories(context),
                      icon: const Icon(Icons.explore_outlined, size: 18),
                      label: const Text('Explore dishes'),
                      style: FilledButton.styleFrom(
                        backgroundColor: orange,
                        foregroundColor: cream,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(horizontal, 20, horizontal, 0),
            sliver: SliverToBoxAdapter(
              child: SectionHeading(
                'Browse categories',
                action: 'See all',
                onTap: () => _openCategories(context),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(horizontal, 4, horizontal, 0),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 47,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: foodDishCategories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 9),
                  itemBuilder: (context, index) {
                    final category = foodDishCategories[index];
                    return ActionChip(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => LeaderboardScreen(category: category),
                        ),
                      ),
                      backgroundColor: surface,
                      side: const BorderSide(color: line),
                      label: Text(category),
                      labelStyle: const TextStyle(
                        color: ink,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(horizontal, 19, horizontal, 0),
            sliver: SliverToBoxAdapter(
              child: SectionHeading(
                'Top-rated dishes',
                action: 'Rankings',
                onTap: onOpenRankings,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(horizontal, 4, horizontal, 20),
            sliver: SliverList.builder(
              itemCount: mockDishes.length < 4 ? mockDishes.length : 4,
              itemBuilder: (context, index) => DishRankCard(
                dish: mockDishes[index],
                rank: mockDishes[index].rank,
                heroTag: 'legacy-home-${mockDishes[index].id}',
              ),
            ),
          ),
        ],
      );
    },
  );
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _search = TextEditingController();
  String _category = 'All';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _search.text.trim().toLowerCase();
    final matches = mockDishes.where((dish) {
      final matchesText =
          '${dish.dishName} ${dish.restaurantName} ${dish.category} ${dish.branchArea}'
              .toLowerCase()
              .contains(query);
      return matchesText && (_category == 'All' || dish.category == _category);
    }).toList()..sort((first, second) => first.rank.compareTo(second.rank));
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 17, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Search',
                  style: TextStyle(
                    color: ink,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Dish, restaurant or category',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _search.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.close_rounded),
                            tooltip: 'Clear search',
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 43,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: ['All', ...foodDishCategories].map((category) {
                      final selected = _category == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: selected,
                          onSelected: (_) =>
                              setState(() => _category = category),
                          selectedColor: orange,
                          backgroundColor: surface,
                          labelStyle: TextStyle(
                            color: selected ? cream : ink,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: matches.isEmpty
                ? const Center(
                    child: Text(
                      'No dishes found. Try another search.',
                      style: TextStyle(color: muted),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    itemCount: matches.length,
                    itemBuilder: (_, index) => DishRankCard(
                      dish: matches[index],
                      rank: matches[index].rank,
                      heroTag: 'search-${matches[index].id}',
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const Text(
              'Profile',
              style: TextStyle(
                color: ink,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 23),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(23),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 31,
                    backgroundColor: gold,
                    child: Icon(Icons.person_rounded, color: cream, size: 34),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Food lover',
                        style: TextStyle(
                          color: ink,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Islamabad, Pakistan',
                        style: TextStyle(color: muted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your foodie journey',
              style: TextStyle(
                color: ink,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 11),
            _ProfileTile(
              icon: Icons.star_outline_rounded,
              title: 'Your ratings',
              subtitle: 'Dishes you have rated',
              onTap: () => _showInfo(
                context,
                'Your ratings',
                'Your dish ratings will show here.',
              ),
            ),
            _ProfileTile(
              icon: Icons.favorite_border_rounded,
              title: 'Saved dishes',
              subtitle: 'Keep your favourites close',
              onTap: () => _showInfo(
                context,
                'Saved dishes',
                'You have not saved any dishes yet.',
              ),
            ),
            _ProfileTile(
              icon: Icons.location_on_outlined,
              title: 'Your city',
              subtitle: 'Islamabad',
              onTap: () =>
                  _showInfo(context, 'Your city', 'Islamabad, Pakistan'),
            ),
            const SizedBox(height: 14),
            const Center(
              child: Text(
                'FoodRank Islamabad · Discover your next favourite',
                textAlign: TextAlign.center,
                style: TextStyle(color: muted, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showInfo(BuildContext context, String title, String message) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Done'),
        ),
      ],
    ),
  );
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    color: surface,
    elevation: 0,
    margin: const EdgeInsets.only(bottom: 9),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(17),
      side: const BorderSide(color: line),
    ),
    child: ListTile(
      onTap: onTap,
      leading: Icon(icon, color: ink),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded, color: muted),
    ),
  );
}
