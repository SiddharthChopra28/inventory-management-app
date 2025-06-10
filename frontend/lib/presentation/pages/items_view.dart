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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },

      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
            ),
          ],
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
                          widgets.insert(
                            0,
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                              ),
                          itemCount: state.items.length,
                          itemBuilder: (context, index) {
                            final cardColor = Color(0xFFFFF7ED);
                            final accentColor = Color(0xFF0891B2);
                            final dets = state.items[index].getDetails();

                            if (dets["imageURL"] == "") {
                              dets["imageURL"] =
                                  "https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png";
                            }

                            return SizedBox(
                              height: 300,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/addedit', arguments: {'id': dets["id"]});
                              },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      // Image Section
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                        child: Image.network(
                                          // 'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png',
                                          dets["imageURL"],
                                          height: 150,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      // Content Section
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                dets["name"],
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "₹ ${dets["price"]}",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.green[700],
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Quantity: ${dets["quantity"]}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "Category: ${dets['category']}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black87,
                                                ),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
      ),
    );
  }
}
