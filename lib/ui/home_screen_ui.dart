import 'package:flutter/material.dart';
import 'package:note_keeper_app/model/model_class.dart';
import 'package:note_keeper_app/ui/addnote_ui.dart';
import 'package:note_keeper_app/ui/updatenote_ui.dart';
import 'package:note_keeper_app/util/database_helper_util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController titleController = TextEditingController();
  var db = DatabaseHelper();
  final List<ModelClass> _itemList = <ModelClass>[];
  @override
  void initState() {
    super.initState();
    read();
  }

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
        title: const Text("Note List"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: _itemList.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: Colors.teal.shade800,
              elevation: 5,
              shape: const OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20))),
              child: ListTile(
                title: Text(
                  _itemList[index].title,
                  style: const TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                subtitle: Text(
                  _itemList[index].description,
                  style: const TextStyle(color: Colors.white, fontSize: 12.0),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Info(
                                _itemList[index].title,
                                _itemList[index].description,
                              )));
                },
                leading: IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return UpdateNoteScreen(_itemList, index);
                      }));
                    },
                    icon: const Icon(Icons.edit)),
                trailing: IconButton(
                    onPressed: () {
                      _delete(_itemList[index].id, index);
                    },
                    icon: const Icon(
                      Icons.remove_circle,
                      color: Colors.redAccent,
                      size: 30,
                    )),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal.shade900,
          child: const Icon(Icons.add),
          tooltip: "Add",
          elevation: 10,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return AddNoteScreen();
            }));
          }),
    );
  }

  read() async {
    List items = await db.getAllData();
    for (var item in items) {
      setState(() {
        _itemList.add(ModelClass.Map(item));
      });
    }
  }

  void _delete(int id, int index) async {
    await db.deleteItem(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }
}

// ignore: must_be_immutable
class Info extends StatelessWidget {
  String data1 = "";
  String data2 = "";
  Info(
    this.data1,
    this.data2,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data1,
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            Text(data2, style: const TextStyle(fontSize: 30))
          ],
        ),
      ),
    );
  }
}
