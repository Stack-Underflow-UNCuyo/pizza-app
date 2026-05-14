part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartAddItem extends CartEvent {
  final Pizza pizza;
  const CartAddItem(this.pizza);

  @override
  List<Object> get props => [pizza.pizzaId];
}

class CartRemoveItem extends CartEvent {
  final String pizzaId;
  const CartRemoveItem(this.pizzaId);

  @override
  List<Object> get props => [pizzaId];
}

class CartIncrementItem extends CartEvent {
  final String pizzaId;
  const CartIncrementItem(this.pizzaId);

  @override
  List<Object> get props => [pizzaId];
}

class CartDecrementItem extends CartEvent {
  final String pizzaId;
  const CartDecrementItem(this.pizzaId);

  @override
  List<Object> get props => [pizzaId];
}

class CartClear extends CartEvent {}
