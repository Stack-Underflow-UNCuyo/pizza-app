import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pizza_app/components/macro.dart';
import 'package:pizza_app/screens/cart/blocs/cart_bloc.dart';
import 'package:pizza_app/screens/cart/views/cart_screen.dart';
import 'package:pizza_repository/pizza_repository.dart';

class DetailsScreen extends StatelessWidget {
  final Pizza pizza;
  const DetailsScreen(this.pizza, {super.key});

  void _buyNow(BuildContext context) {
    HapticFeedback.mediumImpact();
    final cartBloc = context.read<CartBloc>();
    cartBloc.add(CartAddItem(pizza));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cartBloc,
          child: const CartScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(3, 3),
                      blurRadius: 5,
                      color: Colors.grey)
                ],
                image: DecorationImage(
                    image: NetworkImage(pizza.picture), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(3, 3),
                      blurRadius: 5,
                      color: Colors.grey)
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            pizza.name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${(pizza.price - pizza.price * pizza.discount / 100).toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                Text(
                                  '\$${pizza.price}.00',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (pizza.macros.calories > 0 ||
                        pizza.macros.proteins > 0 ||
                        pizza.macros.fats > 0 ||
                        pizza.macros.carbs > 0) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        MyMacroWidget(
                            title: 'Calories',
                            value: pizza.macros.calories,
                            icon: FontAwesomeIcons.fire),
                        const SizedBox(width: 10),
                        MyMacroWidget(
                            title: 'Protein',
                            value: pizza.macros.proteins,
                            icon: FontAwesomeIcons.dumbbell),
                        const SizedBox(width: 10),
                        MyMacroWidget(
                            title: 'Fats',
                            value: pizza.macros.fats,
                            icon: FontAwesomeIcons.oilCan),
                        const SizedBox(width: 10),
                        MyMacroWidget(
                            title: 'Carbs',
                            value: pizza.macros.carbs,
                            icon: FontAwesomeIcons.breadSlice),
                      ],
                    ),
                    ],
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                        onPressed: () => _buyNow(context),
                        style: TextButton.styleFrom(
                            elevation: 3.0,
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: const Text(
                          'Buy Now',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
