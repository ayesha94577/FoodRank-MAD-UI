import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../main.dart';
import '../models/dish.dart';
import 'dish_rank_card.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 54,
    child: FilledButton.icon(
      onPressed: onPressed,
      icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 19),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      style: FilledButton.styleFrom(
        backgroundColor: orange,
        foregroundColor: cream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
  );
}

class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, {this.action, this.onTap, super.key});

  final String title;
  final String? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            color: ink,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -.4,
          ),
        ),
      ),
      if (action != null)
        TextButton(
          onPressed: onTap,
          child: Text(
            action!,
            style: const TextStyle(color: ink, fontWeight: FontWeight.w600),
          ),
        ),
    ],
  );
}

class FoodImage extends StatelessWidget {
  const FoodImage({
    required this.url,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    super.key,
  });

  final String url;
  final double? height;
  final double? width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) => Image.network(
    url,
    height: height,
    width: width,
    fit: fit,
    errorBuilder: (context, error, stackTrace) => Container(
      height: height,
      width: width,
      color: surface,
      alignment: Alignment.center,
      child: const Icon(Icons.restaurant, color: muted, size: 32),
    ),
  );
}

class RatingPill extends StatelessWidget {
  const RatingPill(this.rating, {super.key});

  final double rating;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(Icons.star_rounded, color: gold, size: 18),
      const SizedBox(width: 3),
      Text(
        rating.toStringAsFixed(1),
        style: const TextStyle(color: ink, fontWeight: FontWeight.w800),
      ),
    ],
  );
}

class DishCard extends StatelessWidget {
  const DishCard({
    required this.dish,
    required this.rank,
    this.heroTag,
    super.key,
  });

  final Dish dish;
  final int rank;
  final String? heroTag;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: DishRankCard(
      dish: FoodDish(
        id: 'legacy-${dish.name}',
        dishName: dish.name,
        restaurantName: dish.restaurant,
        category: dish.category,
        price: dish.price,
        rating: dish.rating,
        rank: rank,
        imageUrl: dish.imageUrl,
        branchArea: dish.branchArea,
        googleMapsUrl:
            'https://maps.google.com/?q=${Uri.encodeComponent('${dish.restaurant} ${dish.branchArea} Islamabad')}',
        directDishUrl:
            'https://www.google.com/search?q=${Uri.encodeQueryComponent('${dish.restaurant} Islamabad ${dish.name}')}',
        officialWebsite:
            'https://www.google.com/search?q=${Uri.encodeComponent('${dish.restaurant} Islamabad official website')}',
        description: dish.description,
        ratingCount: dish.votes,
      ),
      rank: rank,
      heroTag: heroTag,
    ),
  );
}

class BackHeader extends StatelessWidget implements PreferredSizeWidget {
  const BackHeader({required this.title, super.key});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) => AppBar(
    leading: IconButton.filled(
      onPressed: () => Navigator.maybePop(context),
      tooltip: 'Back',
      style: IconButton.styleFrom(
        backgroundColor: surface,
        foregroundColor: gold,
        side: const BorderSide(color: Color(0x66FFB03A)),
      ),
      icon: const Icon(Icons.arrow_back_rounded, size: 21),
    ),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
  );
}
