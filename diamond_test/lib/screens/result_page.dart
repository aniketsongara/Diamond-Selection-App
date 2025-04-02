import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocs/cart_bloc/cart_bloc.dart';
import '../blocs/cart_bloc/cart_event.dart';
import '../blocs/cart_bloc/cart_state.dart';
import '../blocs/diamond_bloc/diamond_bloc.dart';
import '../blocs/diamond_bloc/diamond_event.dart';
import '../blocs/diamond_bloc/diamond_state.dart';
import '../models/diamond.dart';
import 'cart_page.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final currencyFormat = NumberFormat.currency(symbol: '\$');
  String _sortOption = 'none';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diamond Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSortBar(),
          Expanded(
            child: BlocBuilder<DiamondBloc, DiamondState>(
              builder: (context, state) {
                if (state is DiamondLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DiamondLoaded) {
                  final diamonds = state.diamonds;

                  if (diamonds.isEmpty) {
                    return const Center(
                      child: Text(
                        'No diamonds match your filters',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: diamonds.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final diamond = diamonds[index];
                      return _buildDiamondItem(diamond);
                    },
                  );
                } else if (state is DiamondError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(
                    child: Text('Apply filters to see results'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const Text(
            'Sort by: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: _sortOption,
            underline: Container(),
            items: const [
              DropdownMenuItem(value: 'none', child: Text('None')),
              DropdownMenuItem(value: 'finalAmount', child: Text('Price')),
              DropdownMenuItem(value: 'carat', child: Text('Carat Weight')),
            ],
            onChanged: (value) {
              setState(() {
                _sortOption = value!;
              });

              if (value != 'none') {
                context.read<DiamondBloc>().add(SortDiamonds(value!));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDiamondItem(Diamond diamond) {
    // Check if diamond is in cart
    context.read<CartBloc>().add(CheckCartStatus(diamond.lotId));

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        bool isInCart = false;

        if (cartState is CartItemStatus && cartState.lotId == diamond.lotId) {
          isInCart = cartState.isInCart;
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lot ID: ${diamond.lotId}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      child: Text(
                        isInCart
                            ? 'Remove'
                            : 'Add',
                      ),
                      onPressed: () {
                        if (isInCart) {
                          context.read<CartBloc>().add(
                            RemoveFromCart(diamond.lotId),
                          );
                        } else {
                          context.read<CartBloc>().add(AddToCart(diamond));
                        }
                      },
                    ),
                  ],
                ),
                const Divider(),
                _buildDetailRow('Carat', diamond.carat.toString()),
                _buildDetailRow('Shape', diamond.shape),
                _buildDetailRow('Size', diamond.size),
                _buildDetailRow('Color', diamond.color),
                _buildDetailRow('Clarity', diamond.clarity),
                _buildDetailRow('Cut', diamond.cut),
                _buildDetailRow('Polish', diamond.polish),
                _buildDetailRow('Symmetry', diamond.symmetry),
                _buildDetailRow('Fluorescence', diamond.fluorescence),
                _buildDetailRow('Lab', diamond.lab),
                _buildDetailRow('Discount', '${diamond.discount}%'),
                _buildDetailRow(
                  'Per Carat Rate',
                  currencyFormat.format(diamond.perCaratRate),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Final Price: ${currencyFormat.format(diamond.finalAmount)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
