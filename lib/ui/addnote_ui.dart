import 'package:flutter/material.dart';
import 'package:note_keeper_app/model/model_class.dart';
import 'package:note_keeper_app/ui/home_screen_ui.dart';
import 'package:note_keeper_app/util/database_helper_util.dart';

class AddNoteScreen extends StatefulWidget {
  ModelClass model;

  AddNoteScreen({Key key}) : super(key: key);

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  var db = DatabaseHelper();
  final List<ModelClass> _itemList = <ModelClass>[];
  final _formKey = GlobalKey<FormState>();
  ModelClass model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        shape: const OutlineInputBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
          ),
        ),
        backgroundColor: Colors.teal.shade900,
        title: const Text("Add Note"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                autofocus: false,
                controller: _titleController,
                keyboardType: TextInputType.text,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return "please enter your title";
                  }
                },
                onSaved: (value) {
                  _titleController.text = value;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.title_rounded),
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Title",
                    labelText: "Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                autofocus: false,
                keyboardType: TextInputType.text,
                controller: _descriptionController,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return "Enter Description";
                  }
                },
                onSaved: (value) {
                  _descriptionController.text = value;
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.description_rounded),
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Description",
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: MaterialButton(
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          elevation: 5,
                          color: Colors.teal.shade900,
                          child: const Text("Save",
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            _save(_titleController.text,
                                _descriptionController.text);
                          })),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: MaterialButton(
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          elevation: 5,
                          color: Colors.teal.shade900,
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          })),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save(String title, String detail) async {
    if (_formKey.currentState.validate()) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return const HomeScreen();
      }));
      _titleController.clear();
      _descriptionController.clear();
      ModelClass noDoItem = ModelClass(title, detail);
      int savedItemId = await db.insertData(noDoItem);
      ModelClass addedItem = await db.getSingleData(savedItemId);
      setState(() {
        _itemList.insert(0, addedItem);
      });
    }
  }
}
