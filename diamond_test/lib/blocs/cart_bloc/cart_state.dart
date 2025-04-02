import 'package:equatable/equatable.dart';
import '../../models/diamond.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<Diamond> items;
  final double totalCarat;
  final double totalPrice;
  final double averagePrice;
  final double averageDiscount;

  const CartLoaded({
    required this.items,
    required this.totalCarat,
    required this.totalPrice,
    required this.averagePrice,
    required this.averageDiscount,
  });

  @override
  List<Object> get props => [
    items,
    totalCarat,
    totalPrice,
    averagePrice,
    averageDiscount,
  ];
}

class CartItemStatus extends CartState {
  final String lotId;
  final bool isInCart;

  const CartItemStatus({required this.lotId, required this.isInCart});

  @override
  List<Object> get props => [lotId, isInCart];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}
