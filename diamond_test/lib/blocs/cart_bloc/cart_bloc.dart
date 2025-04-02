import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc({required this.cartRepository}) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<CheckCartStatus>(_onCheckCartStatus);
  }

  void _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cartItems = await cartRepository.getCartItems();

      // Calculate cart summary
      double totalCarat = 0;
      double totalPrice = 0;
      double totalDiscount = 0;

      for (var diamond in cartItems) {
        totalCarat += diamond.carat;
        totalPrice += diamond.finalAmount;
        totalDiscount += diamond.discount;
      }

      double averagePrice =
          cartItems.isNotEmpty ? totalPrice / cartItems.length : 0;
      double averageDiscount =
          cartItems.isNotEmpty ? totalDiscount / cartItems.length : 0;

      emit(
        CartLoaded(
          items: cartItems,
          totalCarat: totalCarat,
          totalPrice: totalPrice,
          averagePrice: averagePrice,
          averageDiscount: averageDiscount,
        ),
      );
    } catch (e) {
      emit(CartError('Failed to load cart: $e'));
    }
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      await cartRepository.addToCart(event.diamond);
      add(LoadCart());
    } catch (e) {
      emit(CartError('Failed to add item to cart: $e'));
    }
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    try {
      await cartRepository.removeFromCart(event.lotId);
      add(LoadCart());
    } catch (e) {
      emit(CartError('Failed to remove item from cart: $e'));
    }
  }

  void _onCheckCartStatus(
    CheckCartStatus event,
    Emitter<CartState> emit,
  ) async {
    try {
      final isInCart = await cartRepository.isInCart(event.lotId);
      emit(CartItemStatus(lotId: event.lotId, isInCart: isInCart));
    } catch (e) {
      emit(CartError('Failed to check cart status: $e'));
    }
  }
}
