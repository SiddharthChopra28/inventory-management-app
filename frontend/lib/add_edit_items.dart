part of 'main.dart';

class AddEditPage extends StatefulWidget {
  const AddEditPage({super.key});

  @override
  State<AddEditPage> createState() => AddEditPageState();
}

class AddEditPageState extends State<AddEditPage> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final String? id = args?['id'];

    final String title;
    bool addMode = false;
    bool editMode = false;


    if (id == null) {
      title = "Add Item";
      addMode = true;
      editMode = false;
    } else {
      title = "Edit Item";
      addMode = false;
      editMode = true;
    }

    var edited_values = {'id': id, 'name': name, 'quantity': quantity, 'category': category, 'price': price, 'imageURL': imageURL};


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Padding(
        padding: EdgeInsets.all(25.0), // Padding around the entire column

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: "Name"),
                onSubmitted: (String value) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
