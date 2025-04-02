import 'package:equatable/equatable.dart';
import '../../models/diamond.dart';

abstract class DiamondState extends Equatable {
  const DiamondState();

  @override
  List<Object> get props => [];
}

class DiamondInitial extends DiamondState {}

class DiamondLoading extends DiamondState {}

class DiamondLoaded extends DiamondState {
  final List<Diamond> diamonds;
  final String sortBy;
  final bool ascending;

  const DiamondLoaded({
    required this.diamonds,
    this.sortBy = '',
    this.ascending = true,
  });

  @override
  List<Object> get props => [diamonds, sortBy, ascending];
}

class DiamondError extends DiamondState {
  final String message;

  const DiamondError(this.message);

  @override
  List<Object> get props => [message];
}
