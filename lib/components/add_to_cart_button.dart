import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_app/screens/cart/blocs/cart_bloc.dart';
import 'package:pizza_repository/pizza_repository.dart';

class AddToCartButton extends StatefulWidget {
  final Pizza pizza;
  final bool filled;

  const AddToCartButton({
    required this.pizza,
    this.filled = false,
    super.key,
  });

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 80),
    lowerBound: 0.78,
    upperBound: 1.0,
    value: 1.0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    HapticFeedback.lightImpact();
    _controller.reverse();
    await Future.delayed(const Duration(milliseconds: 80));
    _controller.forward();
    if (!mounted) return;
    context.read<CartBloc>().add(CartAddItem(widget.pizza));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${widget.pizza.name} added to cart!'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(12),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: _onTap,
      child: ScaleTransition(
        scale: _controller,
        child: widget.filled
            ? Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              )
            : Icon(Icons.add_circle, color: primary, size: 30),
      ),
    );
  }
}
