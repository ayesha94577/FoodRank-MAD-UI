import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../main.dart';
import '../screens/dish_detail_screen.dart';

class DishRankCard extends StatelessWidget {
  const DishRankCard({
    required this.dish,
    required this.rank,
    this.heroTag,
    super.key,
  });

  final FoodDish dish;
  final int rank;
  final String? heroTag;

  String get _heroTag => heroTag ?? 'dish-${dish.id}';

  Color get _badgeColor => switch (rank) {
    1 => gold,
    2 => const Color(0xFFB7C4CE),
    3 => const Color(0xFFB87954),
    _ => const Color(0xFF28616A),
  };

  Color get _badgeTextColor =>
      rank == 2 || rank == 3 ? const Color(0xFF121418) : cream;

  @override
  Widget build(BuildContext context) => Material(
    color: surface,
    elevation: 3,
    shadowColor: rank == 1 ? const Color(0x4DFF6B35) : const Color(0x55000000),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(
        color: rank == 1 ? orange : line,
        width: rank == 1 ? 1.4 : 1,
      ),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => DishDetailScreen(dish: dish, heroTag: _heroTag),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 37,
              height: 37,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _badgeColor,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(
                '#${dish.rank}',
                style: TextStyle(
                  color: _badgeTextColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 11),
            Hero(
              tag: _heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  dish.imageUrl,
                  width: 76,
                  height: 76,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 76,
                    height: 76,
                    color: surface,
                    alignment: Alignment.center,
                    child: const Icon(Icons.restaurant_rounded, color: ink),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
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
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    dish.restaurantName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: muted, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF272B33),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '📍 ${dish.branchArea}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ink,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF292D35),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: gold,
                              size: 15,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              dish.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: ink,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Rs. ${_formatPrice(dish.price)}',
                        style: const TextStyle(
                          color: gold,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
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

String _formatPrice(int price) {
  final digits = price.toString();
  final output = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) output.write(',');
    output.write(digits[index]);
  }
  return output.toString();
}
