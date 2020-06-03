class UserModel {
  String name;
  String email;
  String typeUser;
  double lat;
  double lng;

  UserModel({this.name, this.email, this.typeUser, this.lat, this.lng});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    email = json['Email'];
    typeUser = json['TypeUser'];
    lat = json['Lat'];
    lng = json['Lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Email'] = this.email;
    data['TypeUser'] = this.typeUser;
    data['Lat'] = this.lat;
    data['Lng'] = this.lng;
    return data;
  }
}