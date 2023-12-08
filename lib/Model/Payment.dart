
class Payment{

  int item_id=0;
  String action="";

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'item_id': item_id,
       'ActionName': action
    };
    if (item_id != null) {
      map['item_id'] = item_id;
      map['ActionName'] = action;
    }
    return map;
  }

  Payment();

  Payment.fromMap(Map<String,dynamic> map) {

    item_id = map['item_id'];
    action = map['ActionName'];

  }

}
