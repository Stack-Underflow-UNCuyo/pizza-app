import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_app/components/cart_app_bar_action.dart';
import 'package:pizza_app/components/menu_item_card.dart';
import 'package:pizza_app/screens/auth/blocs/sing_in_bloc/sing_in_bloc.dart';
import 'package:pizza_app/screens/cart/blocs/cart_bloc.dart';
import 'package:pizza_app/screens/cart/views/cart_screen.dart';
import 'package:pizza_app/screens/home/blocs/get_pizza_bloc/get_pizza_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
        title: Row(
          children: [
            Image.asset('assets/8.png', scale: 14),
            const SizedBox(width: 5),
            const Text(
              'PIZZA',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
            ),
          ],
        ),
        actions: [
          CartAppBarAction(onPressed: () => _goToCart(context)),
          IconButton(
            onPressed: () =>
                context.read<SingInBloc>().add(SingOutRequired()),
            icon: const Icon(CupertinoIcons.square_arrow_right),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<GetPizzaBloc, GetPizzaState>(
          builder: (context, state) {
            if (state is GetPizzaSuccess) {
              final pizzas = state.pizzas
                  .where((p) => p.category == 'pizza')
                  .toList();
              return GridView.builder(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 13,
                        mainAxisSpacing: 16,
                        childAspectRatio: 9 / 16),
                itemCount: pizzas.length,
                itemBuilder: (context, i) =>
                    MenuItemCard(pizza: pizzas[i]),
              );
            } else if (state is GetPizzaLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text('Failed to load pizzas.'));
            }
          },
        ),
      ),
    );
  }
}
