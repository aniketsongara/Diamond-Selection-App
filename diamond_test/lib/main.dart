import 'package:diamond_test/repositories/cart_repository.dart';
import 'package:diamond_test/screens/filter_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/cart_bloc/cart_bloc.dart';
import 'blocs/diamond_bloc/diamond_bloc.dart';

void main() {
  runApp(const DiamondApp());
}

class DiamondApp extends StatelessWidget {
  const DiamondApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DiamondBloc>(create: (context) => DiamondBloc()),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(cartRepository: CartRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Diamond App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        home: const FilterPage(),
      ),
    );
  }
}
