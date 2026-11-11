import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../main.dart';
import '../widgets/dish_rank_card.dart';
import 'auth_screens.dart';
import 'dish_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({this.onOpenRankings, super.key});

  final VoidCallback? onOpenRankings;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _allCategory = 'All';
  static const _categories = [
    ('🍽️', 'All'),
    ('🍕', 'Pizza'),
    ('🍔', 'Burgers'),
    ('🍛', 'Desi'),
    ('🍰', 'Desserts'),
  ];
  static const _trendingIds = ['pizza-001', 'bbq-001'];

  final _scrollController = ScrollController();
  final _trendingKey = GlobalKey();
  String _selectedCategory = _allCategory;
  String _query = '';

  List<FoodDish> get _filteredDishes {
    final query = _query.trim().toLowerCase();
    final dishes = mockDishes.where((dish) {
      final matchesCategory = switch (_selectedCategory) {
        _allCategory => true,
        'Desi' => dish.category == 'BBQ' || dish.category == 'Shawarma',
        _ => dish.category == _selectedCategory,
      };
      final searchable =
          '${dish.dishName} ${dish.restaurantName} ${dish.branchArea} ${dish.category}'
              .toLowerCase();
      return matchesCategory && (query.isEmpty || searchable.contains(query));
    }).toList()..sort((first, second) => first.rank.compareTo(second.rank));
    return dishes;
  }

  List<FoodDish> get _trendingDishes {
    final dishes =
        mockDishes.where((dish) => _trendingIds.contains(dish.id)).toList()
          ..sort((first, second) => first.rank.compareTo(second.rank));
    return dishes;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: cream,
    body: SafeArea(
      bottom: false,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(child: _buildHero(context)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeading(
                    title: 'Find your flavour',
                    subtitle: 'Browse Islamabad’s favourite food categories',
                  ),
                  const SizedBox(height: 13),
                  SizedBox(
                    height: 48,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 9),
                      itemBuilder: (context, index) {
                        final (emoji, name) = _categories[index];
                        final selected = name == _selectedCategory;
                        return ChoiceChip(
                          key: ValueKey('home-category-$name'),
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(emoji),
                              const SizedBox(width: 6),
                              Text(name),
                            ],
                          ),
                          selected: selected,
                          showCheckmark: false,
                          onSelected: (_) =>
                              setState(() => _selectedCategory = name),
                          selectedColor: orange,
                          backgroundColor: surface,
                          side: BorderSide(
                            color: selected ? gold : line,
                            width: selected ? 1.3 : 1,
                          ),
                          labelStyle: TextStyle(
                            color: selected ? cream : ink,
                            fontWeight: FontWeight.w800,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    onChanged: (value) => setState(() => _query = value),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Search dishes or restaurants',
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: muted,
                      ),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () => setState(() => _query = ''),
                              tooltip: 'Clear search',
                              icon: const Icon(Icons.close_rounded),
                            ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 9,
                    runSpacing: 8,
                    children: const [
                      _LocationPill(
                        icon: Icons.local_pizza_rounded,
                        label: 'Cheezious · Old F-7',
                      ),
                      _LocationPill(
                        icon: Icons.location_on_rounded,
                        label: 'Kababjees · F-8 Markaz',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            key: _trendingKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 28),
              child: _buildTrendingSection(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 29, 20, 13),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedCategory == _allCategory
                              ? 'Top dishes in town'
                              : '$_selectedCategory in Islamabad',
                          style: const TextStyle(
                            color: ink,
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Rated by local food lovers',
                          style: TextStyle(color: muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onOpenRankings,
                    child: const Text(
                      'Rankings',
                      style: TextStyle(
                        color: gold,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_filteredDishes.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  'No dishes found. Try a different search.',
                  style: TextStyle(color: muted),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.crossAxisExtent > 720 ? 2 : 1;
                  if (columns == 1) {
                    return SliverList.builder(
                      itemCount: _filteredDishes.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: DishRankCard(
                          dish: _filteredDishes[index],
                          rank: _filteredDishes[index].rank,
                          heroTag: 'home-${_filteredDishes[index].id}',
                        ),
                      ),
                    );
                  }
                  return SliverGrid.builder(
                    itemCount: _filteredDishes.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          mainAxisExtent: 118,
                        ),
                    itemBuilder: (context, index) => DishRankCard(
                      dish: _filteredDishes[index],
                      rank: _filteredDishes[index].rank,
                      heroTag: 'home-${_filteredDishes[index].id}',
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    ),
  );

  Widget _buildHero(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final wide = constraints.maxWidth >= 760;
      final height = wide
          ? (MediaQuery.sizeOf(context).height * .59)
                .clamp(410.0, 590.0)
                .toDouble()
          : null;
      final copy = _HeroCopy(
        compact: !wide,
        onGetStarted: _scrollToTrending,
        onLogIn: () => _openScreen(const LoginScreen()),
        onSignUp: () => _openScreen(const RegisterScreen()),
      );
      final collage = _FoodCollage(height: wide ? height : 225);
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: wide
              ? SizedBox(
                  height: height,
                  child: Row(
                    children: [
                      Expanded(flex: 5, child: copy),
                      Expanded(flex: 4, child: collage),
                    ],
                  ),
                )
              : Column(children: [copy, collage]),
        ),
      );
    },
  );

  Widget _buildTrendingSection() {
    final dishes = _trendingDishes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          child: _SectionHeading(
            title: 'Trending Right Now',
            subtitle: 'The dishes Islamabad is talking about',
          ),
        ),
        if (dishes.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Trending dishes will appear here soon.',
              style: TextStyle(color: muted),
            ),
          )
        else
          SizedBox(
            height: 304,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: dishes.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) => _TrendingDishCard(
                dish: dishes[index],
                heroTag: 'trending-${dishes[index].id}',
              ),
            ),
          ),
      ],
    );
  }

  void _scrollToTrending() {
    final targetContext = _trendingKey.currentContext;
    if (targetContext == null) return;
    Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
      alignment: .04,
    );
  }

  void _openScreen(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({
    required this.compact,
    required this.onGetStarted,
    required this.onLogIn,
    required this.onSignUp,
  });

  final bool compact;
  final VoidCallback onGetStarted;
  final VoidCallback onLogIn;
  final VoidCallback onSignUp;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(
      horizontal: compact ? 22 : 36,
      vertical: compact ? 28 : 38,
    ),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2B2414), Color(0xFF121418)],
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: gold,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40FFB03A),
                blurRadius: 16,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: const Text(
            'FOODRANK ISLAMABAD',
            style: TextStyle(
              color: Color(0xFF211A0D),
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ),
        SizedBox(height: compact ? 21 : 29),
        Text.rich(
          TextSpan(
            style: TextStyle(
              color: const Color(0xFFFFF6E8),
              fontSize: compact ? 31 : 39,
              height: 1.17,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              letterSpacing: -.8,
            ),
            children: const [
              TextSpan(text: 'Craving Pizza? Find the '),
              TextSpan(
                text: '#1 Rated Slice Near You.',
                style: TextStyle(color: gold),
              ),
            ],
          ),
        ),
        SizedBox(height: compact ? 21 : 28),
        SizedBox(
          height: 54,
          child: FilledButton(
            onPressed: onGetStarted,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFFF8ED),
              foregroundColor: const Color(0xFF6D5035),
              shape: const StadiumBorder(),
              elevation: 3,
              textStyle: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
              ),
            ),
            child: const Text('Get Started!'),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onLogIn,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFFF8ED),
                  side: const BorderSide(color: gold),
                  shape: const StadiumBorder(),
                ),
                child: const Text('Log In'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: onSignUp,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFFF8ED),
                  side: const BorderSide(color: gold),
                  shape: const StadiumBorder(),
                ),
                child: const Text('Sign Up'),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _FoodCollage extends StatelessWidget {
  const _FoodCollage({required this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    final pizza = mockDishes.where((dish) => dish.id == 'pizza-001');
    final bbq = mockDishes.where((dish) => dish.id == 'bbq-001');
    final dessert = mockDishes.where((dish) => dish.id == 'dessert-001');
    final pizzaUrl = pizza.isEmpty ? '' : pizza.first.imageUrl;
    final bbqUrl = bbq.isEmpty ? '' : bbq.first.imageUrl;
    final dessertUrl = dessert.isEmpty ? '' : dessert.first.imageUrl;
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _CollageImage(url: pizzaUrl),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0x44121418), Color(0x14121418)],
              ),
            ),
          ),
          Positioned(
            right: 14,
            top: 16,
            child: _PhotoTile(url: bbqUrl, width: 120, height: 105),
          ),
          Positioned(
            left: 18,
            bottom: 17,
            child: _PhotoTile(url: dessertUrl, width: 128, height: 96),
          ),
          Positioned(
            right: 16,
            bottom: 19,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xCC121418),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: gold),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on_rounded, color: gold, size: 15),
                  SizedBox(width: 4),
                  Text(
                    'ISLAMABAD',
                    style: TextStyle(
                      color: ink,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({
    required this.url,
    required this.width,
    required this.height,
  });

  final String url;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) => Transform.rotate(
    angle: -.045,
    child: Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xCCFFF8ED),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x77000000),
            blurRadius: 15,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: _CollageImage(url: url),
      ),
    ),
  );
}

class _CollageImage extends StatelessWidget {
  const _CollageImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) => url.isEmpty
      ? const ColoredBox(color: surface)
      : Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const ColoredBox(color: surface),
        );
}

class _TrendingDishCard extends StatelessWidget {
  const _TrendingDishCard({required this.dish, required this.heroTag});

  final FoodDish dish;
  final String heroTag;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 304,
    child: Material(
      color: surface,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => DishDetailScreen(dish: dish, heroTag: heroTag),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: heroTag,
                    child: Image.network(
                      dish.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const ColoredBox(color: surface),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x44121418), Color(0x00121418)],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: gold,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Text(
                        '#${dish.rank}',
                        style: const TextStyle(
                          color: Color(0xFF211A0D),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xDD121418),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded, color: gold, size: 16),
                          const SizedBox(width: 3),
                          Text(
                            dish.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: ink,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 11, 14, 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dish.dishName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ink,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: cyan,
                        size: 15,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          dish.id == 'pizza-001'
                              ? '${dish.restaurantName} · Old F-7'
                              : '${dish.restaurantName} · ${dish.branchArea}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: ink,
          fontSize: 21,
          fontWeight: FontWeight.w900,
          letterSpacing: -.3,
        ),
      ),
      const SizedBox(height: 3),
      Text(subtitle, style: const TextStyle(color: muted, fontSize: 12)),
    ],
  );
}

class _LocationPill extends StatelessWidget {
  const _LocationPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
    decoration: BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: line),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: gold),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: ink,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
