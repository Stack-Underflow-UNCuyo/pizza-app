import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_app/components/cart_app_bar_action.dart';
import 'package:pizza_app/screens/auth/blocs/sing_in_bloc/sing_in_bloc.dart';
import 'package:pizza_app/screens/cart/blocs/cart_bloc.dart';
import 'package:pizza_app/screens/cart/views/cart_screen.dart';
import 'package:pizza_app/screens/home/blocs/get_pizza_bloc/get_pizza_bloc.dart';
import 'package:pizza_app/screens/landing/views/landing_screen.dart';

class AppLandingScreen extends StatelessWidget {
  const AppLandingScreen({super.key});

  static const _categories = [
    (key: 'pizza',    emoji: '🍕', label: 'Pizzas'),
    (key: 'beverage', emoji: '🥤', label: 'Beverages'),
    (key: 'starter',  emoji: '🥗', label: 'Starters'),
    (key: 'dessert',  emoji: '🍰', label: 'Desserts'),
  ];

  void _goToMenu(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<SingInBloc>()),
            BlocProvider.value(value: context.read<GetPizzaBloc>()),
            BlocProvider.value(value: context.read<CartBloc>()),
          ],
          child: LandingScreen(initialCategory: category),
        ),
      ),
    );
  }

  void _goToCart(BuildContext context) {
    final cartBloc = context.read<CartBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            BlocProvider.value(value: cartBloc, child: const CartScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primary,
              primary.withValues(alpha: 0.55),
              Colors.blue.shade50,
            ],
            stops: const [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Top action row ─────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () =>
                          context.read<SingInBloc>().add(SingOutRequired()),
                      icon: const Icon(CupertinoIcons.square_arrow_right,
                          color: Colors.white),
                    ),
                    CartAppBarAction(onPressed: () => _goToCart(context)),
                  ],
                ),
              ),

              // ── Hero header ────────────────────────────────────────
              const SizedBox(height: 24),
              const Text('🍕', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 12),
              const Text(
                'PIZZA',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'What are you craving today?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.88),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 40),

              // ── Category grid ──────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.15,
                    physics: const NeverScrollableScrollPhysics(),
                    children: _categories
                        .map((cat) => _CategoryTile(
                              emoji: cat.emoji,
                              label: cat.label,
                              onTap: () => _goToMenu(context, cat.key),
                            ))
                        .toList(),
                  ),
                ),
              ),

              // ── Explore all button ─────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: OutlinedButton(
                  onPressed: () => _goToMenu(context, 'All'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    side: const BorderSide(color: Colors.white, width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Explore Full Menu',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 4,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
