import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_keeper_app/model/model_class.dart';
import 'package:note_keeper_app/ui/addnote_ui.dart';
import 'package:note_keeper_app/ui/updatenote_ui.dart';
import 'package:note_keeper_app/util/database_helper_util.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController titleController=TextEditingController();
  var db=new DatabaseHelper();
  final List<ModelClass>_itemList=<ModelClass>[];
  @override
  void initState() {
    super.initState();
    read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 80,
        shape:OutlineInputBorder(
        borderRadius:BorderRadius.only(bottomLeft: Radius.circular(20),
         ),),
        backgroundColor: Colors.teal.shade900,
        title:Text("Note List"),
        centerTitle: true,
      ),
      body: new ListView.builder(
        itemCount:_itemList.length,
          itemBuilder:(BuildContext context,int index){
          return new Card(
            color:Colors.teal.shade800,
            elevation: 5,
              shape:OutlineInputBorder(borderRadius:
              BorderRadius.only(topLeft:Radius.circular(20.0),
                  topRight: Radius.circular(20.0),bottomLeft: Radius.circular(20))),
            child: ListTile(
              title: Text(_itemList[index].title,
                style: TextStyle(color: Colors.white,fontSize: 20.0),),
              subtitle: Text(_itemList[index].description,
                style: TextStyle(color: Colors.white,fontSize: 12.0),),
              trailing: new IconButton(
                  onPressed: (){
                    _delete(_itemList[index].id,index);
                  },
                  icon: Icon(Icons.remove_circle,color: Colors.redAccent,size: 30,)),
              onLongPress: (){
                Navigator.push(context,MaterialPageRoute(
                    builder: (BuildContext context){
                      return UpdateNoteScreen(_itemList,index);
                    }
                )
                );
              },
            ),
          );

          }
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.teal.shade900,
          child: Icon(Icons.add),
          tooltip: "Add",
          elevation: 10,
          onPressed:(){
            Navigator.push(context, MaterialPageRoute(
                builder:(BuildContext context){
                  return AddNoteScreen();
                }
            )
            );
          }
          ),
    );
  }
  read() async{
    List items=await db.getAllData();
    items.forEach((item) {
      setState(() {
        _itemList.add(ModelClass.Map(item));
      });
    });
  }

  void _delete(int id, int index) async{
    await db.deleteItem(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }
}
