import 'package:equatable/equatable.dart';

import '../../models/diamond.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final Diamond diamond;

  const AddToCart(this.diamond);

  @override
  List<Object> get props => [diamond];
}

class RemoveFromCart extends CartEvent {
  final String lotId;

  const RemoveFromCart(this.lotId);

  @override
  List<Object> get props => [lotId];
}

class CheckCartStatus extends CartEvent {
  final String lotId;

  const CheckCartStatus(this.lotId);

  @override
  List<Object> get props => [lotId];
}
