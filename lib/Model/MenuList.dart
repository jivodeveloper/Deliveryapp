
class MenuList {

  late int nodeID;
  late String nodeName;
  late int parentID;
  late Null parentName;
  late Null insertedDate;
  late bool isChecked;
  late Null status;
  late String destination;
  late List<Null> menus;

  MenuList(
      {required this.nodeID,
        required this.nodeName,
        required this.parentID,
        required this.parentName,
        required this.insertedDate,
        required this.isChecked,
        required this.status,
        required this.destination,
        required this.menus});

  MenuList.fromJson(Map<String, dynamic> json) {
    nodeID = json['NodeID'];
    nodeName = json['NodeName'];
    parentID = json['ParentID'];
    parentName = json['parentName'];
    insertedDate = json['insertedDate'];
    isChecked = json['IsChecked'];
    status = json['Status'];
    destination = json['destination'];
    if (json['menus'] != null) {
      menus = <Null>[];
      // json['menus'].forEach((v) {
      //   menus.add(new Null.fromJson(v));
      // }
     // );
    }
  }

  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NodeID'] = this.nodeID;
    data['NodeName'] = this.nodeName;
    data['ParentID'] = this.parentID;
    data['parentName'] = this.parentName;
    data['insertedDate'] = this.insertedDate;
    data['IsChecked'] = this.isChecked;
    data['Status'] = this.status;
    data['destination'] = this.destination;
    // if (this.menus != null) {
    //   data['menus'] = this.menus.map((v) => v!.toJson()).toList();
    // }
    return data;
  }

}