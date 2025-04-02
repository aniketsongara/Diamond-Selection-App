import 'package:equatable/equatable.dart';

abstract class DiamondEvent extends Equatable {
  const DiamondEvent();

  @override
  List<Object?> get props => [];
}

class FilterDiamonds extends DiamondEvent {
  final double? caratFrom;
  final double? caratTo;
  final String? lab;
  final String? shape;
  final String? color;
  final String? clarity;

  const FilterDiamonds({
    this.caratFrom,
    this.caratTo,
    this.lab,
    this.shape,
    this.color,
    this.clarity,
  });

  @override
  List<Object?> get props => [caratFrom, caratTo, lab, shape, color, clarity];
}

class SortDiamonds extends DiamondEvent {
  final String sortBy;

  const SortDiamonds(this.sortBy);

  @override
  List<Object> get props => [sortBy];
}
