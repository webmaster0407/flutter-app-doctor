class Experties {
  bool? _success;
  List<Expert>? _expertisedata;
  String? _msg;

  bool? get success => _success;
  List<Expert>? get expertiseData => _expertisedata;
  String? get msg => _msg;

  Experties({
      bool? success, 
      List<Expert>? data,
      String? msg}){
    _success = success;
    _expertisedata = data;
    _msg = msg;
}

  Experties.fromJson(dynamic json) {
    _success = json["success"];
    if (json["data"] != null) {
      _expertisedata = [];
      json["data"].forEach((v) {
        _expertisedata!.add(Expert.fromJson(v));
      });
    }
    _msg = json["msg"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["success"] = _success;
    if (_expertisedata != null) {
      map["data"] = _expertisedata!.map((v) => v.toJson()).toList();
    }
    map["msg"] = _msg;
    return map;
  }

}

class Expert {
  int? _id;
  String? _name;

  int? get id => _id;
  String? get name => _name;

  Expert({
      int? id, 
      String? name}){
    _id = id;
    _name = name;
}

  Expert.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    return map;
  }

}