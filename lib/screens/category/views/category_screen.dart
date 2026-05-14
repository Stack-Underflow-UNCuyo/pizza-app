import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_app/components/cart_app_bar_action.dart';
import 'package:pizza_app/components/menu_item_card.dart';
import 'package:pizza_app/screens/cart/blocs/cart_bloc.dart';
import 'package:pizza_app/screens/cart/views/cart_screen.dart';
import 'package:pizza_repository/pizza_repository.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;
  final List<Pizza> items;

  const CategoryScreen({
    required this.categoryName,
    required this.items,
    super.key,
  });

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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          categoryName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          CartAppBarAction(onPressed: () => _goToCart(context)),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.bag, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text('No items in $categoryName yet.',
                      style: TextStyle(color: Colors.grey.shade500)),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 13,
                        mainAxisSpacing: 16,
                        childAspectRatio: 9 / 16),
                itemCount: items.length,
                itemBuilder: (context, i) => MenuItemCard(pizza: items[i]),
              ),
            ),
    );
  }
}
