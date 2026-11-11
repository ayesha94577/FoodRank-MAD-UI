import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/mock_data.dart';
import '../main.dart';

class DishDetailScreen extends StatefulWidget {
  const DishDetailScreen({required this.dish, this.heroTag, super.key});

  final FoodDish dish;
  final String? heroTag;

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  int _selectedRating = 0;
  bool _reviewSubmitted = false;

  FoodDish get dish => widget.dish;

  Future<void> _openLink(String url, String failureMessage) async {
    final opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(failureMessage)));
    }
  }

  void _submitRating() {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose a star rating first.')),
      );
      return;
    }
    setState(() {
      dish.rating =
          ((dish.rating * dish.ratingCount) + _selectedRating) /
          (dish.ratingCount + 1);
      dish.ratingCount++;
      _reviewSubmitted = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thanks! Your rating has been added.')),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: cream,
    body: CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 320,
          pinned: true,
          backgroundColor: cream,
          foregroundColor: cyan,
          leading: Padding(
            padding: const EdgeInsets.all(7),
            child: CircleAvatar(
              backgroundColor: surface,
              child: IconButton(
                onPressed: () => Navigator.maybePop(context),
                tooltip: 'Back',
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: cyan,
                  size: 23,
                ),
              ),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Hero(
              tag: widget.heroTag ?? 'dish-${dish.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(28),
                ),
                child: Image.network(
                  dish.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: surface,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.restaurant_rounded,
                      size: 52,
                      color: muted,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Transform.translate(
            offset: const Offset(0, -26),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: line),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x55000000),
                    blurRadius: 22,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: gold,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      '#${dish.rank}  Top Rated ${dish.category} in Islamabad',
                      style: const TextStyle(
                        color: cream,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    dish.dishName,
                    style: const TextStyle(
                      color: ink,
                      fontSize: 25,
                      height: 1.15,
                      letterSpacing: -.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: Color(0xFF34D399),
                        size: 19,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${dish.restaurantName} — ${dish.branchArea}',
                          style: const TextStyle(
                            color: muted,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final price = Text(
                        'Rs. ${_formatPrice(dish.price)}',
                        style: const TextStyle(
                          color: gold,
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      );
                      final rating = _InfoPill(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: gold,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dish.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: ink,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      );
                      if (constraints.maxWidth < 290) {
                        return Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          runSpacing: 8,
                          children: [price, rating],
                        );
                      }
                      return Row(children: [price, const Spacer(), rating]);
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    dish.description,
                    style: const TextStyle(
                      color: muted,
                      height: 1.5,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 21),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final mapButton = _ActionButton(
                        icon: Icons.map_outlined,
                        label: 'Open in Google Maps',
                        background: cyan,
                        foreground: cream,
                        onPressed: () => _openLink(
                          dish.googleMapsUrl,
                          'Could not open Google Maps.',
                        ),
                      );
                      final websiteButton = _ActionButton(
                        icon: Icons.language_rounded,
                        label: 'Visit Official Website',
                        background: surface,
                        foreground: gold,
                        outlined: true,
                        onPressed: () => _openLink(
                          dish.officialWebsite,
                          'Could not open the restaurant website.',
                        ),
                      );
                      if (constraints.maxWidth < 520) {
                        return Column(
                          children: [
                            mapButton,
                            const SizedBox(height: 10),
                            websiteButton,
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(child: mapButton),
                          const SizedBox(width: 10),
                          Expanded(child: websiteButton),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                  const Divider(height: 1, color: line),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Rate This Dish',
                      style: TextStyle(
                        color: ink,
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      _reviewSubmitted
                          ? 'Thanks for sharing your rating.'
                          : 'Tap a star to share your experience.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: muted, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 9),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => IconButton(
                        onPressed: _reviewSubmitted
                            ? null
                            : () => setState(() => _selectedRating = index + 1),
                        tooltip: '${index + 1} stars',
                        iconSize: 37,
                        constraints: const BoxConstraints.tightFor(
                          width: 40,
                          height: 44,
                        ),
                        visualDensity: VisualDensity.compact,
                        icon: Icon(
                          index < _selectedRating
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: gold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _reviewSubmitted ? null : _submitRating,
                      style: FilledButton.styleFrom(
                        backgroundColor: orange,
                        foregroundColor: cream,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        _reviewSubmitted
                            ? 'Thanks for your rating!'
                            : 'Submit rating',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 4)),
      ],
    ),
  );
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(
      color: const Color(0xFF292D35),
      borderRadius: BorderRadius.circular(14),
    ),
    child: child,
  );
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onPressed,
    this.outlined = false,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onPressed;
  final bool outlined;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 49,
    child: outlined
        ? OutlinedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: 19),
            label: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: foreground,
              side: BorderSide(color: foreground),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          )
        : FilledButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: 19),
            label: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: background,
              foregroundColor: foreground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
  );
}

String _formatPrice(int price) {
  final digits = price.toString();
  final output = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) output.write(',');
    output.write(digits[index]);
  }
  return output.toString();
}
