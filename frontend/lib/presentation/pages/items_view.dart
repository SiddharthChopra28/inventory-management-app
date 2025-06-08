part of '../../main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? selectedFilter;

  @override
  void initState() {
    super.initState();
    context.read<ItemsGridBloc>().add(ItemsGridStartedEvent());
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(25.0), // Padding around the entire column

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: "Search"),
                onSubmitted: (String value) {
                  context.read<ItemsGridBloc>().add(
                    ChangeSearchStringEvent(currSearchStr: value),
                  );
                },
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child: BlocBuilder<ItemsGridBloc, ItemsGridState>(
                  builder: (context, state) {
                    List<Widget> widgets = [
                      FilterChip(
                        label: Text("Clear Filters"),
                        selected: false,
                        onSelected: (bool selected) {
                          setState(() {
                            selectedFilter = "";
                          });
                          context.read<ItemsGridBloc>().add(
                            ChangeSearchStringEvent(currSearchStr: ""),
                          );
                        },
                      ),
                    ];
                    if (state is ItemsGridLoadedState) {
                      for (var cat in state.categories) {
                        widgets.add(
                          FilterChip(
                            label: Text(cat),
                            selected: selectedFilter == cat,
                            onSelected: (bool selected) {
                              if (selected) {
                                setState(() {
                                  selectedFilter = cat;
                                });
                                context.read<ItemsGridBloc>().add(
                                  ChangeSearchStringEvent(currSearchStr: cat),
                                );
                              } else {
                                setState(() {
                                  selectedFilter = "";
                                });
                                context.read<ItemsGridBloc>().add(
                                  ChangeSearchStringEvent(currSearchStr: ""),
                                );
                              }
                            },
                          ),
                        );
                      }
                    }
                    return Row(children: widgets);
                  },
                ),
              ),
              Expanded(
                // child:
                // ),
                child: BlocBuilder<ItemsGridBloc, ItemsGridState>(
                  builder: (context, state) {
                    if (state is ItemsGridLoadingState) {
                      return CircularProgressIndicator();
                    } else if (state is ItemsGridLoadedState) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: state.items.length,
                        itemBuilder: (content, index) {
                          return Container(
                            color: Colors.blue,
                            child: Text('Item'),

                            // context.read<TodoBloc>().add(ToggleTodoEvent(widget.item));
                            // need to add the event of click from here
                          );
                        },
                      );
                    } else if (state is ItemsGridErrorState) {
                      return Text('Error: ${state.message}');
                    } else {
                      return Text("something happened?");
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/addedit', arguments: {'id': null});
        },
        tooltip: 'Increment',
        icon: const Icon(Icons.add),
        label: const Text("Add Item"),
      ),
    );
  }
}
