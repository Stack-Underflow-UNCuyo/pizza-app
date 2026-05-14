import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pizza_repository/pizza_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<CartAddItem>((event, emit) {
      final items = List<CartItem>.from(state.items);
      final idx =
          items.indexWhere((i) => i.pizza.pizzaId == event.pizza.pizzaId);
      if (idx >= 0) {
        items[idx] = items[idx].copyWith(quantity: items[idx].quantity + 1);
      } else {
        items.add(CartItem(pizza: event.pizza, quantity: 1));
      }
      emit(CartState(items: items));
    });

    on<CartRemoveItem>((event, emit) {
      emit(CartState(
          items: state.items
              .where((i) => i.pizza.pizzaId != event.pizzaId)
              .toList()));
    });

    on<CartIncrementItem>((event, emit) {
      final items = List<CartItem>.from(state.items);
      final idx =
          items.indexWhere((i) => i.pizza.pizzaId == event.pizzaId);
      if (idx >= 0) {
        items[idx] = items[idx].copyWith(quantity: items[idx].quantity + 1);
        emit(CartState(items: items));
      }
    });

    on<CartDecrementItem>((event, emit) {
      final items = List<CartItem>.from(state.items);
      final idx =
          items.indexWhere((i) => i.pizza.pizzaId == event.pizzaId);
      if (idx >= 0) {
        if (items[idx].quantity <= 1) {
          items.removeAt(idx);
        } else {
          items[idx] = items[idx].copyWith(quantity: items[idx].quantity - 1);
        }
        emit(CartState(items: items));
      }
    });

    on<CartClear>((event, emit) => emit(const CartState()));
  }
}
