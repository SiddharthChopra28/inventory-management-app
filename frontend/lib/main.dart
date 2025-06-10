import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/bloc/auth/auth_bloc.dart';
import 'bloc/items_grid/items_grid_bloc.dart';
import 'bloc/items_add_edit/items_add_edit_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

import 'data/models/item.dart';

part 'presentation/pages/items_view.dart';
part 'presentation/pages/add_edit_items.dart';
part 'presentation/widgets/auth_wrapper.dart';

part 'presentation/pages/login.dart';
part 'presentation/pages/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ItemsGridBloc>(
          create: (context) => ItemsGridBloc(),
        ),
        BlocProvider<ItemsAddEditBloc>(
          create: (context) => ItemsAddEditBloc(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'IMS',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => AuthWrapper(),
          '/items_view': (context) =>
              MyHomePage(title: 'Inventory Management System'),
          '/addedit': (context) => AddEditPage(),
          '/register': (context) => RegisterPage(),
          '/login': (context) => LoginPage(),
        },
      ),
    );
  }
}
