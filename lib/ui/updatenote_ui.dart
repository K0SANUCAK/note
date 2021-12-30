import 'package:flutter/material.dart';
import 'package:note_keeper_app/model/model_class.dart';
import 'package:note_keeper_app/ui/home_screen_ui.dart';
import 'package:note_keeper_app/util/database_helper_util.dart';

// ignore: must_be_immutable
class UpdateNoteScreen extends StatefulWidget {
  List<ModelClass> itemList = <ModelClass>[];
  int index;
  HomeScreen homeScreen;

  UpdateNoteScreen(this.itemList, this.index, {Key key}) : super(key: key);

  @override
  _UpdateNoteScreenState createState() =>
      // ignore: no_logic_in_create_state
      _UpdateNoteScreenState(itemList, index);
}

class _UpdateNoteScreenState extends State<UpdateNoteScreen> {
  List<ModelClass> itemList = <ModelClass>[];
  int index;

  _UpdateNoteScreenState(this.itemList, this.index);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  var db = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  HomeScreen homeScreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        shape: const OutlineInputBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
          ),
        ),
        backgroundColor: Colors.teal.shade900,
        title: const Text("Edit Note"),
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
                          child: const Text(
                            "Update",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            updateItemList(itemList[index], index);
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

  updateItemList(ModelClass item, int index) async {
    if (_formKey.currentState.validate()) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return const HomeScreen();
      }));
      ModelClass newItemUpdated = ModelClass.fromMap({
        "title": _titleController.text,
        "description": _descriptionController.text,
        "id": item.id,
      });
      await db.updateItem(newItemUpdated);
      setState(() {});
      setState(() {
        // ignore: missing_return
        itemList.removeWhere((element) {
          itemList[index].title == item.title;
          itemList[index].description == item.description;
        });
      });
    }
  }
}
