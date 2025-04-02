import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/diamond_data.dart';
import '../../models/diamond.dart';
import 'diamond_event.dart';
import 'diamond_state.dart';

class DiamondBloc extends Bloc<DiamondEvent, DiamondState> {
  DiamondBloc() : super(DiamondInitial()) {
    on<FilterDiamonds>(_onFilterDiamonds);
    on<SortDiamonds>(_onSortDiamonds);
  }

  void _onFilterDiamonds(FilterDiamonds event, Emitter<DiamondState> emit) {
    emit(DiamondLoading());

    try {
      var filteredDiamonds =
          diamondData.where((diamond) {
            // Apply carat range filter
            if (event.caratFrom != null && diamond.carat < event.caratFrom!) {
              return false;
            }

            if (event.caratTo != null && diamond.carat > event.caratTo!) {
              return false;
            }

            // Apply lab filter
            if (event.lab != null &&
                event.lab!.isNotEmpty &&
                diamond.lab != event.lab) {
              return false;
            }

            // Apply shape filter
            if (event.shape != null &&
                event.shape!.isNotEmpty &&
                diamond.shape != event.shape) {
              return false;
            }

            // Apply color filter
            if (event.color != null &&
                event.color!.isNotEmpty &&
                diamond.color != event.color) {
              return false;
            }

            // Apply clarity filter
            if (event.clarity != null &&
                event.clarity!.isNotEmpty &&
                diamond.clarity != event.clarity) {
              return false;
            }

            return true;
          }).toList();

      // Apply sorting if available
      if (state is DiamondLoaded) {
        final loadedState = state as DiamondLoaded;
        if (loadedState.sortBy.isNotEmpty) {
          _sortDiamonds(
            filteredDiamonds,
            loadedState.sortBy,
            loadedState.ascending,
          );
        }
      }

      emit(
        DiamondLoaded(
          diamonds: filteredDiamonds,
          sortBy: state is DiamondLoaded ? (state as DiamondLoaded).sortBy : '',
          ascending:
              state is DiamondLoaded
                  ? (state as DiamondLoaded).ascending
                  : true,
        ),
      );
    } catch (e) {
      emit(DiamondError('Error filtering diamonds: $e'));
    }
  }

  void _onSortDiamonds(SortDiamonds event, Emitter<DiamondState> emit) {
    if (state is DiamondLoaded) {
      final currentState = state as DiamondLoaded;
      List<Diamond> sortedDiamonds = List.from(currentState.diamonds);

      bool ascending = true;
      // If sorting by same field, toggle direction
      if (event.sortBy == currentState.sortBy) {
        ascending = !currentState.ascending;
      }

      _sortDiamonds(sortedDiamonds, event.sortBy, ascending);

      emit(
        DiamondLoaded(
          diamonds: sortedDiamonds,
          sortBy: event.sortBy,
          ascending: ascending,
        ),
      );
    }
  }

  void _sortDiamonds(List<Diamond> diamonds, String sortBy, bool ascending) {
    switch (sortBy) {
      case 'finalAmount':
        diamonds.sort(
          (a, b) =>
              ascending
                  ? a.finalAmount.compareTo(b.finalAmount)
                  : b.finalAmount.compareTo(a.finalAmount),
        );
        break;
      case 'carat':
        diamonds.sort(
          (a, b) =>
              ascending
                  ? a.carat.compareTo(b.carat)
                  : b.carat.compareTo(a.carat),
        );
        break;
      default:
        // No sorting
        break;
    }
  }
}
