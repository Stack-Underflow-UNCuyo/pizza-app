part of 'cart_bloc.dart';

class CartItem extends Equatable {
  final Pizza pizza;
  final int quantity;

  const CartItem({required this.pizza, required this.quantity});

  CartItem copyWith({int? quantity}) =>
      CartItem(pizza: pizza, quantity: quantity ?? this.quantity);

  double get discountedPrice =>
      pizza.price - (pizza.price * pizza.discount / 100);

  double get subtotal => discountedPrice * quantity;

  @override
  List<Object> get props => [pizza.pizzaId, quantity];
}

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({this.items = const []});

  double get total =>
      items.fold(0.0, (sum, item) => sum + item.subtotal);

  int get itemCount =>
      items.fold(0, (sum, item) => sum + item.quantity);

  @override
  List<Object> get props => [items];
}
