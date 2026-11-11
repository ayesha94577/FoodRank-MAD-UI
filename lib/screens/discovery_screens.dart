import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../main.dart';
import '../models/dish.dart';
import '../widgets/common_widgets.dart';
import '../widgets/dish_rank_card.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  static const _icons = <String, IconData>{
    'Burgers': Icons.lunch_dining_rounded,
    'Desserts': Icons.cake_rounded,
    'Pizza': Icons.local_pizza_rounded,
    'BBQ': Icons.outdoor_grill_rounded,
    'Pasta': Icons.dinner_dining_rounded,
    'Shawarma': Icons.lunch_dining_rounded,
    'Fried Chicken': Icons.set_meal_rounded,
  };

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const BackHeader(title: 'Food categories'),
    body: LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 700 ? 4 : 2;
        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.17,
          ),
          itemCount: foodDishCategories.length,
          itemBuilder: (context, index) {
            final category = foodDishCategories[index];
            final dishes = mockDishes
                .where((dish) => dish.category == category)
                .length;
            return InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => LeaderboardScreen(category: category),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFF30271F),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        _icons[category] ?? Icons.restaurant,
                        color: ink,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category,
                          style: const TextStyle(
                            color: ink,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '$dishes ${dishes == 1 ? 'dish' : 'dishes'} to explore',
                          style: const TextStyle(color: muted, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ),
  );
}

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({this.category, super.key});

  final String? category;

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late String _category = widget.category ?? 'All';

  @override
  Widget build(BuildContext context) {
    final dishes =
        mockDishes
            .where((dish) => _category == 'All' || dish.category == _category)
            .toList()
          ..sort((a, b) => a.rank.compareTo(b.rank));
    return Material(
      color: cream,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.category == null)
                    const Text(
                      'The leaderboard',
                      style: TextStyle(
                        color: ink,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    )
                  else
                    Row(
                      children: [
                        IconButton.filled(
                          onPressed: () => Navigator.maybePop(context),
                          tooltip: 'Back to categories',
                          style: IconButton.styleFrom(
                            backgroundColor: surface,
                            foregroundColor: gold,
                            side: const BorderSide(color: Color(0x66FFB03A)),
                          ),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                        const Text(
                          'Food rankings',
                          style: TextStyle(
                            color: ink,
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 5),
                  const Text(
                    'Islamabad’s most-loved dishes, ranked.',
                    style: TextStyle(color: muted),
                  ),
                  const SizedBox(height: 13),
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
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 11, 20, 16),
                itemCount: dishes.length,
                itemBuilder: (_, index) => DishRankCard(
                  dish: dishes[index],
                  rank: dishes[index].rank,
                  heroTag: 'leaderboard-${dishes[index].id}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DishDetailsScreen extends StatefulWidget {
  const DishDetailsScreen({required this.dish, super.key});

  final Dish dish;

  @override
  State<DishDetailsScreen> createState() => _DishDetailsScreenState();
}

class _DishDetailsScreenState extends State<DishDetailsScreen> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 295,
          pinned: true,
          backgroundColor: cream,
          foregroundColor: cyan,
          leading: Padding(
            padding: const EdgeInsets.all(7),
            child: IconButton.filled(
              onPressed: () => Navigator.maybePop(context),
              tooltip: 'Back',
              style: IconButton.styleFrom(
                backgroundColor: surface,
                foregroundColor: cyan,
                side: const BorderSide(color: Color(0x6622D3EE)),
              ),
              icon: const Icon(Icons.arrow_back_rounded, size: 21),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: FoodImage(url: widget.dish.imageUrl),
            titlePadding: const EdgeInsetsDirectional.only(
              start: 72,
              bottom: 17,
            ),
            title: Text(
              widget.dish.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: ink,
                fontWeight: FontWeight.w800,
                fontSize: 16,
                shadows: [
                  Shadow(color: Colors.black87, blurRadius: 10),
                  Shadow(color: Colors.black87, blurRadius: 10),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.dish.name,
                        style: const TextStyle(
                          color: ink,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -.7,
                        ),
                      ),
                    ),
                    RatingPill(widget.dish.rating),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${widget.dish.restaurant} · ${widget.dish.area}',
                  style: const TextStyle(color: muted, fontSize: 15),
                ),
                const SizedBox(height: 17),
                Wrap(
                  spacing: 9,
                  runSpacing: 9,
                  children: [
                    _DetailPill(
                      icon: Icons.payments_outlined,
                      label: 'PKR ${widget.dish.price}',
                    ),
                    _DetailPill(
                      icon: Icons.restaurant_menu,
                      label: widget.dish.category,
                    ),
                    _DetailPill(
                      icon: Icons.star_outline_rounded,
                      label: '${widget.dish.votes} ratings',
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                const Text(
                  'About this dish',
                  style: TextStyle(
                    color: ink,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  widget.dish.description,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 15,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 27),
                PrimaryButton(
                  label: 'Rate this dish',
                  icon: Icons.star_rounded,
                  onPressed: () =>
                      Navigator.push(
                        context,
                        MaterialPageRoute<bool>(
                          builder: (_) => RateDishScreen(dish: widget.dish),
                        ),
                      ).then((rated) {
                        if (rated == true && mounted) setState(() {});
                      }),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() => _saved = !_saved);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _saved
                                ? '${widget.dish.name} saved on this screen.'
                                : '${widget.dish.name} removed from saved dishes.',
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      _saved
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                    ),
                    label: Text(_saved ? 'Saved' : 'Save dish'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: ink,
                      minimumSize: const Size.fromHeight(50),
                      side: const BorderSide(color: line),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
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

class RateDishScreen extends StatefulWidget {
  const RateDishScreen({required this.dish, super.key});

  final Dish dish;

  @override
  State<RateDishScreen> createState() => _RateDishScreenState();
}

class _RateDishScreenState extends State<RateDishScreen> {
  int _rating = 0;
  final _review = TextEditingController();

  @override
  void dispose() {
    _review.dispose();
    super.dispose();
  }

  void _submit() {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose a star rating first.')),
      );
      return;
    }
    final dish = widget.dish;
    dish.rating = ((dish.rating * dish.votes + _rating) / (dish.votes + 1));
    dish.votes++;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thanks! Your rating has been added.')),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const BackHeader(title: 'Rate this dish'),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(21),
                  child: FoodImage(
                    url: widget.dish.imageUrl,
                    height: 205,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(height: 17),
                Text(
                  widget.dish.name,
                  style: const TextStyle(
                    color: ink,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  widget.dish.restaurant,
                  style: const TextStyle(color: muted),
                ),
                const SizedBox(height: 29),
                const Center(
                  child: Text(
                    'How was your experience?',
                    style: TextStyle(
                      color: ink,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => IconButton(
                      onPressed: () => setState(() => _rating = index + 1),
                      iconSize: 42,
                      tooltip: '${index + 1} stars',
                      icon: Icon(
                        index < _rating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: gold,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    _rating == 0
                        ? 'Tap a star to rate'
                        : [
                            '',
                            'Not for me',
                            'Could be better',
                            'It was good',
                            'Really enjoyed it',
                            'Absolutely loved it!',
                          ][_rating],
                    style: const TextStyle(color: muted),
                  ),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: _review,
                  maxLines: 4,
                  maxLength: 250,
                  decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    labelText: 'Add a note (optional)',
                    hintText: 'What did you love about it?',
                  ),
                ),
                const SizedBox(height: 14),
                PrimaryButton(
                  label: 'Submit rating',
                  icon: Icons.check_rounded,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _DetailPill extends StatelessWidget {
  const _DetailPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: line),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: gold, size: 17),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: ink,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
