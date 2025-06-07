import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'bloc/items_grid_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ItemsGridBloc()..add(ItemsGridStartedEvent()),
      child: MaterialApp(
        title: 'IMS',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        ),
        home: const MyHomePage(title: 'Inventory Management System'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const TextField(decoration: InputDecoration(hintText: "Search")),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              child: Row(
                children: <Widget>[
                  FilterChip(
                    label: Text("Filter Item 1"),
                    selected: false, //replace with a boolean
                    onSelected: (bool selected) {
                      // do something
                    },
                  ),
                  FilterChip(
                    label: Text("Filter Item 2"),
                    selected: false, //replace with a boolean
                    onSelected: (bool selected) {
                      // do something
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              // child:
              // ),
              child: BlocBuilder<ItemsGridBloc, ItemsGridState>(
                builder: (context, state) {
                  if (state is ItemsGridLoadingState) {
                    return CircularProgressIndicator();
                  }
                  else if (state is ItemsGridLoadedState) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (content, index) {
                        return Container(
                          color: Colors.blue,
                          child: Text('Item'),
                        );
                      },
                    );
                  }
                  else if (state is ItemsGridErrorState) {
                    return Text('Error: ${state.message}');
                  }
                  else{
                    return Text("something happened?");
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Hellow rold");
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
