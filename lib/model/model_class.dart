import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class ModelClass {
  String _title;
  String _description;
  int _id;

  ModelClass(this._title, this._description);

  ModelClass.Map(dynamic obj){
    this._title=obj["title"];
    this._description=obj["description"];
    this._id=obj["id"];
  }//ModelClass.map()
  String get title=>_title;
  String get description=>_description;
  int get id=>_id;

  Map<String, dynamic>toMap(){
    var map=new Map<String,dynamic>();
    map["title"]=this._title;
    map["description"]=this._description;
    if(id != null){
      map["id"]=this._id;
    }
    return map;
  }
  ModelClass.fromMap(Map<String,dynamic>map){
    this._title=map["title"];
    this._description=map["description"];
    this._id=map["id"];
  }

}
