import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'bloc/items_grid/items_grid_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'items_view.dart';
part 'add_edit_items.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MultiBlocProvider(
      providers: [
        BlocProvider<ItemsGridBloc>(
          create: (context) => ItemsGridBloc(),
        ),
        // BlocProvider<ItemsBloc>(
        //   create: (context) => ItemsBloc(itemsRepository: ItemsRepository()),
        // ),
        // BlocProvider<ItemFormBloc>(
        //   create: (context) => ItemFormBloc(itemsRepository: ItemsRepository()),
        // ),
      ],
      child: MaterialApp(
        title: 'IMS',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        ),
        initialRoute: '/items_view',
        routes: {
          '/items_view': (context) =>
              MyHomePage(title: 'Inventory Management System'),
          '/addedit': (context) => AddEditPage(),
        },
      ),
    );
  }
}
