import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../main.dart';
import 'auth_screens.dart';
import 'dish_detail_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    );
    final entrance = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    );
    _fadeIn = entrance;
    _slideIn = Tween<Offset>(
      begin: const Offset(0, .045),
      end: Offset.zero,
    ).animate(entrance);
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: cream,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final heroHeight = (constraints.maxHeight * .34)
                  .clamp(190.0, 300.0)
                  .toDouble();
              final headlineSize = constraints.maxWidth < 360 ? 29.0 : 33.0;
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: (constraints.maxHeight - 36)
                        .clamp(0.0, double.infinity)
                        .toDouble(),
                  ),
                  child: FadeTransition(
                    opacity: _fadeIn,
                    child: SlideTransition(
                      position: _slideIn,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _HeroArtwork(height: heroHeight),
                          const SizedBox(height: 16),
                          _FeaturedDishBanner(onTap: _showFeaturedDish),
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.white,
                                    height: 1.14,
                                    fontSize: headlineSize,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -.8,
                                  ),
                                  children: const [
                                    TextSpan(text: 'Find the '),
                                    TextSpan(
                                      text: 'Best Dish',
                                      style: TextStyle(color: orange),
                                    ),
                                    TextSpan(
                                      text: ' in Town, Not Just the Restaurant',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                'Discover, rate, and compare individual dishes from your favorite local restaurants.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: muted,
                                  fontSize: 15,
                                  height: 1.55,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),
                          Column(
                            children: [
                              _GradientPillButton(
                                label: 'Get Started',
                                icon: Icons.arrow_forward_rounded,
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/home'),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: OutlinedButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(color: line),
                                    shape: const StadiumBorder(),
                                  ),
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (_) => const RegisterScreen(),
                                  ),
                                ),
                                child: const Text.rich(
                                  TextSpan(
                                    style: TextStyle(
                                      color: muted,
                                      fontSize: 13,
                                    ),
                                    children: [
                                      TextSpan(text: "Don't have an account? "),
                                      TextSpan(
                                        text: 'Sign Up',
                                        style: TextStyle(
                                          color: gold,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ),
  );

  Future<void> _showFeaturedDish() async {
    final dish = topRankedDish;
    if (dish == null) return;
    final openDish = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: surface,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(sheetContext).height * .78,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.local_fire_department_rounded, color: gold),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Today’s top-rated dish',
                      style: TextStyle(
                        color: ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    tooltip: 'Close',
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                dish.dishName,
                style: const TextStyle(
                  color: ink,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${dish.restaurantName} · ${dish.branchArea}',
                style: const TextStyle(color: muted),
              ),
              const SizedBox(height: 12),
              Text(
                dish.description,
                style: const TextStyle(color: muted, height: 1.5),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.pop(sheetContext, true),
                  style: FilledButton.styleFrom(
                    backgroundColor: orange,
                    foregroundColor: cream,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  icon: const Icon(Icons.restaurant_menu_rounded),
                  label: const Text('Explore this dish'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (openDish == true && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => DishDetailScreen(dish: dish)),
      );
    }
  }
}

class _HeroArtwork extends StatelessWidget {
  const _HeroArtwork({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(30),
    child: SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=1200&q=90',
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(color: surface),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  cream.withValues(alpha: .28),
                  cream.withValues(alpha: .55),
                  cream,
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: .82, end: 1),
                  duration: const Duration(milliseconds: 850),
                  curve: Curves.easeOutBack,
                  builder: (context, scale, child) =>
                      Transform.scale(scale: scale, child: child),
                  child: Container(
                    width: 86,
                    height: 96,
                    decoration: BoxDecoration(
                      color: cream.withValues(alpha: .84),
                      border: Border.all(color: gold, width: 2),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(42),
                        bottom: Radius.circular(24),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x55330000),
                          blurRadius: 22,
                          offset: Offset(0, 9),
                        ),
                      ],
                    ),
                    child: const Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.shield_rounded, color: gold, size: 73),
                        Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Icon(
                            Icons.star_rounded,
                            color: cream,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'FOODRANK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                    shadows: [Shadow(color: Colors.black87, blurRadius: 12)],
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'ISLAMABAD',
                  style: TextStyle(
                    color: gold,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 5,
                    shadows: [Shadow(color: Colors.black87, blurRadius: 10)],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _FeaturedDishBanner extends StatelessWidget {
  const _FeaturedDishBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dish = topRankedDish;
    if (dish == null) return const SizedBox.shrink();
    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: line),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                color: orange,
                size: 23,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TODAY’S TOP PICK',
                      style: TextStyle(
                        color: gold,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${dish.dishName} · ${dish.rating.toStringAsFixed(1)} ★',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: muted,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradientPillButton extends StatelessWidget {
  const _GradientPillButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 56,
    child: DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [orange, gold]),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x44FF6B35),
            blurRadius: 18,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 19),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        style: FilledButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: cream,
          shadowColor: Colors.transparent,
          shape: const StadiumBorder(),
        ),
      ),
    ),
  );
}
