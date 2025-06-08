part of '../../main.dart';

class AddEditPage extends StatefulWidget {
  const AddEditPage({super.key});

  @override
  State<AddEditPage> createState() => AddEditPageState();
}

class AddEditPageState extends State<AddEditPage> {
  Map<String, dynamic> details = {};
  int? id;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery, // or ImageSource.camera
      maxWidth: 1800,
      maxHeight: 1800,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    id = args?['id'];

    if (id != null) {
      context.read<ItemsAddEditBloc>().add(ItemsAddEditOpenedEvent(itemid: id));
    }

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(id == null ? "Add Item" : "Edit Item"),
        ),
        body: BlocBuilder<ItemsAddEditBloc, ItemsAddEditState>(
          builder: (context, state) {
            List<Widget> widgets = [
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[50],
                ),

                child: InkWell(
                  onTap: () {
                    _pickImage();
                  },
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: 240,
                            height: 240,
                          ),
                        )
                      : Icon(
                          Icons.image_outlined,
                          size: 100,
                          color: Colors.grey[400],
                        ),
                ),
              ),

              Spacer(flex: 1),

              // name
              TextField(
                decoration: InputDecoration(
                  hintText: "Item Name",
                  border: OutlineInputBorder(),
                ),
                controller: _nameController,
              ),

              // quantity
              Spacer(flex: 1),

              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Enter quantity',
                  border: OutlineInputBorder(),
                ),
                controller: _quantityController,
              ),

              Spacer(flex: 1),

              // category
              TextField(
                decoration: InputDecoration(
                  hintText: "Category",
                  border: OutlineInputBorder(),
                ),
                controller: _categoryController,
              ),

              Spacer(flex: 1),

              // price
              TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                decoration: InputDecoration(
                  hintText: 'Enter price',
                  border: OutlineInputBorder(),
                  prefixText: '₹',
                ),
                controller: _priceController,
              ),

              Spacer(flex: 10),
            ];

            if (state is ItemsAddEditLoadingState && id != null) {
              return CircularProgressIndicator();
            } else if (state is ItemsAddEditErrorState) {
              return Text(state.message);
            } else if (state is ItemsAddEditLoadingState && id == null) {
              // new item mode
            } else if (state is ItemsAddEditLoadedState && id != null) {
              // we can read item from the state
              Item? item = state.item;
              setState(() {
                id = item?.id;
                details = item?.getDetails();
                _nameController.text = details['name'];
                _priceController.text = details['price'] as String;
                _quantityController.text = details['quantity'] as String;
                _categoryController.text = details['category'];
              });
              if (details['imageURL'] != "") {
                var imgContainer = Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[50],
                  ),

                  child: InkWell(
                    onTap: () {
                      _pickImage();
                    },
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: 240,
                              height: 240,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              details["imageURL"],
                              fit: BoxFit.cover,
                              width: 240,
                              height: 240,
                            ),
                          ),
                  ),
                );

                widgets[0] = imgContainer;
              }
            }

            return Padding(
              padding: EdgeInsets.all(25.0), // Padding around the entire column

              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: widgets,
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // save all the data and send it to the bloc
            Map<String, dynamic> details_ = {
              'id': id,
              'name': _nameController.text,
              'quantity': _quantityController.text,
              'category': _categoryController.text,
              'price': _priceController.text,
            };

            if (id == null) {
              details_['imageURL'] = "";
            } else {
              details_['imageURL'] = details['imageURL'];
            }

            if (_selectedImage == null) {
              // no need to pass the file in the event
              context.read<ItemsAddEditBloc>().add(
                SubmitFormEvent(details: details_),
              );
            } else {
              // need to pass the file in the event
              context.read<ItemsAddEditBloc>().add(
                SubmitFormEvent(details: details_, file: _selectedImage),
              );
            }

            Navigator.pushNamedAndRemoveUntil(
              context,
              '/items_view', // Your home route
              (Route<dynamic> route) => false, // Removes all previous routes
            );
          },
          tooltip: 'Increment',
          icon: const Icon(Icons.check),
          label: const Text("Save"),
        ),
      ),
    );
  }
}
