import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_app/components/add_to_cart_button.dart';
import 'package:pizza_app/screens/cart/blocs/cart_bloc.dart';
import 'package:pizza_app/screens/home/views/details_screen.dart';
import 'package:pizza_repository/pizza_repository.dart';

class MenuItemCard extends StatelessWidget {
  final Pizza pizza;
  final bool isCompact;

  const MenuItemCard({required this.pizza, this.isCompact = false, super.key});

  void _openDetails(BuildContext context) {
    final cartBloc = context.read<CartBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cartBloc,
          child: DetailsScreen(pizza),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageHeight = isCompact ? 120.0 : 145.0;
    final discountedPrice =
        pizza.price - pizza.price * pizza.discount / 100;

    final card = Material(
      elevation: 3,
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => _openDetails(context),
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Image + badge overlay ──────────────────────────────────
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(
                children: [
                  Image.network(
                    pizza.picture,
                    width: double.infinity,
                    height: imageHeight,
                    fit: BoxFit.cover,
                  ),
                  // Gradient scrim at the bottom of the image
                  Positioned(
                    left: 0, right: 0, bottom: 0,
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.55),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Badges pinned to the bottom-left of the image
                  Positioned(
                    left: 8,
                    bottom: 7,
                    child: Row(
                      children: [
                        _Chip(
                          label: pizza.isVeg ? '🌿 Veg' : '🥩 Non-Veg',
                          color: pizza.isVeg
                              ? Colors.green.shade600
                              : Colors.red.shade400,
                        ),
                        if (pizza.spiceLevel > 0) ...[
                          const SizedBox(width: 4),
                          _Chip(
                            label: pizza.spiceLevel == 1
                                ? '🌶 Mild'
                                : pizza.spiceLevel == 2
                                    ? '🌶🌶 Medium'
                                    : '🌶🌶🌶 Hot',
                            color: pizza.spiceLevel == 1
                                ? Colors.orange.shade700
                                : pizza.spiceLevel == 2
                                    ? Colors.deepOrange
                                    : Colors.red.shade700,
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Discount badge — top-right corner
                  if (pizza.discount > 0)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.red.shade500,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '-${pizza.discount}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Content area ───────────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text(
                pizza.name,
                style: TextStyle(
                  fontSize: isCompact ? 13 : 15,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            if (!isCompact) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  pizza.description,
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                      height: 1.3),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],

            // ── Price row ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 8, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$${discountedPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: isCompact ? 14 : 16,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      if (pizza.discount > 0)
                        Text(
                          '\$${pizza.price}.00',
                          style: TextStyle(
                            fontSize: 10,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey.shade400,
                          ),
                        ),
                    ],
                  ),
                  AddToCartButton(pizza: pizza, filled: true),
                ],
              ),
            ),

            // ── Info footer ────────────────────────────────────────────
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded,
                      color: Colors.amber, size: 14),
                  const SizedBox(width: 3),
                  Text(
                    '4.${(pizza.pizzaId.hashCode.abs() % 9) + 1}',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700),
                  ),
                  if (pizza.macros.calories > 0) ...[
                    Text('  ·  ',
                        style: TextStyle(color: Colors.grey.shade400)),
                    const Icon(Icons.local_fire_department_rounded,
                        color: Colors.orange, size: 13),
                    const SizedBox(width: 2),
                    Text(
                      '${pizza.macros.calories} kcal',
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (isCompact) {
      return SizedBox(width: 168, child: card);
    }
    return card;
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
