class ModelClass {
  String _title;
  String _description;
  int _id;

  ModelClass(this._title, this._description);

  ModelClass.Map(dynamic obj) {
    _title = obj["title"];
    _description = obj["description"];
    _id = obj["id"];
  } //ModelClass.map()
  String get title => _title;
  String get description => _description;
  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["title"] = _title;
    map["description"] = _description;
    if (id != null) {
      map["id"] = _id;
    }
    return map;
  }

  ModelClass.fromMap(Map<String, dynamic> map) {
    _title = map["title"];
    _description = map["description"];
    _id = map["id"];
  }
}
