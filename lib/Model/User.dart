
class User {

  int id=0;
  String? PersonName;

  User({required this.id, required this.PersonName});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    PersonName = json['PersonName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['PersonName'] = this.PersonName;
    return data;
  }

}